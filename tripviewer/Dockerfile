FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet restore "web/TripViewer.csproj"
RUN dotnet build "web/TripViewer.csproj" -c Release -o /app
RUN dotnet publish "web/TripViewer.csproj" -c Release -o /publish

FROM microsoft/dotnet:2.1-aspnetcore-runtime
ENV TEAM_API_ENDPOINT="http://akstraefikopenhackut20.eastus.cloudapp.azure.com"
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "TripViewer.dll"]