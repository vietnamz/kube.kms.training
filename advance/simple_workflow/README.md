# simple_workflow

docker run --name mydatabase -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Work4fun' -p 1433:1433 --network=designer -d microsoft/mssql-server-linux:2017-latest
docker network create designer
docker run --name wfdoc -p 62001:62001 --network=designer -d delgemoon/wf_doc:1.0
docker run --name wfapi -p 61511:61511 --network=designer -d delgemoon/wf_api:1.0
docker run --name wfdesigner -p 18098:18098 --network=designer -d delgemoon/wf_designer:1.0