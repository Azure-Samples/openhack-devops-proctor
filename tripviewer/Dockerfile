FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet publish "web/TripViewer.csproj" -c Release -o /publish

FROM microsoft/dotnet:2.1-aspnetcore-runtime
ENV USER_ROOT_URL="https://openhack${RGSUFFIX}userprofile.azurewebsites.net"\
POI_ROOT_URL="https://openhack${RGSUFFIX}poi.azurewebsites.net"\
TRIPS_ROOT_URL="https://openhack${RGSUFFIX}trips.azurewebsites.net"\
USER_JAVA_ROOT_URL="https://openhack${RGSUFFIX}userjava.azurewebsites.net"\
BING_MAPS_KEY="changeme"\

WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "TripViewer.dll"]