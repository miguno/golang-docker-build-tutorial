# syntax=docker/dockerfile:1

# We use a multi-stage build setup.
# (https://docs.docker.com/build/building/multi-stage/)

# Stage 1 (to create a "build" image, ~850MB)
FROM golang:1.19.4 AS builder
RUN go version

COPY . /go/src/github.com/miguno/golang-docker-build-tutorial/
WORKDIR /go/src/github.com/miguno/golang-docker-build-tutorial/
RUN set -Eeux && \
    go mod download && \
    go mod verify

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-w -s" -a -o app cmd/golang-docker-build-tutorial/main.go

# Stage 2 (to create a downsized "container executable", ~7MB)

# If you need SSL certificates for HTTPS, replace `FROM SCRATCH` with:
#
#   FROM alpine:3.17.1
#   RUN apk --no-cache add ca-certificates
#
FROM scratch
WORKDIR /root/
COPY --from=builder /go/src/github.com/miguno/golang-docker-build-tutorial/app .

EXPOSE 8123
ENTRYPOINT ["./app"]
