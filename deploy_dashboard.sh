#!/bin/bash

# Cyan color code for info text
INFO='\033[0;36m'
# Yellow color code for commands
CMD='\033[1;33m'
# No color
NC='\033[0m'

echo ${INFO}"Install Kubernetes dashboard from Github repository. Check at https://github.com/kubernetes/dashboard"${NC}

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml

echo ${INFO} "Create a service account in the default namespace."${NC}

kubectl create serviceaccount dashboard -n default

echo ${INFO} "Add the cluster binding rules to your dashboard account created in the default namespace."${NC}

kubectl create clusterrolebinding dashboard-admin -n default  --clusterrole=cluster-admin  --serviceaccount=default:dashboard

echo ${INFO} "Copy the secret token from the output and enter in the dashboard login page."${NC}

kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

echo ${INFO}"\n1. Change the the Kubernetes dashboard service type to LoadBalancer:${CMD}\n kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard"${NC}
echo ${INFO}"\n2. Make sure the service type changed to LoadBalancer:${CMD}\n kubectl -n kubernetes-dashboard get svc"${NC}