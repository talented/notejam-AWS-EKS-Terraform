#!/bin/bash

set -a
source .env
set +a

docker run -d -p 80:5000 --name notejam \
-v notejam-flask:/app notejam/v2 \
python runserver.py