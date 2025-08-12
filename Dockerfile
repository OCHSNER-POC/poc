# Use the official .NET 9.0 runtime image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official .NET 9.0 SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["ConsoleApp.csproj", "./"]
RUN dotnet restore "ConsoleApp.csproj"

# Copy the rest of the source code
COPY . .
WORKDIR "/src"

# Build the application
RUN dotnet build "ConsoleApp.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "ConsoleApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "ConsoleApp.dll"]
