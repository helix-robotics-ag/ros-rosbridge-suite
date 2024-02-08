#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

docker run -it --rm \
--network=host \
--ipc=host \
--pid=host \
--env UID=${MY_UID} \
--env ROS_DOMAIN_ID \
--privileged \
ghcr.io/helix-robotics-ag/${REPOSITORY_NAME}:iron
