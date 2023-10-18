package service

import (
	"database/sql"
	"errors"
	"net/http"

	log "github.com/sirupsen/logrus"

	"github.com/yzmw1213/nursery-system/dao"
	"github.com/yzmw1213/nursery-system/entity"
	"github.com/yzmw1213/nursery-system/util"
)

type NurseryFacilityService struct {
	db                 *sql.DB
	nurseryFacilityDao *dao.NurseryFacilityDao
}

func NewNurseryFacilityService() *NurseryFacilityService {
	return &NurseryFacilityService{
		dao.DB(),
		dao.NewNurseryFacilityDao(),
	}
}

func (s *NurseryFacilityService) GetDB() *sql.DB {
	return s.db
}

type InputGetNurseryFacility struct {
	NurseryFacilityID int64  `json:"nursery_facility_id" query:"nursery_facility_id"` // 保育施設ID
	Name              string `json:"name" query:"name"`                               // 名前
	Page              int64  `json:"page" query:"page"`                               // ページ番号
	Limit             int64  `json:"limit" query:"limit"`                             // リミット
	Offset            int64  `json:"-"`
}

func (in *InputGetNurseryFacility) GetParam() *InputGetNurseryFacility {
	if in.Limit <= 0 {
		in.Limit = 1000
	}
	if in.Page <= 1 {
		in.Page = 1
	}
	in.Offset = (in.Page - 1) * in.Limit
	return in
}

func (s *NurseryFacilityService) Get(in *InputGetNurseryFacility) util.OutputBasicInterface {
	log.Infof("Get start %v", in)
	facility := &entity.NurseryFacility{
		NurseryFacilityID: in.NurseryFacilityID,
		Name:              in.Name,
	}
	count, err := s.nurseryFacilityDao.GetCount(nil, facility)
	if err != nil {
		log.Errorf("Error nurseryFacilityDao.GetCount %v", err)
		return &util.OutputBasic{
			Code:    http.StatusInternalServerError,
			Result:  "NG",
			Message: err,
		}
	}

	list, err := s.nurseryFacilityDao.GetEnable(nil, facility, in.Limit, in.Offset)
	if err != nil {
		log.Errorf("Error nurseryFacilityDao.GetEnable %v", err)
		return &util.OutputBasic{
			Code:    http.StatusInternalServerError,
			Result:  "NG",
			Message: err,
		}
	}
	return util.NewOutputBasicListPaging(
		list,
		count,
		int64(len(list)),
		in.Page,
		in.Limit,
	)
}

type InputSaveNurseryFacility struct {
	NurseryFacilityID int64  `json:"nursery_facility_id" form:"nursery_facility_id"` // 保育施設ID
	Name              string `json:"name" form:"name"`                               // 名前
	UpdateUserID      int64  `json:"-" form:"-"`
}

func (s *NurseryFacilityService) Save(in *InputSaveNurseryFacility) util.OutputBasicInterface {
	out := util.ExecTransactionService(s, func(tx *sql.Tx) util.OutputBasicServiceInterface {
		return s.txSave(tx, in)
	})
	return out
}

func (s *NurseryFacilityService) txSave(tx *sql.Tx, in *InputSaveNurseryFacility) util.OutputBasicServiceInterface {
	log.Infof("Save start")
	if in.NurseryFacilityID == 0 {
		lastID, err := s.nurseryFacilityDao.Save(tx, &entity.NurseryFacility{
			Name:         in.Name,
			UpdateUserID: in.UpdateUserID,
		})
		if err != nil {
			log.Errorf("Error nurseryFacilityDao.Save %v", err)
			return &util.OutputBasic{
				Code:    http.StatusInternalServerError,
				Result:  "NG",
				Message: err,
			}
		}
		if lastID == 0 {
			err = errors.New("save Failed: Invalid ID")
			return &util.OutputBasic{
				Code:    http.StatusInternalServerError,
				Result:  "NG",
				Message: err,
			}
		}
		in.NurseryFacilityID = lastID
	} else {
		_, err := s.nurseryFacilityDao.UpdateName(tx, &entity.NurseryFacility{
			NurseryFacilityID: in.NurseryFacilityID,
			Name:              in.Name,
			UpdateUserID:      in.UpdateUserID,
		})
		if err != nil {
			log.Errorf("Error nurseryFacilityDao.UpdateName %v", err)
			return &util.OutputBasic{
				Code:    http.StatusInternalServerError,
				Result:  "NG",
				Message: err,
			}
		}
	}
	list, err := s.nurseryFacilityDao.Get(tx, &entity.NurseryFacility{
		NurseryFacilityID: in.NurseryFacilityID,
	}, 1, 0)
	if err != nil || len(list) != 1 {
		log.Errorf("Error Get %v", err)
		return &util.OutputBasic{
			Code:    http.StatusInternalServerError,
			Result:  "Error nurseryFacilityDao.Get",
			Message: err,
		}
	}
	return util.NewOutputBasicObject(interface{}(list[0]))
}

type InputDeleteNurseryFacility struct {
	NurseryFacilityID int64 `json:"nursery_facility_id" query:"nursery_facility_id"` // 保育施設ID
	DeleteFlag        bool  `json:"-" form:"-"`
	UpdateUserID      int64 `json:"-" form:"-"`
}

func (s *NurseryFacilityService) Delete(in *InputDeleteNurseryFacility) util.OutputBasicInterface {
	out := util.ExecTransactionService(s, func(tx *sql.Tx) util.OutputBasicServiceInterface {
		return s.txUpdateDeleteFlag(tx, in)
	})
	return out
}

func (s *NurseryFacilityService) txUpdateDeleteFlag(tx *sql.Tx, in *InputDeleteNurseryFacility) util.OutputBasicServiceInterface {
	log.Infof("UpdateDeleteFlag start %v", in)

	// TODO 職員の登録がある場合は、削除不可とする
	affectedRows, err := s.nurseryFacilityDao.UpdateDeleteFlag(tx, in.NurseryFacilityID, in.DeleteFlag, in.UpdateUserID)
	if err != nil {
		log.Errorf("Error nurseryFacilityDao.UpdateDeleteFlag %v", err)
		return &util.OutputBasic{
			Code:    http.StatusInternalServerError,
			Result:  "NG",
			Message: err,
		}
	}
	if affectedRows == 0 {
		log.Infof("no update affected rows %v", affectedRows)
	}
	log.Infof("sales_agency deleted ID:%v", in.NurseryFacilityID)

	return &util.OutputBasic{
		Code:    http.StatusOK,
		Result:  "OK",
		Message: "OK",
	}
}
