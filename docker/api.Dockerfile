# Build the application from source
FROM --platform=$BUILDPLATFORM golang:1.23 AS build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files for the main app
COPY go.mod go.sum ./

# Download Go modules for the main app
RUN go mod download && go mod verify

COPY . .

# Assumes that go generate has already run
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-slotify-api cmd/server/main.go

# Deploy the application binary into a lean image
FROM alpine:latest AS build-release-stage

WORKDIR /

COPY --from=build-stage /docker-slotify-api /docker-slotify-api

RUN chmod a+x /docker-slotify-api

EXPOSE 8080

ENTRYPOINT ["/docker-slotify-api"]
