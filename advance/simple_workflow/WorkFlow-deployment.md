# Install docker CE 18.03.1


https://docs.docker.com/install/linux/docker-ce/ubuntu/#supported-storage-drivers

# Install mssql-server-linux docker image

docker pull microsoft/mssql-server-linux
+ Type 'docker image list' to check if it's pulled seccessful
+ Run mssql-server-linux with sample command as below:

docker run --name mydatabase -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Work4fun' -p 1433:1433 -d microsoft/mssql-server-linux:2017-latest

* Note down the password, user id is sa, and port number is 1433. Type 'docker ps' to make sure it's working. The output as below:

b7575d6ac1f1  microsoft/mssql-server-linux:latest "/opt/mssql/bin/sqls…"  33 minutes ago  Up 32 minutes 0.0.0.0:1433->1433/tcp gracious_jennings


# Install mssql tools
https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-linux-2017

+ Modifying DocumentDatabase-Schema+DataScript.sql as below
    + N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\DemoWF_Distribute_Database.mdf'

    to

    + N'/var/DemoWF_Distribute_Database.mdf' 

    + N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\DemoWF_Distribute_Database_log.ldf'

    to

    + N'/var/DemoWF_Distribute_Database_log.ldf'

+ Modifying WorkflowServer-Schema+DataScript.sql as below:

    + N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\WFTemp.mdf'

    to

    + N'/var/WFTemp.mdf'

    + N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\WFTemp_log.ldf'

    to

    + N'/var/WFTemp_log.ldf'

+ Run two commands below:
+ 
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Work4fun -i WorkflowServer-Schema+DataScript.sql 
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Work4fun -i DocumentDatabase-Schema+DataScript.sql

  * Tips: https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-develop-use-vscode?view=sql-server-linux-2017


# build docker image. Register an account on https://hub.docker.com to push your image to docker hub.

+ Take a look some docker file as below:
    ClientUI
    ------- Dockerfile
    DocumentService
    ------- Dockerfile
    WorkflowService
    ------- Dockerfile.api
            Dockerfile.designer

    + Stand in WorkflowService and run two below command:
        docker build -t delgemoon/wf_api:1.0 -f Dockerfile.api .
        docker build -t delgemoon/wf_designer:1.0 Dockerfile.designer .
    + Stand in ClientUI and run this command:
        docker build -t delgemoon/clientui:1.0 .
    + Stand in DocumentService and run this command:
        docker build -t delgemoon/wf_doc:1.0 .
    NOTE: Please change 'degemoon' to you account id in docker hub so that you can push your image to there.
    + docker login --username=delgemoon . Then enter your password. And now you can push your image to docker hub with the command below:
        docker push delgemoon/wf_designer:1.0

# Kubernetes deployments

+ Check in the kubernetes directory.

kubectl create secret generic mssql --from-literal=SQLSERVER_SA_PASSWORD="Work4fun" --from-literal=SQLSERVER_HOST="104.198.205.8,1433"
Server:		10.51.240.10
Address:	10.51.240.10#53

Server:		10.51.240.10
Address:	10.51.240.10#53

Name:	wf-api-service.default.svc.cluster.local
Address: 10.51.241.27


# apt-get update
# apt-get install dnsutils


# Kubernetes deployments:

1. Deploying mssql secret
    1. The secret contains mssql host url and mssql passwork
    2. mssql.yaml
        1. kubectl create -f mssql.yaml
        2. Verify by : kubectl get secret mssql
2. Deploying workflow desginer service
    1. Create a deployment to manage pods creation
        1. kubectl create -f wf-designer.yaml
        2. verify : kubectl get deployment wf-designer
        3. verify pods: kubectl get pods
    2. Create a service to expose the wf-designer to outside or another services
        1. kubectl create -f wf-designer-service.yaml
        2. verify: kubectl get service wf-designer-service
3. Deploying Workflow api service
    1. Create a deployment to manage pods creation
        1. kubectl create -f wf-api.yaml
        2. verify : kubectl get deployment wf-api
    2.  Create a service to expose the wf-api another services
        1. kubectl create -f wf-api-service.yaml
        2. verify: kubectl get service wf-api-service
4. Deploying workflow document service
    1. Create a deployment to manage pods creation
        1. kubectl create -f wf-doc.yaml
        2. verify : kubectl get deployment wf-doc
    2.  Create a service to expose the document service to outside or another services
        1. kubectl create -f wf-doc-service.yaml
        2. verify: kubectl get service wf-doc-service
5. Deploying client UI  
    1. Create a deployment to manage pods creation
        1. kubectl create -f wf-client-ui.yaml
        2. verify : kubectl get deployment wf-client-ui
    2.  Create a service to expose the document service to outside or another services
        1. kubectl create -f wf-client-service.yamll
        2. verify: kubectl get service wf-client-service

6. Checkout all service and pods are created:
    1. kubectl get services
    2. kubectl get pods
    3. kubectl get deployments