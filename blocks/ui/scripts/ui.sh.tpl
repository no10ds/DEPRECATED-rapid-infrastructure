#!/bin/bash -xe

url="${REGISTRY_URL}/${VERSION}.zip"
wget $url

unzip -o "${VERSION}.zip"
cd out/ || { echo "./out folder does not exist"; exit 1; }

echo 'window.__ENV = ${ENVS}' | tee __ENV.js

aws s3 cp . s3://${BUCKET_ID} --recursive
