#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# `-u`: Errors if a variable is referenced before being set
# `-o pipefail`: Prevent errors in a pipeline (`|`) from being masked
set -uo pipefail

declare -r IMAGE_NAME="miguno/golang-docker-build-tutorial"
declare -r IMAGE_TAG="latest"

echo "Building image '$IMAGE_NAME:$IMAGE_TAG'..."
# Use BuildKit, i.e. `buildx build` instead of just `build`
# https://docs.docker.com/build/
docker buildx build -t "$IMAGE_NAME":"$IMAGE_TAG" .
