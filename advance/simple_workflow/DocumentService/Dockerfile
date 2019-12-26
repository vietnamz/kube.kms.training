FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /app

COPY . ./

WORKDIR /app/WF.Document.Api

RUN dotnet restore

RUN dotnet build 

ENTRYPOINT ["dotnet","run"]