#!/bin/bash

# Check if required parameters are provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <dockerhub-username> [tag] [--push]"
    echo "  dockerhub-username: Your Docker Hub username"
    echo "  tag: Image tag (default: latest)"
    echo "  --push: Push image to Docker Hub after building"
    exit 1
fi

DOCKERHUB_USERNAME=$1
TAG=${2:-"latest"}
PUSH=false

# Check if --push flag is provided
if [[ "$*" == *"--push"* ]]; then
    PUSH=true
fi

echo "Building Docker image..."

# Build the image
IMAGE_NAME="$DOCKERHUB_USERNAME/myapp"
FULL_TAG="$IMAGE_NAME:$TAG"

echo "Building $FULL_TAG..."
docker build -t "$FULL_TAG" .

if [ $? -ne 0 ]; then
    echo "Docker build failed!"
    exit 1
fi

echo "Docker build completed successfully!"

if [ "$PUSH" = true ]; then
    echo "Pushing image to Docker Hub..."
    
    # Check if user is logged in to Docker Hub
    if ! docker info | grep -q "Username"; then
        echo "Please login to Docker Hub first: docker login"
        exit 1
    fi
    
    docker push "$FULL_TAG"
    
    if [ $? -ne 0 ]; then
        echo "Docker push failed!"
        exit 1
    fi
    
    echo "Image pushed to Docker Hub successfully!"
    echo "Image: $FULL_TAG"
else
    echo "Image built successfully: $FULL_TAG"
    echo "To push to Docker Hub, run: docker push $FULL_TAG"
fi

echo ""
echo "To run the container:"
echo "docker run -p 8080:80 $FULL_TAG"
