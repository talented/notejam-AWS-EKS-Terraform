#!/bin/bash

docker run -d -p 80:5000 --name notejam \
-v notejam-flask:/app notejam:v1 \
python runserver.py