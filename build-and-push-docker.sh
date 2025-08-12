#!/bin/bash

sh build-docker.sh dwachholderesa ochsner-poc
docker push dwachholderesa/ochsner-poc:latest
