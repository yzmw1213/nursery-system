package main

import (
	"github.com/yzmw1213/nursery-system/route"
	"os"

	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"
)

func main() {
	router := gin.Default()
	port := os.Getenv("PORT")
	if port == "" {
		port = "9090"
		log.Infof("Defaulting to port %s", port)
	}
	route.IndexRoute(router)
	router.Run(":" + port)
}
