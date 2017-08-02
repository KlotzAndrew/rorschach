#! /usr/bin/env bash

set -ex

API_URL=$1
WEBSOCKET_SERVER=$1

if [ "$(docker ps -a | grep builder_cont)" ]; then docker rm builder_cont; fi
if [ "$(docker images | grep builder_img)" ]; then docker rmi builder_img; fi

docker build -t builder_img -f Dockerfile.build .

docker run \
  -e NODE_ENV="production" \
  -e REACT_APP_API_URL=$API_URL \
  -e REACT_APP_WEBSOCKET_SERVER=$WEBSOCKET_SERVER \
  --name builder_cont builder_img

rm -r ./build
docker cp builder_cont:/code/build ./build

docker rm builder_cont
docker rmi builder_img
