package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/render"

	internal "github.com/miguno/golang-docker-build-tutorial/internal/pkg"
)

type Server struct {
	Router *chi.Mux
	// Other configs such as DB settings can be added here
}

func CreateNewServer() *Server {
	s := &Server{}
	s.Router = chi.NewRouter()
	// Uncomment to enable logging of incoming HTTP requests to STDOUT.
	// Requires `import "github.com/go-chi/chi/v5/middleware"`.
	//s.Router.Use(middleware.Logger)
	return s
}

// StatusResponse is just a basic example.
type StatusResponse struct {
	Status string `json:"status,omitempty"`
}

func (s *Server) MountHandlers() {
	// Mount all Middleware here
	s.Router.Use(middleware.Logger)

	// Mount all handlers here
	s.Router.Get("/status", func(w http.ResponseWriter, r *http.Request) {
		// Create a Response object
		var response StatusResponse
		if internal.IsIdleToyFunction() {
			response = StatusResponse{Status: "idle"}
		} else {
			response = StatusResponse{Status: "busy"}
		}

		render.JSON(w, r, response)
	})

}

func main() {
	s := CreateNewServer()
	s.MountHandlers()
	err := http.ListenAndServe(":8123", s.Router)
	if err != nil {
		panic(err)
	}
}
