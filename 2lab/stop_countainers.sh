#!/bin/sh
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
