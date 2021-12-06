#!/bin/bash

# First, get a hold of an FQDN that you own and define it in an env var:
route53_zone_fqdn=<TYPE-IN-YOUR-FQDN-HERE>

# Let's also create a unique caller reference:
route53_caller_reference=$(uuidgen | tr -d '-')

# Then, create the zone:
aws_profile=$(grep -E ' *aws_profile *=' terraform/terraform.tfvars | sed -E 's/ *aws_profile *= *"(.*)"/\1/g')
aws_region=$(grep -E ' *aws_region *=' terraform/terraform.tfvars | sed -E 's/ *aws_region *= *"(.*)"/\1/g')

aws route53 create-hosted-zone \
  --profile "$aws_profile" \
  --name "$route53_zone_fqdn" \
  --caller-reference "$route53_caller_reference" > tmp/create-hosted-zone.out

# List the nameservers for your zone:
cat tmp/create-hosted-zone.out | jq -r '.DelegationSet.NameServers[]'

# Now modify your DNS servers to use the hosts listed.
