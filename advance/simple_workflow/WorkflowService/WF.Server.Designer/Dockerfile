FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /app

COPY ../WF.Server.Business/ ./
COPY ../WF.Server.Designer/ ./
WORKDIR /app/WF.Server.Designer/

RUN dotnet restore

RUN dotnet build 

ENTRYPOINT ["dotnet","run"]