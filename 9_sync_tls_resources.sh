#!/bin/bash

set -euxo pipefail

namespace=staging
app=notejam

route53_zone_fqdn=$(cat tmp/create-hosted-zone.out | jq -r '.HostedZone.Name' | rev | cut -c2- | rev)
route53_zone_id=$(cat tmp/create-hosted-zone.out | jq -r '.HostedZone.Id')
cluster_name=$(terraform -chdir=terraform output -raw cluster_name)
tls_secret_name=${app}-tls
profile=$(terraform -chdir=terraform output -raw aws_profile)

kubectl get secret $tls_secret_name -o json -n $namespace | \
   jq -r '.data."tls.crt"' | \
   base64 -d | \
   sed -e '/-----END CERTIFICATE-----/q' > tmp/certificate-${app}.pem

kubectl get secret $tls_secret_name -o json -n $namespace | \
   jq -r '.data."tls.crt"' | \
   base64 -d > tmp/certificate-chain-${app}.pem

kubectl get secret $tls_secret_name -o json -n $namespace | \
   jq -r '.data."tls.key"' | \
   base64 -d > tmp/private-key-${app}.pem

aws acm import-certificate \
  --profile "$profile" \
  --certificate fileb://$(pwd)/tmp/certificate-${app}.pem \
  --certificate-chain fileb://$(pwd)/tmp/certificate-chain-${app}.pem \
  --private-key fileb://$(pwd)/tmp/private-key-${app}.pem

CERTIFICATE_ARN=$(aws acm list-certificates \
    --profile "$profile" \
    --query CertificateSummaryList[].[CertificateArn,DomainName] \
    --output text | grep "${route53_zone_fqdn}" | cut -f1 | head -n 1)

kubectl annotate --overwrite ingress notejam-ingress-alb \
    -n $namespace \
    alb.ingress.kubernetes.io/certificate-arn=$CERTIFICATE_ARN