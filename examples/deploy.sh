#!/bin/bash
set -ex

docker build . -t gcr.io/my-app/myimage
docker push gcr.io/my-app/myimage

terraform apply

gcloud run services update myapp-cloudrun \
  --platform managed \
  --region eu-west2 \
  --image gcr.io/my-app/myimage
