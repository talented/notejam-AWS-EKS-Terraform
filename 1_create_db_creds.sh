#!/bin/bash

secrets_dir="./secrets"

if [ ! -d "$secrets_dir" ]; then
    mkdir -p $secrets_dir
    chmod 0700 $secrets_dir
fi

aws_profile=$(grep -E ' *aws_profile *=' terraform/terraform.tfvars | sed -E 's/ *aws_profile *= *"(.*)"/\1/g')
# terraform -chdir=terraform output aws_profile | cut -d\" -f2
aws_region=$(grep -E ' *aws_region *=' terraform/terraform.tfvars | sed -E 's/ *aws_region *= *"(.*)"/\1/g')
cluster_name=$(grep -E ' *cluster_name *=' terraform/terraform.tfvars | sed -E 's/ *cluster_name *= *"(.*)"/\1/g')
db_credentials_secret_name=${cluster_name}-db-credentials
db_credentials_secret_file=${secrets_dir}/${cluster_name}-db-credentials.json

cat > $db_credentials_secret_file <<EOF
{
    "db_user": "SU_$(uuidgen | tr -d '-')",
    "db_pass": "$(uuidgen)"
}
EOF
chmod 0600 $db_credentials_secret_file

aws secretsmanager create-secret \
  --profile "$aws_profile" \
  --name "$db_credentials_secret_name" \
  --description "DB credentials for ${cluster_name}" \
  --secret-string file://$db_credentials_secret_file