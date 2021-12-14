#!/bin/bash

set -exuo pipefail

# https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

policy_file="./k8s/aws-lb-controller/iam-policy.json"

aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://k8s/aws-lb-controller/iam-policy.json | \
tee tmp/aws-load-balancer-controller-iam-policy.json

aws_account_id=$(terraform -chdir=terraform output -raw aws_account_id)
k8s_cluster_name=$(terraform -chdir=terraform output -raw k8s_cluster_name)
aws_region=$(terraform -chdir=terraform output -raw aws_region)

eksctl create iamserviceaccount \
--cluster="$k8s_cluster_name" \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::${aws_account_id}:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region=aws_region \
--approve

cat k8s/aws-lb-controller/load-balancer.yaml | \
  sed 's@--cluster-name=K8S_CLUSTER_NAME@'"--cluster-name=${k8s_cluster_name}"'@' | \
  kubectl apply -f -
