## Validation Instructions

### 1. ## Cluster setup

1.1 Create kind cluster

    kind create cluster --config cluster.yml --name dev-cluster
Expect the cluster to be ready:

    kubectl cluster-info

1.2 Deploy all resources

    chmod +x bootstrap.sh
    ./bootstrap.sh
Expect all required namespaces, StatefulSet, and Deployments to be created.

### 1. Verify namespace

    kubectl get ns
Expect mysql namespace to be present.
### 2. Check StatefulSet and pods

    kubectl get statefulset -n mysql
    kubectl get pods -n mysql -o wide
Expect 3 pods: mysql-0, mysql-1, mysql-2.

### 3. Verify secrets
    kubectl get secret mysql-secrets -n mysql -o yaml
Expect 3 keys: MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD.

### 4. Check probes
    kubectl describe pod mysql-0 -n mysql | grep Liveness
    kubectl describe pod mysql-0 -n mysql | grep Readiness
Expect both liveness and readiness probes to be defined.

### 5. Verify resource requests and limits

    kubectl describe pod mysql-0 -n mysql | grep -A3 "Limits"
    kubectl describe pod mysql-0 -n mysql | grep -A3 "Requests"

### 6. Check init.sql volume
    kubectl exec -it mysql-0 -n mysql -- ls /docker-entrypoint-initdb.d
Expect file init.sql to be present.

### 6. Validate database
6.1 Validate database

    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p<MYSQL_ROOT_PASSWORD> app_db -e "SHOW TABLES;"
    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p<MYSQL_ROOT_PASSWORD> app_db -e "INSERT INTO users (username) VALUES ('user1');"
    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p<MYSQL_ROOT_PASSWORD> app_db -e "SELECT * FROM users;"
Expect output to include: user1.

6.2 Decode MySQL Secret

    kubectl get secret mysql-secrets -n mysql -o jsonpath="{.data.MYSQL_ROOT_PASSWORD}" | base64 --decode

### 7. Validate headless-service and PVC
    kubectl get pvc -n mysql
    kubectl get svc -n mysql