package route

import (
	"github.com/gin-gonic/gin"

	"github.com/yzmw1213/nursery-system/handle"
)

// @tag.name nursery-facility
// @tag.description 保育施設

func IndexRoute(router *gin.Engine) {
	indexHandler := handle.NewIndexHandler()
	nurseryFacilityHandler := handle.NewNurseryFacilityHandler()
	router.GET("/", indexHandler.IndexHandle)

	router.GET("/nursery-facility", nurseryFacilityHandler.GetHandle)
	router.POST("/nursery-facility", nurseryFacilityHandler.SaveHandle)
	router.DELETE("/nursery-facility", nurseryFacilityHandler.DeleteHandle)
}
