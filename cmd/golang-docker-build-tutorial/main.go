package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"

	internal "github.com/miguno/golang-docker-build-tutorial/internal/pkg"
)

// Response is just a basic example.
type Response struct {
	Status string `json:"status,omitempty"`
}

func GetStatus(w http.ResponseWriter, _ *http.Request) {
	var response Response
	if internal.IsIdleToyFunction() {
		response = Response{Status: "idle"}
	} else {
		response = Response{Status: "busy"}
	}
	json.NewEncoder(w).Encode(response)
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/status", GetStatus).Methods("GET")
	log.Fatal(http.ListenAndServe(":8123", router))
}
