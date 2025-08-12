#!/usr/bin/env pwsh

param(
    [Parameter(Mandatory=$true)]
    [string]$DockerHubUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$ImageName,
    
    [Parameter(Mandatory=$false)]
    [string]$Tag = "latest",
    
    [Parameter(Mandatory=$false)]
    [switch]$Push
)

Write-Host "Building Docker image..." -ForegroundColor Green

# Build the image
$fullImageName = "$DockerHubUsername/$ImageName"
$fullTag = "$fullImageName`:$Tag"

Write-Host "Building $fullTag..." -ForegroundColor Yellow
docker build -t $fullTag .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Docker build completed successfully!" -ForegroundColor Green

if ($Push) {
    Write-Host "Pushing image to Docker Hub..." -ForegroundColor Yellow
    
    # Check if user is logged in to Docker Hub
    docker info | Select-String "Username" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Please login to Docker Hub first: docker login" -ForegroundColor Red
        exit 1
    }
    
    docker push $fullTag
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker push failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Image pushed to Docker Hub successfully!" -ForegroundColor Green
    Write-Host "Image: $fullTag" -ForegroundColor Cyan
} else {
    Write-Host "Image built successfully: $fullTag" -ForegroundColor Cyan
    Write-Host "To push to Docker Hub, run: docker push $fullTag" -ForegroundColor Yellow
}

Write-Host "`nTo run the container:" -ForegroundColor Green
Write-Host "docker run -p 8080:80 $fullTag" -ForegroundColor White
