FROM microsoft/aspnetcore:2.0-nanoserver-1709 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0-nanoserver-1709 AS build
WORKDIR /src
COPY WorkflowDemo.sln ./
COPY DocumentService/WF.Document.Application/WF.Document.Api.csproj DocumentService/WF.Document.Application/
COPY DocumentService/WF.Document.Data/WF.Document.Data.csproj DocumentService/WF.Document.Data/
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
WORKDIR /src/DocumentService/WF.Document.Application
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WF.Document.Api.dll"]
