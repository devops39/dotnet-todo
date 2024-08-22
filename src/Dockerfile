# Use the official .NET SDK image as a build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files to the working directory
COPY . ./

# Restore the dependencies
RUN dotnet restore

# Build the application in release mode
RUN dotnet build -c Release --no-restore

# Publish the application to a directory
RUN dotnet publish -c Release --no-restore -o /app/publish

# Use the official ASP.NET Core runtime image as a runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "appimg.dll"]
