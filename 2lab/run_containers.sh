#!/bin/sh
NUM_CONTAINERS=$1
i=1
while [ $i -le $NUM_CONTAINERS ]; do
	docker stop container_$i 2>/dev/null
	docker rm container_$i 2>/dev/null
	i=$(expr $i + 1)
done
docker volume rm shared_volume 2>/dev/null
docker volume create shared_volume
docker build -t concurrent_container .
i=1
while [ $i -le $NUM_CONTAINERS ]; do
	docker run -d --name container_$i -v shared_volume:/shared concurrent_container
	i=$(expr $i + 1)
done
echo "Started $NUM_CONTAINERS containers"
