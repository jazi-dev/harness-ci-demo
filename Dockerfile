FROM golang:1.24-alpine AS builder

WORKDIR /src

COPY go.mod ./
COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /app

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder --chown=65534:65534 /app /app

USER 65534:65534
EXPOSE 8080

ENTRYPOINT ["/app"]
