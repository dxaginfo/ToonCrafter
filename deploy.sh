#!/bin/bash

# ToonCrafter Deployment Script
set -e

echo "🚀 Starting ToonCrafter Deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if NVIDIA Docker runtime is available (for GPU support)
if ! docker info | grep -q "nvidia"; then
    echo "⚠️  NVIDIA Docker runtime not detected. GPU acceleration may not be available."
    echo "   For GPU support, install nvidia-docker2: https://github.com/NVIDIA/nvidia-docker"
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p checkpoints results tmp

# Check if models need to be downloaded
if [ ! -d "checkpoints/tooncrafter_512_interp_v1" ]; then
    echo "📥 Models will be downloaded automatically on first run..."
    echo "   This may take several minutes depending on your internet connection."
fi

# Build and start the application
echo "🔨 Building Docker image..."
docker-compose build

echo "🚀 Starting ToonCrafter..."
docker-compose up -d

# Wait for the application to start
echo "⏳ Waiting for application to start..."
sleep 10

# Check if the application is running
if curl -f http://localhost:7860/ > /dev/null 2>&1; then
    echo "✅ ToonCrafter is successfully deployed!"
    echo "🌐 Access the application at: http://localhost:7860"
    echo ""
    echo "📋 Useful commands:"
    echo "   View logs: docker-compose logs -f"
    echo "   Stop: docker-compose down"
    echo "   Restart: docker-compose restart"
    echo "   Update: docker-compose pull && docker-compose up -d"
else
    echo "❌ Application failed to start. Check logs with: docker-compose logs"
    exit 1
fi 