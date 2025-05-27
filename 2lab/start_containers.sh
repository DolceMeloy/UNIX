#!/bin/bash
COUNT=1
docker volume create common_data >/dev/null 2>&1
for ((i=1; i<=COUNT; i++)); do
    docker run -d --mount type=volume,source=common_data,target=/common_data app_image
done