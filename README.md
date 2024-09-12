# Project Template: Create a Docker image for a Go application

[![GitHub forks](https://img.shields.io/github/forks/miguno/golang-docker-build-tutorial)](https://github.com/miguno/golang-docker-build-tutorial/fork)
[![Docker workflow status](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/docker-image.yml)
[![Go workflow status](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/go.yml/badge.svg)](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/go.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A template project to create a Docker image for a Go application.
The example application exposes an HTTP endpoint.

> [!TIP]
>
> **Java developer?** Check out https://github.com/miguno/java-docker-build-tutorial

Features:

- The Docker build uses a
  [multi-stage build setup](https://docs.docker.com/build/building/multi-stage/)
  to minimize the size of the generated Docker image, which is 5MB
- Supports [Docker BuildKit](https://docs.docker.com/build/)
- Golang 1.22
- [GitHub Actions workflows](https://github.com/miguno/golang-docker-build-tutorial/actions) for
  [Golang](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/go.yml)
  and
  [Docker](https://github.com/miguno/golang-docker-build-tutorial/actions/workflows/docker-image.yml)
- Optionally, uses
  [just](https://github.com/casey/just)
  ![](https://img.shields.io/github/stars/casey/just)
  for running common commands conveniently, see [justfile](justfile).
- Uses [.env](.env) as central configuration to set variables used by
  [justfile](justfile) and other helper scripts in this project.

# Requirements

Docker must be installed on your local machine. That's it. You do not need to
have Go installed.

# Usage and Demo

**Step 1:** Create the Docker image according to [Dockerfile](Dockerfile).
This step builds, tests, and packages the [Go application](app.go).
The resulting image is 5MB in size.

```shell
# ***Creating an image may take a few minutes!***
$ docker build --build-arg PROJECT_VERSION=1.0.0-alpha -t miguno/golang-docker-build-tutorial:latest .

# You can also build with the new BuildKit.
# https://docs.docker.com/build/
$ docker buildx build --build-arg PROJECT_VERSION=1.0.0-alpha -t miguno/golang-docker-build-tutorial:latest .
```

Optionally, you can check the size of the generated Docker image:

```shell
$ docker images miguno/golang-docker-build-tutorial
REPOSITORY                            TAG       IMAGE ID       CREATED          SIZE
miguno/golang-docker-build-tutorial   latest    2de05b854c1b   11 minutes ago   4.78MB
```

**Step 2:** Start a container for the Docker image.

```shell
$ docker run -p 8123:8123 miguno/golang-docker-build-tutorial:latest
```

**Step 3:** Open another terminal and access the example API endpoint of the
running container.

```shell
$ curl http://localhost:8123/status
{"status": "idle"}
```

# Usage with just

If you have [just](https://github.com/casey/just) installed, you can run the
commands above more conveniently:

```shell
$ just
Available recipes:
    audit                   # detect known vulnerabilities (requires https://github.com/sonatype-nexus-community/nancy)
    build                   # build executable for local OS
    coverage                # show test coverage
    default                 # print available targets
    deps                    # show dependencies
    docker-image-create     # create a docker image (requires Docker)
    docker-image-run        # run the docker image (requires Docker)
    docker-image-size       # size of the docker image (requires Docker)
    evaluate                # evaluate and print all just variables
    explain lint-identifier # explain lint identifier (e.g., "SA1006")
    format                  # format source code
    lint                    # run linters (requires https://github.com/dominikh/go-tools)
    outdated                # detect outdated modules (requires https://github.com/psampaz/go-mod-outdated)
    release                 # build release executables for all supported platforms
    run                     # run executable for local OS
    send-request-to-app     # send request to the app's HTTP endpoint (requires running container)
    system-info             # print system information such as OS and architecture
    test *FLAGS             # run tests with colorized output (requires https://github.com/kyoh86/richgo)
    test-vanilla *FLAGS     # run tests (vanilla), used for CI workflow
    tidy                    # add missing module requirements for imported packages, removes requirements that aren't used anymore
    vulnerabilities         # detect known vulnerabilities (requires https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
```

Example:

```shell
$ just docker-image-create
$ just docker-image-run
```

# Notes

You can run the Go application locally if you have Go installed.
See [justfile](justfile) for additional commands and options.

```shell
# Build
$ go build -trimpath -ldflags="-w -s" -v -o app cmd/golang-docker-build-tutorial/main.go

# Test
$ go test -cover -v ./...

# Run
$ ./app
```
