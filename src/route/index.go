package route

import (
	"net/http"

	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"

	"github.com/yzmw1213/nursery-system/handle"
	"github.com/yzmw1213/nursery-system/util"
)

// @tag.name nursery-facility
// @tag.description 保育施設

func IndexRoute(router *gin.Engine) {
	nurseryFacilityHandler := handle.NewNurseryFacilityHandler()
	router.GET("/", func(c *gin.Context) {
		log.Infof("IndexHandler start")
		res := &util.OutputBasic{
			Code:    http.StatusOK,
			Result:  "OK",
			Message: "OK",
		}
		c.JSON(
			res.GetCode(),
			res.GetResult(),
		)
	})

	router.GET("/nursery-facility", nurseryFacilityHandler.GetHandle)
	router.POST("/nursery-facility", nurseryFacilityHandler.SaveHandle)
	router.DELETE("/nursery-facility", nurseryFacilityHandler.DeleteHandle)
}
