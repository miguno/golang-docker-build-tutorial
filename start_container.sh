#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# `-u`: Errors if a variable is referenced before being set
# `-o pipefail`: Prevent errors in a pipeline (`|`) from being masked
set -uo pipefail

declare -r IMAGE_NAME="miguno/golang-docker-build-tutorial"
declare -r IMAGE_TAG="latest"
declare -r APP_PORT="8123"

echo "Starting container for image '$IMAGE_NAME:$IMAGE_TAG', exposing port $APP_PORT/tcp"
docker run -p "$APP_PORT":"$APP_PORT" "$IMAGE_NAME":"$IMAGE_TAG"

