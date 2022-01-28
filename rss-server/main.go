package main

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type blogPost struct {
}

func main() {
	router := httprouter.New()
	router.GET("/", route)
	http.ListenAndServe(":11047", router)
}

func route(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {

}
