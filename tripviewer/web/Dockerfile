FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 58740
EXPOSE 44356

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["TripViewer/TripViewer.csproj", "TripViewer/"]
RUN dotnet restore "TripViewer/TripViewer.csproj"
COPY . .
WORKDIR "/src/TripViewer"
RUN dotnet build "TripViewer.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TripViewer.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TripViewer.dll"]