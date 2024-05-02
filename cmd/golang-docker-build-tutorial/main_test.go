package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/require"
)

func executeRequest(req *http.Request, s *Server) *httptest.ResponseRecorder {
	rr := httptest.NewRecorder()
	s.Router.ServeHTTP(rr, req)
	return rr
}

func verifyResponseCode(t *testing.T, expected, actual int) {
	if expected != actual {
		t.Errorf("Expected HTTP response code %d but got %d\n", expected, actual)
	}
}

func TestStatusEndpoint(t *testing.T) {
	s := CreateNewServer()
	s.MountHandlers()

	req, _ := http.NewRequest("GET", "/status", nil)
	res := executeRequest(req, s)

	verifyResponseCode(t, http.StatusOK, res.Code)
	var sr StatusResponse
	_ = json.Unmarshal(res.Body.Bytes(), &sr)
	expectedResponse := StatusResponse{Status: "idle"}
	require.Equal(t, expectedResponse, sr)
}
