#!/bin/bash

set -euo pipefail

docker build -t ikulyk404/todoapp:3.0.0 .
docker push ikulyk404/todoapp:3.0.0

kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f st-secret.yml -n mysql
kubectl apply -f st-configmap.yml -n mysql
kubectl apply -f st-service.yml -n mysql
kubectl apply -f statefulset.yml -n mysql

kubectl rollout status statefulset/mysql -n mysql

kubectl apply -f .infrastructure/secret.yml -n todoapp
kubectl apply -f .infrastructure/deployment.yml -n todoapp
