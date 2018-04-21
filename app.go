package main

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"encoding/json"
)

type Response struct {
	Status string `json:"status,omitempty"`
}

func GetStatus(w http.ResponseWriter, _ *http.Request) {
	b := Response{Status: "idle"}
	json.NewEncoder(w).Encode(b)
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/status", GetStatus).Methods("GET")
	log.Fatal(http.ListenAndServe(":8123", router))
}
