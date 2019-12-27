# requirements:

- minikube
- docker-compose
- Docker
- Python 
- psql
- nodejs
- yarn
# firebase account:

+ mail : kube.kms.traning@gmail.com
+ pass: @123456@

You can access into firebase and verify user authentication.

# Basis minikube command

+ minikube start: start a new kubernetes cluster
+ minikube stop: stop using kubernetes session
+ minikube delete: delete kubernetes cluster
+ minikube ssh: access into kubernetes host
+ minikube service [service_name]: open a service 


# Deploying the simple app

+ Navigating to the simple app
+ take a look frontend and backend app. There is a kubernetes folder there.

+ Run these command below to start deploying the app to kuberntes:
    + minikuber start
    + nagivating to backend dir -> kubernetes dir.
        + Deploy the postgres database first:
            + kubectl create -f postgres-configmap.yaml
            + kubectl create -f postgres-storage.yml
            + kubectl create -f postgres-deploy.yml
            + kubectl create -f postgres-service.yml
            + Verify everything is fine.
                + kubectl get deployment
                + kubectl get pvc
                + kubectl get pc
                + kubectl get pods
                + kubectl get svc
            + Now you can access into postgres via the mapping port, sample as below. The backend inside kubernetes still access into database via port 5432, but outsite the cluster must access via port 31496

(venv) FVFZC1XWL414:kubernetes tammdang$ kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          76s
postgres     NodePort    10.96.115.22   <none>        5432:31496/TCP   3s
(venv) FVFZC1XWL414:kubernetes tammdang$ minikube service postgres
|-----------|----------|-------------|---------------------------|
| NAMESPACE |   NAME   | TARGET PORT |            URL            |
|-----------|----------|-------------|---------------------------|
| default   | postgres |             | http://192.168.64.5:31496 |
|-----------|----------|-------------|---------------------------|


        + Deploy the backend service
            + kubectl create secret generic postgres-secret --from-literal=POSTGRES_HOST="postgresql+psycopg2://postgres:postgres@postgres.default.svc.cluster.local:5432/user_mgr"
            + kubectl create secret generic google-secret --from-file=firebase.json=../service/firebase.json
            + kubectl create -f backend-deploy.yml
            + kubectl create -f backend-svc.yml
            + now, you can access into the backend swagger via http://192.168.64.5:31063/docs

(venv) FVFZC1XWL414:kubernetes tammdang$ kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
backend      NodePort    10.96.7.196    <none>        5000:31063/TCP   5m33s
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          15m
postgres     NodePort    10.96.115.22   <none>        5432:31496/TCP   13m
(venv) FVFZC1XWL414:kubernetes tammdang$ minikube service backend
|-----------|---------|-------------|---------------------------|
| NAMESPACE |  NAME   | TARGET PORT |            URL            |
|-----------|---------|-------------|---------------------------|
| default   | backend |             | http://192.168.64.5:31063 |
|-----------|---------|-------------|---------------------------|


    + nagivating to frontend dir -> kubernetes dir. Since we cannot get the IP and port of backend in advance, so we have to rebuild the docker image as below.
        + Please take note the ip address and port of backend as a example above.
        + modify the file .env in frontend dir as blow, if the .env doesn't exist, pls copy env.example to .env and modify it:
        + modify the axios api host and port to the backend ip and port accordingly.
                AXIOS_API_HOST=192.168.64.5
                AXIOS_API_PORT=32724
                AXIOS_API_PREFIX=/
        + from the top of frontend dir. Run the command below:
            docker build -t delgemoon/backend-sample:1.0
            docker push delgemoon/backend-sample:1.0 # you must login to docker hub before performing this step.
            + note that: you must create a dockerhub account and replace delgemoon to your account. for the rest you can name it as you want. But you have to replace the docker image in  frontend.yml to yours. Since your image already exists in your local, the minikube will get the local instead, but highly recommend you push to the dockerhub, to understand the flow.
        
        + Navigating to kubernetes dir:
            + kubectl create -f frontend.yml
            + kubectl create -f frontend-svc.yml




### In order to run advance sample, you should have an aws account and deploy the app to EKS.

        
