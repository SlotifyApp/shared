# Build the application from source
FROM --platform=$BUILDPLATFORM golang:1.23 AS build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files for the main app
COPY go.mod go.sum ./

# Download Go modules for the main app
RUN go mod download && go mod verify

COPY . .

# Run the tests
CMD ["go", "test", "./...", "-v"]
