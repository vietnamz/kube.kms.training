# requirements:

minikube
docker-compose
Docker
Python 
psql
nodejs
yarn
# firebase account:

mail : kube.kms.traning@gmail.com
pass: @123456@

You can access into firebase and verify user authentication.

# Basis minikube command

minikube start: start a new kubernetes cluster
minikube stop: stop using kubernetes session
minikube delete: delete kubernetes cluster
minikube ssh: access into kubernetes host
minikube service [service_name]: open a service 


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
            + kubectl create secret generic google-creds --from-file=GOOGLE_APPLICATION_CREDENTIALS=../service/firebase.json
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


    + nagivating to frontend dir -> kubernetes dir.



        
