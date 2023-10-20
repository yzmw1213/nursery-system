package dao

import (
	"database/sql"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	log "github.com/sirupsen/logrus"

	"github.com/yzmw1213/nursery-system/conf"
	"github.com/yzmw1213/nursery-system/entity"
)

type NurseryFacilityDao struct {
	db *sql.DB
}

func NewNurseryFacilityDao() *NurseryFacilityDao {
	return &NurseryFacilityDao{
		DB(),
	}
}

func (d *NurseryFacilityDao) GetCount(tx *sql.Tx, in *entity.NurseryFacility) (count int64, err error) {
	log.Infof("NurseryFacilityDao.GetCount %v", in)
	query := `
SELECT
	count(nf.nursery_facility_id)
FROM
	nursery_db.nursery_facilitys nf
WHERE
	nf.delete_flag = ?
`
	params := []interface{}{
		in.DeleteFlag,
	}
	var whereString []string

	if in.NurseryFacilityID > 0 {
		whereString = append(whereString, " nf.nursery_facility_id = ? ")
		params = append(params, in.NurseryFacilityID)
	}
	if len(in.Name) > 0 {
		whereString = append(whereString, " nf.name LIKE ? ")
		params = append(params, "%"+in.Name+"%")
	}

	if len(whereString) > 0 {
		query += " WHERE " + strings.Join(whereString, " AND ")
	}
	log.Infof("query:%s params:%v", query, params)

	if tx != nil {
		err = tx.QueryRow(query, params...).Scan(&count)
	} else {
		err = d.db.QueryRow(query, params...).Scan(&count)
	}
	if err != nil {
		if err != sql.ErrNoRows {
			log.Errorf("Error Query %v", err)
			return
		}
	}
	return
}

func (d *NurseryFacilityDao) Get(tx *sql.Tx, in *entity.NurseryFacility, limit, offset int64) (list []*entity.NurseryFacility, err error) {
	log.Infof("NurseryFacilityDao.Get %v", in)
	query := `
SELECT
	nf.nursery_facility_id,
	nf.name,
	nf.delete_flag,
	nf.update_user_id,
	nf.created,
	nf.updated
FROM
	nursery_db.nursery_facilitys AS nf
INNER JOIN user_db.users uu ON uu.user_id = cu.user_id
WHERE
	cu.delete_flag = ?
`
	params := []interface{}{
		in.DeleteFlag,
	}
	var whereString []string

	if in.NurseryFacilityID > 0 {
		whereString = append(whereString, " nf.nursery_facility_id = ? ")
		params = append(params, in.NurseryFacilityID)
	}
	if len(in.Name) > 0 {
		whereString = append(whereString, " nf.name LIKE ? ")
		params = append(params, "%"+in.Name+"%")
	}

	if len(whereString) > 0 {
		query += " AND " + strings.Join(whereString, " AND ")
	}
	query += ` ORDER BY uu.user_id DESC `
	query += ` LIMIT ?,?`
	params = append(params, offset)
	params = append(params, limit)

	log.Infof("query:%s params:%v", query, params)
	var rows *sql.Rows
	if tx != nil {
		rows, err = tx.Query(query, params...)
	} else {
		rows, err = d.db.Query(query, params...)
	}
	if err != nil {
		if err != sql.ErrNoRows {
			log.Errorf("Error Query %v", err)
		}
		return
	}
	defer func() {
		err := rows.Close()
		if err != nil {
			log.Errorf("Error Rows Close:%v", err)
		}
	}()

	list = []*entity.NurseryFacility{}
	for rows.Next() {
		row := entity.NurseryFacility{}
		if e := rows.Scan(
			&row.NurseryFacilityID,
			&row.Name,
			&row.DeleteFlag,
			&row.UpdateUserID,
			&row.Created,
			&row.Updated,
		); e != nil {
			list = []*entity.NurseryFacility{}
			err = e
			log.Errorf("Error Scan %v", err)
		}
		list = append(list, &row)
	}

	return
}

func (d *NurseryFacilityDao) GetEnable(tx *sql.Tx, in *entity.NurseryFacility, limit, offset int64) (list []*entity.NurseryFacility, err error) {
	log.Infof("NurseryFacilityDao.GetEnable %v", in)
	in.DeleteFlag = conf.DeleteFlagOFF
	return d.Get(tx, in, limit, offset)
}

func (d *NurseryFacilityDao) GetDisable(tx *sql.Tx, in *entity.NurseryFacility, limit, offset int64) (list []*entity.NurseryFacility, err error) {
	log.Infof("NurseryFacilityDao.GetDisable %v", in)
	in.DeleteFlag = conf.DeleteFlagON
	return d.Get(tx, in, limit, offset)
}

func (d *NurseryFacilityDao) Save(tx *sql.Tx, in *entity.NurseryFacility) (id int64, err error) {
	log.Infof("NurseryFacilityDao.Save %v", in)

	query := `
INSERT INTO nursery_db.nursery_facilitys
(
	name,
	update_user_id
) VALUES (?,?)                
`
	params := []interface{}{
		in.Name,
		in.UpdateUserID,
	}
	log.Infof("query: %v param: %v", query, params)

	var result sql.Result

	if tx != nil {
		result, err = tx.Exec(query, params...)
	} else {
		result, err = d.db.Exec(query, params...)
	}
	if err != nil {
		log.Errorf("error query %v", err)
		return
	}
	id, err = result.LastInsertId()
	log.Infof("LastInsertId ID  %d", id)
	return
}

func (d *NurseryFacilityDao) UpdateName(tx *sql.Tx, in *entity.NurseryFacility) (id int64, err error) {
	log.Infof("NurseryFacilityDao.UpdateName %v ", in)

	query := `
UPDATE nursery_db.nursery_facilitys
SET
	name = ?,
	update_user_id = ?
WHERE
	nursery_facility_id = ?
`
	params := []interface{}{
		in.Name,
		in.UpdateUserID,
		in.NurseryFacilityID,
	}
	log.Infof("query: %v param: %v", query, params)

	var result sql.Result

	if tx != nil {
		result, err = tx.Exec(query, params...)
	} else {
		result, err = d.db.Exec(query, params...)
	}
	if err != nil {
		log.Errorf("error query %v", err)
		return
	}
	id, err = result.RowsAffected()
	log.Infof("RowsAffected ID  %d", id)
	return
}

func (d *NurseryFacilityDao) UpdateDeleteFlag(tx *sql.Tx, nurseryFacilityID int64, deleteFlag bool, updateUserID int64) (id int64, err error) {
	log.Infof("NurseryFacilityDao.UpdateDeleteFlag %v %v %v", nurseryFacilityID, deleteFlag, updateUserID)
	var params []interface{}
	query := `
UPDATE nursery_db.nursery_facilitys
SET
	delete_flag = ?,
	update_user_id = ?
WHERE
	nursery_facility_id = ?
`
	params = append(params, deleteFlag)
	params = append(params, updateUserID)
	params = append(params, nurseryFacilityID)
	log.Infof("query: %v param: %v", query, params)

	var result sql.Result

	if tx != nil {
		result, err = tx.Exec(query, params...)
	} else {
		result, err = d.db.Exec(query, params...)
	}
	if err != nil {
		log.Errorf("error query %v", err)
		return
	}
	id, err = result.RowsAffected()
	log.Infof("RowsAffected ID  %d", id)
	return
}
