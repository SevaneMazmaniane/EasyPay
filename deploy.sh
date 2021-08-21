#!/bin/bash

echo "Creating the volume..."

kubectl apply -f ./kubernetes/mongo-pv.yml
kubectl apply -f ./kubernetes/mongo-pvc.yml

echo "Creating the MongoDB deployment and service..."

kubectl apply -f ./kubernetes/mongo-deployment.yml
kubectl apply -f ./kubernetes/mongo-svc.yml

echo "Creating the flask Payment API deployment and service..."

kubectl apply -f ./kubernetes/payment-app-deployment.yml
kubectl apply -f ./kubernetes/payment-app-svc.yml

echo "Adding the ingress..."

kubectl apply -f ./kubernetes/payment-app-ingress.yml

echo "Creating an HPA to automatically scale the application ..."

kubectl apply -f ./kubernetes/payment-app-hpa.yml