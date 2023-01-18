package internal

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// To demonstrate how to integrate unit testing in a project.
func TestIsIdleToyFunction(t *testing.T) {
	assert.True(t, IsIdleToyFunction())
}
