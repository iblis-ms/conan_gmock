#!/bin/bash

docker rm $(docker ps -a -q)
docker rmi conan_gmock 
