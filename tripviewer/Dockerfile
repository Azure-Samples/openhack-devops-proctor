FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY . .
RUN dotnet publish "web/TripViewer.csproj" -c Release -o /publish

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
ENV TEAM_API_ENDPOINT="http://akstraefikchangeme.westus.cloudapp.azure.com",BING_MAPS_KEY="changeme"
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "TripViewer.dll"]
