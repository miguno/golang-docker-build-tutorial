package main

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

// Response is just a very basic example.
type Response struct {
	Status string `json:"status,omitempty"`
}

// GetStatus returns always the same response.
func GetStatus(w http.ResponseWriter, _ *http.Request) {
	b := Response{Status: "idle"}
	json.NewEncoder(w).Encode(b)
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/status", GetStatus).Methods("GET")
	log.Fatal(http.ListenAndServe(":8123", router))
}
