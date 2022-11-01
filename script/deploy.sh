#! /bin/bash

az group create --name dohoney-agw-aks --location eastus
az aks create -n hubCluster -g dohoney-agw-aks --network-plugin azure --enable-managed-identity -a ingress-appgw --appgw-name jupyerHubIngress --appgw-subnet-cidr "10.225.0.0/16" --generate-ssh-keys

az aks get-credentials -n aksdeb0 -g AGW-K8-Group

kubectl apply -f https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/docs/examples/aspnetapp.yaml

kubectl get ingress

kubectl create ns agwtest

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --cleanup-on-fail  \
--install agwtest-release jupyterhub/jupyterhub  \
--namespace agwtest  \
--values cmd.yaml           
