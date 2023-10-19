package handle

import (
	"net/http"

	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"
	"github.com/yzmw1213/nursery-system/util"
)

type IndexHandler struct{}

func NewIndexHandler() *IndexHandler {
	return &IndexHandler{}
}
func (h *IndexHandler) IndexHandle(c *gin.Context) {
	log.Infof("IndexHandle start")
	res := &util.OutputBasic{
		Code:    http.StatusOK,
		Result:  "OK",
		Message: "OK",
	}
	c.JSON(
		res.GetCode(),
		res.GetResult(),
	)
}
