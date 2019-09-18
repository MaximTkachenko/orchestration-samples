FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["K8sSample.App/K8sSample.App.csproj", "K8sSample.App/"]
RUN dotnet restore "K8sSample.App/K8sSample.App.csproj"
COPY . .
WORKDIR "/src/K8sSample.App"
RUN dotnet build "K8sSample.App.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "K8sSample.App.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "K8sSample.App.dll"]