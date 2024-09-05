# This justfile requires https://github.com/casey/just

# Load environment variables from `.env` file.
set dotenv-load

timestamp := `date +%s`

semver := env_var('PROJECT_VERSION')
commit := `git show -s --format=%h`
version := semver + "+" + commit

coverage_profile_log := "coverage_profile.txt"

# print available targets
default:
    @just --list --justfile {{justfile()}}

# evaluate and print all just variables
evaluate:
    @just --evaluate

# print system information such as OS and architecture
system-info:
  @echo "architecture: {{arch()}}"
  @echo "os: {{os()}}"
  @echo "os family: {{os_family()}}"

# detect known vulnerabilities (requires https://github.com/sonatype-nexus-community/nancy)
audit:
    go list -json -m all | nancy sleuth --loud

# benchmark the app's HTTP endpoint with plow (requires https://github.com/six-ddc/plow)
benchmark-plow:
    @echo plow -c 100 --duration=30s http://localhost:${APP_PORT}/status
    @plow      -c 100 --duration=30s http://localhost:${APP_PORT}/status

# benchmark the app's HTTP endpoint with wrk (requires https://github.com/wg/wrk)
benchmark-wrk:
    @echo wrk -t 10 -c 100 --latency --duration 30 http://localhost:${APP_PORT}/status
    @wrk      -t 10 -c 100 --latency --duration 30 http://localhost:${APP_PORT}/status

# build executable for local OS
build: test-vanilla
    @echo "Building executable for local OS ..."
    go build -trimpath -ldflags="-X 'main.Version={{version}}'" -o app cmd/golang-docker-build-tutorial/main.go

# show test coverage
coverage:
    go test -coverprofile={{coverage_profile_log}} ./...
    go tool cover -html={{coverage_profile_log}}

# show dependencies
deps:
    go mod graph

# create a docker image (requires Docker)
docker-image-create:
    @echo "Creating a docker image ..."
    @PROJECT_VERSION={{version}} ./create_image.sh

# run the docker image (requires Docker)
docker-image-run:
    @echo "Running container from docker image ..."
    @./start_container.sh

# size of the docker image (requires Docker)
docker-image-size:
    @docker images $DOCKER_IMAGE_NAME

# explain lint identifier (e.g., "SA1006")
explain lint-identifier:
    staticcheck -explain {{lint-identifier}}

# format source code
format:
    @echo "Formatting source code ..."
    gofmt -l -s -w .

# run linters (requires https://github.com/dominikh/go-tools)
lint:
    staticcheck -f stylish ./... || \
        (echo "\nRun \`just explain <LintIdentifier, e.g. SA1006>\` for details." && \
        exit 1)

# detect outdated modules (requires https://github.com/psampaz/go-mod-outdated)
outdated:
    go list -u -m -json all | go-mod-outdated -update

# build release executables for all supported platforms
release: test-vanilla
    @echo "Building release executables (incl. cross compilation) ..."
    # `go tool dist list` shows supported architectures (GOOS)
    GOOS=darwin GOARCH=arm64 \
        go build -trimpath -ldflags "-X 'main.Version={{version}}' -s -w" -o app_macos-arm64 cmd/golang-docker-build-tutorial/main.go
    GOOS=linux  GOARCH=386 \
        go build -trimpath -ldflags "-X 'main.Version={{version}}' -s -w" -o app_linux-386   cmd/golang-docker-build-tutorial/main.go
    GOOS=linux  GOARCH=amd64 \
        go build -trimpath -ldflags "-X 'main.Version={{version}}' -s -w" -o app_linux-amd64 cmd/golang-docker-build-tutorial/main.go
    GOOS=linux  GOARCH=arm \
        go build -trimpath -ldflags "-X 'main.Version={{version}}' -s -w" -o app_linux-arm   cmd/golang-docker-build-tutorial/main.go
    GOOS=linux  GOARCH=arm64 \
        go build -trimpath -ldflags "-X 'main.Version={{version}}' -s -w" -o app_linux-arm64 cmd/golang-docker-build-tutorial/main.go

# run executable for local OS
run:
    @echo "Running golang-docker-build-tutorial with defaults ..."
    go run -ldflags="-X 'main.Version={{version}}'" cmd/golang-docker-build-tutorial/main.go

# send request to the app's HTTP endpoint (requires curl and running container)
send-request-to-app:
    @curl http://localhost:${APP_PORT}/status

# run tests with colorized output (requires https://github.com/kyoh86/richgo)
test *FLAGS:
    richgo test -cover {{FLAGS}} ./...

# run tests (vanilla), used for CI workflow
test-vanilla *FLAGS:
    go test -cover {{FLAGS}} ./...

# add missing module requirements for imported packages, removes requirements that aren't used anymore
tidy:
    go mod tidy

# detect known vulnerabilities (requires https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
vulnerabilities:
    govulncheck ./...

# watch sources for changes and trigger a rebuild (requires https://github.com/watchexec/watchexec)
watch:
    # Watch all go files in the current directory and all subdirectories for
    # changes.  If something changed, re-run the build.
    @watchexec -e go -- just build
