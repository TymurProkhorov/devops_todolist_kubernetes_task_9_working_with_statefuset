## Validation Instructions

### 1. Verify namespace

    kubectl get ns
Expect myя sql namespace to be present.
### 2. Check StatefulSet and pods

    kubectl get statefulset -n mysql
    kubectl get pods -n mysql -o wide
Expect 3 pods: mysql-0, mysql-1, mysql-2.

### 3. Verify secrets
    kubectl get secret st-secret -n mysql -o yaml
Expect 3 secrets: MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD.

### 4. Check probes
    kubectl describe pod mysql-0 -n mysql | grep Liveness
    kubectl describe pod mysql-0 -n mysql | grep Readiness
Expect both liveness and readiness probes to be defined.

### 5. Check init.sql volume
    kubectl exec -it mysql-0 -n mysql -- ls /docker-entrypoint-initdb.d
Expect file init.sql to be present.

### 6. Validate database
    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p$MYSQL_ROOT_PASSWORD app_db -e "SHOW TABLES;"
    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p$MYSQL_ROOT_PASSWORD app_db -e "INSERT INTO users (username) VALUES ('user1');"
    kubectl exec -it mysql-0 -n mysql -- mysql -u root -p$MYSQL_ROOT_PASSWORD app_db -e "SELECT * FROM users;"
Expect output to include: user1.