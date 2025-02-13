# Build the application from source
FROM --platform=$BUILDPLATFORM golang:1.24 AS build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files for the main app
COPY go.mod go.sum ./

# Download Go modules for the main app
RUN go mod download && go mod verify

COPY . .

CMD ["go", "test","-shuffle=on","-v","-cover", "./..."]
