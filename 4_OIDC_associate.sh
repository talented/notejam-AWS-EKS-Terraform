#!/bin/bash

# First check if the cluster already has an OIDC provider:
OIDC=$(aws eks describe-cluster --region $(terraform -chdir=terraform output -raw aws_region) \
    --name $(terraform -chdir=terraform output -raw k8s_cluster_name) \
    --query "cluster.identity.oidc.issuer"  \
    --output text | awk -F/ '{print $NF}')

output=$(aws iam list-open-id-connect-providers | grep $OIDC)

if [[ ! -n $output ]]; then
    echo "Associating OpenID Connect Provider with k8s cluster.."
    eksctl utils associate-iam-oidc-provider \
    --region $(terraform -chdir=terraform output -raw aws_region) \
    --cluster $(terraform -chdir=terraform output -raw k8s_cluster_name) \
    --approve
    echo "Successfuly associated."
else
    echo "OpenID Connect Provider is already associated with k8s cluster!"
    echo $output
fi


