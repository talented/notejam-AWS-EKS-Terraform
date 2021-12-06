#!/bin/bash

set -exuo pipefail

component=$1

cd apps/${component}

registry=$(terraform -chdir=../../terraform output -raw registry_${component})
db_endpoint=$(terraform -chdir=../../terraform output -raw db_endpoint)
image_version="$(date +%s)"

docker build -t ${component} .

docker tag ${component} $registry:$image_version

cd -
echo $image_version > tmp/latest-image-version-${component}

# docker push $registry:$image_version