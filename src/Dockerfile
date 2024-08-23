# Use the official .NET SDK image as a build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy the project file and restore dependencies as distinct layers
COPY *.sln .
COPY src/*.csproj ./src/
RUN dotnet restore ./src/TodoApi.csproj

# Copy the rest of the application code and build the app
COPY src/. ./src/
WORKDIR /source/src
RUN dotnet publish -c release -o /app --no-restore

# Use the official ASP.NET Core runtime image as the base image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "TodoApi.dll"]
