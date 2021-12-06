#!/bin/bash

kubectl apply --validate=false -f k8s/cert-manager/cert-manager.yaml

# Watch for the status of each cert-manager pod via:
watch -d kubectl get pods -n cert-manager