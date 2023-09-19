# Use an official Golang runtime as a parent image
FROM golang:1.21 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp .

# Create a minimal image to run the application
FROM alpine:latest
WORKDIR /app

# Copy the built binary from the builder image
COPY --from=builder /app/myapp .

# Expose the port the application will listen on
EXPOSE 8080

# Run the application
CMD ["./myapp"]
