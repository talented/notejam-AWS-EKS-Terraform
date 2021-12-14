#!/bin/bash

# kubectl apply --validate=false -f k8s/cert-manager/cert-manager.yaml
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml

# Watch for the status of each cert-manager pod via:
watch -d kubectl get pods -n cert-manager