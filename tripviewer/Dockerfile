FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet publish "web/TripViewer.csproj" -c Release -o /publish

FROM microsoft/dotnet:2.1-aspnetcore-runtime
ENV TEAM_API_ENDPOINT="http://akstraefikopenhackvld9.westus.cloudapp.azure.com"
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "TripViewer.dll"]