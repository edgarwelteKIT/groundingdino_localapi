#!/bin/bash

# Build the Docker image
echo "Building Docker image..."
docker build -t groundingdino_localapi .

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

# check if Docker container is already running
if [ "$(docker ps -q -f name=groundingdino_localapi_container)" ]; then
    echo "Stopping existing Docker container..."
    docker stop groundingdino_localapi_container
fi

# check if Docker container exists
if [ "$(docker ps -aq -f status=exited -f name=groundingdino_localapi_container)" ]; then
    echo "Removing existing Docker container..."
    docker rm groundingdino_localapi_container
fi

# Start the Docker container
echo "Starting Docker container..."
docker run --gpus all -d --name groundingdino_localapi_container -p 8000:8000 groundingdino_localapi

# Check if the container started successfully
if [ $? -eq 0 ]; then
    echo "Docker container started successfully."
    echo "Streaming logs from the container..."
    docker logs -f groundingdino_localapi_container
else
    echo "Failed to start Docker container."
    exit 1
fi
