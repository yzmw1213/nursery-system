package route

import (
	"github.com/gin-gonic/gin"
	"github.com/yzmw1213/nursery-system/conf"
	"github.com/yzmw1213/nursery-system/middleware"

	"github.com/yzmw1213/nursery-system/handle"
)

// @tag.name nursery-facility
// @tag.description 保育施設

func IndexRoute(router *gin.Engine) {
	indexHandler := handle.NewIndexHandler()
	nurseryFacilityHandler := handle.NewNurseryFacilityHandler()

	customClaimSystemAdmin := []string{conf.CustomUserClaimAdmin}

	router.GET("/", indexHandler.IndexHandle)

	router.GET("/nursery-facility", middleware.AuthAPI(nurseryFacilityHandler.GetHandle, customClaimSystemAdmin))
	router.POST("/nursery-facility", middleware.AuthAPI(nurseryFacilityHandler.SaveHandle, customClaimSystemAdmin))
	router.DELETE("/nursery-facility", middleware.AuthAPI(nurseryFacilityHandler.DeleteHandle, customClaimSystemAdmin))
}
