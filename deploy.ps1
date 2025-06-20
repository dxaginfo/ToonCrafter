# ToonCrafter Deployment Script for Windows
param(
    [switch]$SkipChecks
)

Write-Host "🚀 Starting ToonCrafter Deployment..." -ForegroundColor Green

# Check if Docker is installed
if (-not $SkipChecks) {
    try {
        docker --version | Out-Null
        Write-Host "✅ Docker is installed" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker is not installed. Please install Docker Desktop first." -ForegroundColor Red
        exit 1
    }

    # Check if Docker Compose is installed
    try {
        docker-compose --version | Out-Null
        Write-Host "✅ Docker Compose is installed" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker Compose is not installed. Please install Docker Compose first." -ForegroundColor Red
        exit 1
    }
}

# Create necessary directories
Write-Host "📁 Creating directories..." -ForegroundColor Yellow
if (-not (Test-Path "checkpoints")) { New-Item -ItemType Directory -Path "checkpoints" }
if (-not (Test-Path "results")) { New-Item -ItemType Directory -Path "results" }
if (-not (Test-Path "tmp")) { New-Item -ItemType Directory -Path "tmp" }

# Check if models need to be downloaded
if (-not (Test-Path "checkpoints/tooncrafter_512_interp_v1")) {
    Write-Host "📥 Models will be downloaded automatically on first run..." -ForegroundColor Yellow
    Write-Host "   This may take several minutes depending on your internet connection." -ForegroundColor Yellow
}

# Build and start the application
Write-Host "🔨 Building Docker image..." -ForegroundColor Yellow
docker-compose build

Write-Host "🚀 Starting ToonCrafter..." -ForegroundColor Yellow
docker-compose up -d

# Wait for the application to start
Write-Host "⏳ Waiting for application to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check if the application is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7860/" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ ToonCrafter is successfully deployed!" -ForegroundColor Green
        Write-Host "🌐 Access the application at: http://localhost:7860" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📋 Useful commands:" -ForegroundColor Yellow
        Write-Host "   View logs: docker-compose logs -f" -ForegroundColor White
        Write-Host "   Stop: docker-compose down" -ForegroundColor White
        Write-Host "   Restart: docker-compose restart" -ForegroundColor White
        Write-Host "   Update: docker-compose pull && docker-compose up -d" -ForegroundColor White
    }
    else {
        throw "Application not responding"
    }
}
catch {
    Write-Host "❌ Application failed to start. Check logs with: docker-compose logs" -ForegroundColor Red
    exit 1
} 