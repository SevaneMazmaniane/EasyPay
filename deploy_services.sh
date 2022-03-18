#!/bin/bash

# Cyan color code for info text
INFO='\033[0;36m'
# No color
NC='\033[0m'

echo ${INFO}"Creating the volume..."${NC}

kubectl apply -f ./kubernetes/mongo-pv.yml
kubectl apply -f ./kubernetes/mongo-pvc.yml

echo ${INFO}"Creating the MongoDB deployment and service..."${NC}

kubectl apply -f ./kubernetes/mongo-deployment.yml
kubectl apply -f ./kubernetes/mongo-svc.yml

echo ${INFO}"Creating the flask Payment API deployment and service..."${NC}

kubectl apply -f ./kubernetes/payment-app-deployment.yml
kubectl apply -f ./kubernetes/payment-app-svc.yml

echo ${INFO}"Adding the ingress..."${NC}

kubectl apply -f ./kubernetes/payment-app-ingress.yml

echo ${INFO}"Creating an HPA to automatically scale the application ..."${NC}

kubectl apply -f ./kubernetes/payment-app-hpa.yml