#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# `-u`: Errors if a variable is referenced before being set
# `-o pipefail`: Prevent errors in a pipeline (`|`) from being masked
set -uo pipefail

# Import environment variables from .env
set -o allexport && source .env && set +o allexport

# Set variable from environment variable PROJECT_VERSION, if the latter exists.
# If not, fall back to the specified default value (excluding the leading `-`).
declare -r project_version="${PROJECT_VERSION:-1.0.0-alpha}"

echo "Building image '$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG'..."
# Use BuildKit, i.e. `buildx build` instead of just `build`
# https://docs.docker.com/build/
docker buildx build --build-arg PROJECT_VERSION=${project_version} -t "$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_TAG" .
