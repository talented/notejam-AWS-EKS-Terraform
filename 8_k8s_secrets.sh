#!/bin/bash

cluster_name=$(terraform -chdir=terraform output -raw cluster_name)

kubectl create secret generic postgres-credentials -n staging \
--from-env-file <(jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ./secrets/${cluster_name}-db-creds.json) # --dry-run=client -o yaml > k8s/db-secrets.yaml