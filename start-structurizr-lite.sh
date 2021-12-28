#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

docker pull structurizr/lite:latest
docker run -it -d --name structurizr-lite --rm -p 8080:8080 -v "${DIR}":/usr/local/structurizr structurizr/lite

open http://localhost:8080
