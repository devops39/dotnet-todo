# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK as a build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TodoApi.csproj", "."]
RUN dotnet restore "./dotnet-todo.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "dotnet-todo.csproj" -c Release -o /app/build

# Publish the build artifacts
FROM build AS publish
RUN dotnet publish "dotnet-todo.csproj" -c Release -o /app/publish

# Use the base image and copy the build artifacts into the final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TodoApi.dll"]
