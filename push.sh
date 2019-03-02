#!/bin/bash

JSON_PATH=$(cd $(dirname $0); pwd)"/push.json"

curl -v -X POST https://api.line.me/v2/bot/message/multicast \
-H 'Content-Type:application/json' \
-H 'Authorization: Bearer {zBvfOkGCChWT6m62icyXfQ6/u+n6fCVVEIVBngMskBhFBb811Zdh5EMr/LEw94329ImUHPABcaovmAZIAQDXLo0B7E2ic5jU8LklpHB3DcLZItQqGt5cnQVCRtcRuSKStVu+bJDhTiowgH5nZNmzcQdB04t89/1O/w1cDnyilFU=}' \
-d @$JSON_PATH