# harness-ci-demo

A minimal Go web application for demonstrating a Harness CI pipeline that builds a Docker image and pushes it to Docker Hub.

## Run locally

```sh
go run .
```

The application listens on port `8080`.

## Build the Docker image

```sh
docker build -t harness-ci-demo:local .
```

## Run the Docker container

```sh
docker run --rm -p 8080:8080 harness-ci-demo:local
```

## Test the endpoints

```sh
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/version
```

Expected responses:

```json
{"message":"Hello from Harness CI!"}
{"status":"healthy"}
{"version":"1.0.0"}
```
