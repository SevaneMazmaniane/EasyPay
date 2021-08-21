#!/bin/bash

printf '\nInstall Kubernetes dashboard from Github repository. Check at https://github.com/kubernetes/dashboard\n\n'

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

printf '\nCreate a service account in the default namespace.\n\n'

kubectl create serviceaccount dashboard -n default

printf '\nAdd the cluster binding rules to your dashboard account created in the default namespace.\n\n'

kubectl create clusterrolebinding dashboard-admin -n default  --clusterrole=cluster-admin  --serviceaccount=default:dashboard

printf '\nCopy the secret token from the output and enter in the dashboard login page.\n\n'

kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

printf '\n'

printf '\n1. Change the the Kubernetes dashboard service type to LoadBalancer: kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard'
printf '\n2. Make sure the service type changed to LoadBalancer: kubectl -n kubernetes-dashboard get svc'
printf '\n'