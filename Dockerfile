FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["aks-ga-demo.csproj", "./"]
RUN dotnet restore "./aks-ga-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aks-ga-demo.csproj" -c Release -o /app/build

FROM --platform=linux/amd64 build AS publish
RUN dotnet publish "aks-ga-demo.csproj" -c Release -o /app/publish

FROM --platform=linux/amd64 base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aks-ga-demo.dll"]