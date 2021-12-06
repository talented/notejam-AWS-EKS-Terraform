#!/bin/bash

While AWS has its own certificate management service, we will work with cert-manager for this exercise just so that we'll also learn how to use it. I mean, we're already learning stuff, so we might as well!

kubectl apply --validate=false -f apps/cert-manager/cert-manager.yaml
Watch for the status of each cert-manager pod via:

watch -d kubectl get pods -n cert-manager