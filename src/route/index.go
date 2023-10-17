package route

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"

	"github.com/yzmw1213/nursery-system/util"
)

func IndexRoute(router *gin.Engine) {
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
	} )
}
