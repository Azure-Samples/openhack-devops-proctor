FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet publish "web/TripViewer.csproj" -c Release -o /publish

FROM microsoft/dotnet:2.1-aspnetcore-runtime
ENV TEAM_API_ENDPOINT="http://akstraefikchangeme.westus.cloudapp.azure.com",BING_MAPS_KEY="changeme"
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "TripViewer.dll"]