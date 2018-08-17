#Pull Base Image
FROM microsoft/dotnet:2.0-runtime AS base
WORKDIR /app
#Pull SDK Image to Build Solution
FROM microsoft/dotnet:2.0-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet restore -nowarn:msb3202,nu1503
WORKDIR /src/DeviceSim.EF.SQL
RUN dotnet build -c Release -o /app
#Build .net solution
FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
ENV SQL_USER="devopsohsa00" \
SQL_PASSWORD="devopsohdevpwd-00" \
SQL_SERVER="changeme.database.windows.net" \
SQL_DBNAME="mydrivingDB" \
TRIP_FREQUENCY="180000" \
TEAM_NAME="devopsoh000test" \
SIMULATOR_API_ENDPOINT="http://akstraefikota1961.westus2.cloudapp.azure.com"
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DeviceSim.dll"]
