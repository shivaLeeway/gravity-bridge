#!/bin/bash
set -eu

docker-compose down
docker-compose up -d
# await gravity bootstrapping
echo "sleeping 5 sec"
sleep 5
docker-compose exec gravity /bin/sh test_gravity.sh