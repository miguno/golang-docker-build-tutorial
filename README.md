# Tutorial: Create a Docker image for a Go application

[![Build Status](https://travis-ci.org/miguno/golang-docker-build-tutorial.svg?branch=master)](https://travis-ci.org/miguno/golang-docker-build-tutorial)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A template project to create a Docker image for a Go application.
The example application exposes an HTTP endpoint.

The Docker build uses a [multi-stage build setup](https://docs.docker.com/develop/develop-images/multistage-build/)
to minimize the size of the generated Docker image.  The Go build uses [dep](https://github.com/golang/dep) for
dependency management.

> **Java developer?** Check out https://github.com/miguno/java-docker-build-tutorial


# Requirements

Docker must be installed. That's it. You do not need to have Go installed.


# Usage and Demo

**Step 1:** Create the Docker image according to [Dockerfile](Dockerfile).
This step uses Maven to build, test, and package the [Go application](app.go).
The resulting image is 7MB in size.

```shell
# This may take a few minutes.
$ docker build -t miguno/golang-docker-build-tutorial:latest .
```

**Step 2:** Start a container for the Docker image.

```shell
$ docker run -p 8123:8123 miguno/golang-docker-build-tutorial:latest
```

**Step 3:** Open another terminal and access the example API endpoint.

```shell
$ curl http://localhost:8123/status
{"status": "idle"}
```


# Notes

You can run the Go application locally if you have Go installed.

```shell
# Build and run the application
$ go run app.go
```
