#!/bin/bash

declare -r IMAGE_NAME="miguno/golang-docker-build-tutorial"
declare -r IMAGE_TAG="latest"

echo "Building image '$IMAGE_NAME:$IMAGE_TAG'..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .
