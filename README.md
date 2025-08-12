# .NET Core Web API with Docker Support

A simple .NET Core 9.0 web application with sample HTTP endpoints and Docker containerization.

## Features

- **.NET Core 9.0** - Latest stable version
- **Minimal API** - Clean, concise endpoint definitions
- **Swagger UI** - Interactive API documentation
- **Docker Support** - Multi-stage Dockerfile for production-ready images
- **Sample Endpoints** - GET and POST examples

## API Endpoints

- `GET /` - Welcome message
- `GET /api/hello` - Hello world with timestamp
- `POST /api/echo` - Echo received data with timestamp
- `GET /swagger` - API documentation (development mode)

## Local Development

### Prerequisites
- .NET 9.0 SDK
- Docker Desktop (for containerized development)

### Run Locally
```bash
# Restore dependencies
dotnet restore

# Build the application
dotnet build

# Run the application
dotnet run
```

The application will be available at `http://localhost:5000`

## Docker Development

### Build and Run with Docker Compose
```bash
# Build and start the application
docker-compose up --build

# Run in background
docker-compose up -d --build

# Stop the application
docker-compose down
```

The application will be available at `http://localhost:8080`

### Manual Docker Commands
```bash
# Build the image
docker build -t myapp:latest .

# Run the container
docker run -p 8080:80 myapp:latest

# Run in background
docker run -d -p 8080:80 --name myapp-container myapp:latest
```

## Docker Hub Deployment

### 1. Login to Docker Hub
```bash
docker login
```

### 2. Tag Your Image
Replace `your-dockerhub-username` with your actual Docker Hub username:
```bash
docker tag myapp:latest your-dockerhub-username/myapp:latest
docker tag myapp:latest your-dockerhub-username/myapp:v1.0.0
```

### 3. Push to Docker Hub
```bash
docker push your-dockerhub-username/myapp:latest
docker push your-dockerhub-username/myapp:v1.0.0
```

### 4. Pull and Run from Docker Hub
```bash
# Pull the image
docker pull your-dockerhub-username/myapp:latest

# Run the container
docker run -p 8080:80 your-dockerhub-username/myapp:latest
```

## Production Deployment

### Environment Variables
- `ASPNETCORE_ENVIRONMENT` - Set to `Production` for production
- `ASPNETCORE_URLS` - Configure listening URLs (default: `http://+:80`)

### Health Check
The application includes basic health monitoring through the API endpoints.

### Security Considerations
- Swagger UI is only enabled in development mode
- Production deployments should use HTTPS
- Consider adding authentication and authorization

## Project Structure

```
.
├── Program.cs              # Main application entry point
├── ConsoleApp.csproj       # Project file with dependencies
├── Dockerfile              # Multi-stage Docker build
├── .dockerignore           # Docker build context exclusions
├── docker-compose.yml      # Local development setup
└── README.md               # This file
```

## Building for Different Platforms

### Multi-platform Build
```bash
# Build for multiple platforms
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t your-dockerhub-username/myapp:latest --push .
```

### Platform-specific Builds
```bash
# Build for Windows
docker build --platform windows/amd64 -t myapp:windows .

# Build for Linux ARM64
docker build --platform linux/arm64 -t myapp:arm64 .
```

## Troubleshooting

### Common Issues

1. **Port already in use**: Change the port mapping in docker-compose.yml
2. **Build failures**: Ensure Docker Desktop is running and has sufficient resources
3. **Permission issues**: Run Docker commands with appropriate privileges

### Logs
```bash
# View application logs
docker-compose logs webapp

# Follow logs in real-time
docker-compose logs -f webapp
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).
