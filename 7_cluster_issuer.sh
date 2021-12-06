#!/bin/bash

The following steps are based off of this guide, and this bit of a (working) hack:

Next, let's deploy the cluster issuer in another terminal:

route53_zone_fqdn=$(cat tmp/create-hosted-zone.out | jq -r '.HostedZone.Name' | rev | cut -c2- | rev)
route53_zone_id=$(cat tmp/create-hosted-zone.out | jq -r '.HostedZone.Id')
cluster_name=$(terraform -chdir=terraform output -raw cluster_name)
aws_region=$(terraform -chdir=terraform output -raw aws_region)
cert_manager_role_arn=$(terraform -chdir=terraform output -raw cert_manager_role_arn)

cat apps/cert-manager/cluster-issuer.yaml | \
  sed 's@ROUTE53_ZONE_FQDN@'"${route53_zone_fqdn}"'@' | \
  sed 's@ROUTE53_ZONE_ID@'"${route53_zone_id}"'@' | \
  sed 's@CLUSTER_NAME@'"${cluster_name}"'@' | \
  sed 's@AWS_REGION@'"${aws_region}"'@' | \
  sed 's@CERT_MANAGER_ROLE_ARN@'"${cert_manager_role_arn}"'@' | \
  kubectl apply -f -
Check that it created the secret for our app:

kubectl get secret ${cluster_name}-issuer-pkey -n cert-manager