package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/render"

	internal "github.com/miguno/golang-docker-build-tutorial/internal/pkg"
)

// Response is just a basic example.
type Response struct {
	Status string `json:"status,omitempty"`
}

func main() {
	r := chi.NewRouter()

	// Uncomment to enable logging of incoming HTTP requests to STDOUT.
	// Requires `import "github.com/go-chi/chi/v5/middleware"`.
	//r.Use(middleware.Logger)

	r.Get("/status", func(w http.ResponseWriter, r *http.Request) {
		// Create a Response object
		var response Response
		if internal.IsIdleToyFunction() {
			response = Response{Status: "idle"}
		} else {
			response = Response{Status: "busy"}
		}

		render.JSON(w, r, response)
	})
	_ = http.ListenAndServe(":8123", r)
}
