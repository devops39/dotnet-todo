# Use the official .NET SDK image as a build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy the solution file and project files
COPY *.sln .
COPY src/*.csproj ./src/
RUN dotnet restore ./src/TodoApi.csproj

# Copy all source files and publish the application
COPY */. ./*
WORKDIR /source/src
RUN dotnet publish -c release -o /app

# Use the official ASP.NET Core runtime image as the base image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "TodoApi.dll"]
