#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# `-u`: Errors if a variable is referenced before being set
# `-o pipefail`: Prevent errors in a pipeline (`|`) from being masked
set -uo pipefail

# Import environment variables from .env
set -o allexport && source .env && set +o allexport
echo "Starting container for image '$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG', exposing port ${APP_PORT}/tcp"
echo "- Run 'curl http://localhost:${APP_PORT}/status' to send a test request to the containerized app."
echo "- Enter Ctrl-C to stop the container."
docker run -p "$APP_PORT:$APP_PORT" "$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_TAG"
