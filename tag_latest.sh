#! /usr/bin/env bash

echo "Building and tagging latest..."

set -e

TARGET_HOST=$1
if [ -z $TARGET_HOST ]; then echo "TARGET_HOST not set" && exit 1; fi

USER="klotzandrew"
APP_NAME="rorschach"

echo "frontend needs build container"
cd web_client
bash ./full_build.sh $TARGET_HOST
cd ..

echo "Building images..."
docker-compose build --no-cache

for NAME in web_server web_client
do
  docker tag "${APP_NAME}_${NAME}" "${USER}/${APP_NAME}_${NAME}"
  docker push "${USER}/${APP_NAME}_${NAME}"
done
