# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj and restore as distinct layers
COPY *.sln .
COPY dotnet-todo/*.csproj ./dotnet-todo/
RUN dotnet restore

# copy everything else and build app
COPY dotnet-todo/. ./dotnet-todo/
WORKDIR /src/dotnet-todo
RUN dotnet publish -c release -o /dotnet-todo --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /dotnet-todo
COPY --from=build /dotnet-todo ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]