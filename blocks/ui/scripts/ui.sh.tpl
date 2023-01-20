#!/bin/bash -xe

url="${REGISTRY_URL}/${VERSION}.zip"
curl -LO $url

unzip -o "ui-f1-registry-${VERSION}.zip"
cd out/

echo 'window.__ENV = ${ENVS}' | tee __ENV.js

aws s3 cp . s3://$${BUCKET_ID} --recursive