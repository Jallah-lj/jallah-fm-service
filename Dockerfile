# Build stage
FROM public.ecr.aws/docker/library/golang:1.24.2-alpine AS build

WORKDIR /app

RUN apk add --no-cache gcc musl-dev

COPY go.mod go.sum ./
RUN go mod download

# Install goose migration tool
RUN go install github.com/pressly/goose/v3/cmd/goose@latest

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage
FROM public.ecr.aws/docker/library/alpine:latest

WORKDIR /app

RUN apk add --no-cache ca-certificates wget

# Install dockerize for service readiness checks
RUN wget -qO- https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
    | tar xz -C /usr/local/bin

COPY --from=build /app/main ./main
COPY --from=build /app/static ./static
COPY --from=build /app/templates ./templates
COPY --from=build /app/migrations ./migrations
COPY --from=build /go/bin/goose /usr/local/bin/goose

EXPOSE 8080

CMD ["./main"]
