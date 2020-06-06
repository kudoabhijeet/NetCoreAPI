FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /webapi

# Copy csproj and restore as distinct layers
COPY NetCoreAPI/*.csproj ./
RUN ["dotnet", "restore"]

# Copy everything else and build
COPY NetCoreAPI/. ./
RUN ["dotnet", "publish", "-c", "Release", "-o", "out"]

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /webapi
COPY --from=build-env /webapi/out .
ENTRYPOINT ["dotnet", "NetCoreAPI.dll"] 
