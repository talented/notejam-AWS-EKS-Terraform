#!/bin/bash

set -exuo pipefail

aws eks --region=$(terraform -chdir=terraform output -raw aws_region) \
  update-kubeconfig \
  --dry-run \
  --name $(terraform -chdir=terraform output -raw k8s_cluster_name) \
  --profile $(terraform -chdir=terraform output -raw aws_profile) \
  --alias $(terraform -chdir=terraform output -raw cluster_name) | \
  sed -E "s/^( *(cluster|name)): *arn:.*$/\1: $(terraform -chdir=terraform output -raw cluster_name)/g" \
  > ~/.kube/config

kubectl config use-context $(terraform -chdir=terraform output -raw cluster_name)

chmod 0600 ~/.kube/config