package handle

import (
	"errors"

	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"
	"github.com/yzmw1213/nursery-system/service"
	"github.com/yzmw1213/nursery-system/util"
)

type NurseryFacilityHandler struct {
	nurseryFacilityService *service.NurseryFacilityService
}

func NewNurseryFacilityHandler() *NurseryFacilityHandler {
	return &NurseryFacilityHandler{
		service.NewNurseryFacilityService(),
	}
}

// GetHandle godoc
// @tags nursery-facility
// @Summary 保育施設取得
// @Description 保育施設を取得する
// @Accept  json
// @Produce  json
// @Security ApiKeyAuth
// @param requestBody query service.InputGetNurseryFacility true "検索パラメータ"
// @Success 200 {object} util.OutputBasicListPaging{list=[]entity.NurseryFacility}
// @failure 400 {object} util.OutputBasic{message=string} "{code: 400, result: NG, message: error_string}"
// @failure 500 {object} util.OutputBasic{message=string} "{code: 500, result: NG, message: error_string}"
// @Router /nursery-facility [get]
func (h *NurseryFacilityHandler) GetHandle(c *gin.Context) {
	userID, _ := c.Get("user_id")
	log.Infof("GetHandle start %v", userID.(int64))

	var in service.InputGetNurseryFacility
	if err := c.ShouldBind(in); err != nil {
		util.BadRequestJson(*c, err)
		return
	}
	out := h.nurseryFacilityService.Get(in.GetParam())
	c.JSON(
		out.GetCode(),
		out.GetResult(),
	)
}

// SaveHandle godoc
// @tags nursery-facility
// @Summary 保育施設登録
// @Description 保育施設を登録する
// @Accept  json
// @Produce  json
// @Security ApiKeyAuth
// @param requestBody body service.InputSaveNurseryFacility true "パラメータ"
// @Success 200 {object} util.OutputBasicObject{row=entity.NurseryFacility}
// @failure 400 {object} util.OutputBasic{message=string} "{code: 400, result: NG, message: error_string}"
// @failure 500 {object} util.OutputBasic{message=string} "{code: 500, result: NG, message: error_string}"
// @Router /nursery-facility [post]
func (h *NurseryFacilityHandler) SaveHandle(c *gin.Context) {
	userID, _ := c.Get("user_id")
	log.Infof("SaveHandle start %v", userID.(int64))

	var in service.InputSaveNurseryFacility
	if err := c.ShouldBind(in); err != nil {
		util.BadRequestJson(*c, err)
		return
	}
	// TODO バリデーションライブラリを適用する
	if in.Name == "" {
		util.BadRequestJson(*c, errors.New("request invalid"))
		return
	}
	in.UpdateUserID = userID.(int64)
	out := h.nurseryFacilityService.Save(&in)
	c.JSON(
		out.GetCode(),
		out.GetResult(),
	)
}

// DeleteHandle godoc
// @tags nursery-facility
// @Summary 保育施設削除
// @Description 保育施設を削除する
// @Accept  json
// @Produce  json
// @Security ApiKeyAuth
// @param requestBody query service.InputDeleteNurseryFacility true "パラメータ"
// @Success 200 {object} util.OutputBasic{message=string} "{code: 200, result: OK, message: OK}"
// @failure 400 {object} util.OutputBasic{message=string} "{code: 400, result: NG, message: error_string}"
// @failure 500 {object} util.OutputBasic{message=string} "{code: 500, result: NG, message: error_string}"
// @Router /nursery-facility [delete]
func (h *NurseryFacilityHandler) DeleteHandle(c *gin.Context) {
	userID, _ := c.Get("user_id")
	log.Infof("DeleteHandle start %v", userID.(int64))

	var in service.InputDeleteNurseryFacility
	if err := c.ShouldBind(in); err != nil {
		util.BadRequestJson(*c, err)
		return
	}
	// TODO バリデーションライブラリを適用する
	if in.NurseryFacilityID == 0 {
		util.BadRequestJson(*c, errors.New("request invalid"))
		return
	}
	in.UpdateUserID = userID.(int64)
	out := h.nurseryFacilityService.Delete(&in)
	c.JSON(
		out.GetCode(),
		out.GetResult(),
	)
}
