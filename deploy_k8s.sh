#!/bin/bash

set -exuo pipefail

registry=$(terraform -chdir=terraform output -raw registry_backend)

repository="notejam-deployment-backend"
route53_zone_fqdn=$(cat ./tmp/create-hosted-zone.out | jq -r '.HostedZone.Name' | rev | cut -c2- | rev)
cluster_name=$(terraform -chdir=terraform output -raw cluster_name)

image_version=$(aws ecr describe-images --repository-name $repository \
--query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' | xargs -n 1 printf "%s\n")

db_endpoint=$(terraform -chdir=terraform output -raw db_endpoint)

db_name=$(terraform -chdir=terraform output -raw db_name)

# deploy pods
cat k8s/notejam-deployment.yaml | \
  sed 's@REGISTRY_URL@'"${registry}"'@' | \
  sed 's@IMAGE_VERSION@'"${image_version}"'@' | \
  sed 's@DB_ENDPOINT@'"${db_endpoint}"'@' | \
  sed 's@DB_NAME@'"${db_name}"'@' | \
  kubectl apply -n staging -f -

# expose pods
kubectl apply -f k8s/notejam-service.yaml -n staging

# apply ingress with application load balancer
cat k8s/ingress-alb.yaml | \
  sed 's@ROUTE53_ZONE_FQDN@'"${route53_zone_fqdn}"'@' | \
  sed 's@CLUSTER_NAME@'"${cluster_name}"'@' | \
  kubectl apply -n staging -f -