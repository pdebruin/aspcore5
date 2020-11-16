# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY web/*.csproj ./web/
RUN dotnet restore -r linux-musl-x64

# copy everything else and build app
COPY web/. ./web/
WORKDIR /app/web
RUN dotnet publish -c Release -o out -r linux-musl-x64 --self-contained false --no-restore
#RUN dotnet publish -c release -o /app -r linux-musl-x64 --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine-amd64
WORKDIR /app
COPY --from=build /app/web/out ./

ENTRYPOINT ["dotnet", "web.dll"]