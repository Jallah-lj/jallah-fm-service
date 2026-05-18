# Build stage
FROM public.ecr.aws/docker/library/golang:1.24.2-alpine AS build

# Set the working directory
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download the dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage
FROM public.ecr.aws/docker/library/alpine:latest

WORKDIR /app

# Install runtime dependencies (like goose and dockerize if needed in image)
RUN apk add --no-cache ca-certificates

# Copy the binary from the build stage
COPY --from=build /app/main ./main
COPY --from=build /app/static ./static
COPY --from=build /app/templates ./templates
COPY --from=build /app/migrations ./migrations

# Expose the port
EXPOSE 8080

# Command to run
CMD ["./main"]
