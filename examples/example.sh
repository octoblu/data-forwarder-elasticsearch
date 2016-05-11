#!/bin/sh

MESHBLU_SERVER="meshblu.octoblu.dev"
MESHBLU_PORT="80"
MESHBLU_URL="$MESHBLU_SERVER:$MESHBLU_PORT"
SERVICE_URL="data-forwarder-elasticsearch.octoblu.dev"
CREATE_DEVICE_URL="$SERVICE_URL/messages"

mkdir ./tmp

echo "creating owner device"
meshblu-util register -s $MESHBLU_URL > ./tmp/owner-meshblu.json
OWNER_DEVICE_UUID=$(cat ./tmp/owner-meshblu.json | jq -r '.uuid')
OWNER_DEVICE_TOKEN=$(cat ./tmp/owner-meshblu.json | jq -r '.token')
echo "owner is: $OWNER_DEVICE_UUID"

echo "creating receiver device"
meshblu-util register -o -s $MESHBLU_URL > ./tmp/receiver-meshblu.json
RECEIVER_DEVICE_UUID=$(cat ./tmp/receiver-meshblu.json | jq -r '.uuid')
echo "receiver is: $RECEIVER_DEVICE_UUID"

echo "creating data-forwarder"
curl \
--silent \
--user $OWNER_DEVICE_UUID:$OWNER_DEVICE_TOKEN \
-H 'content-type: application/json' \
-d '{"options": "hi"}' \
-X POST "$SERVICE_URL/devices" | jq '.' > ./tmp/data-forwarder-config.json

FORWARDER_DEVICE_UUID=$(cat ./tmp/data-forwarder-config.json | jq -r '.uuid')
FORWARDER_DEVICE_TOKEN=$(cat ./tmp/data-forwarder-config.json | jq -r '.token')

echo "data-forwarder device is: $FORWARDER_DEVICE_UUID"
#Hey, you think meshblu-util register should return a meshblu.json?
echo "{ \
\"server\": \"$MESHBLU_SERVER\", \
\"port\": \"$MESHBLU_PORT\", \
\"uuid\": \"$FORWARDER_DEVICE_UUID\", \
\"token\": \"$FORWARDER_DEVICE_TOKEN\" \
}" | jq '.' > ./tmp/data-forwarder-meshblu.json

echo "subscribing data-forwarder to receiver-device's received messages"
meshblu-util subscription-create -e $RECEIVER_DEVICE_UUID -t message.received ./tmp/data-forwarder-meshblu.json

echo "messaging receiver-device as the owner"
meshblu-util message \
-d "{\"devices\": [\"$RECEIVER_DEVICE_UUID\"], \"data-forwarders\": \"are-awesome\"}" \
./tmp/owner-meshblu.json
