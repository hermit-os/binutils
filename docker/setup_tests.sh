#!/bin/sh -xe

# This script starts docker and systemd (if el7)

OS_NAME=$1
OS_VERSION=$2

# do we run on CentOS?
if [ "$OS_NAME" = "centos" ]; then

# Run tests in Container
if [ "$OS_VERSION" = "6" ]; then

sudo docker run --rm=true -v `pwd`:/HermitCore:rw ${OS_TYPE}:${OS_VERSION} /bin/bash -c "bash -xe /HermitCore/docker/tests_inside_docker.sh ${OS_TYPE} ${OS_VERSION}"

elif [ "$OS_VERSION" = "7" ]; then

docker run --privileged -d -ti -e "container=docker"  -v /sys/fs/cgroup:/sys/fs/cgroup -v `pwd`:/HermitCore:rw  ${OS_TYPE}:${OS_VERSION}   /usr/sbin/init
DOCKER_CONTAINER_ID=$(docker ps | grep centos | awk '{print $1}')
docker logs $DOCKER_CONTAINER_ID
docker exec -ti $DOCKER_CONTAINER_ID /bin/bash -xec "bash -xe /HermitCore/docker/tests_inside_docker.sh ${OS_VERSION};
  echo -ne \"------\nEND HermitCore TESTS\n\";"
docker ps -a
docker stop $DOCKER_CONTAINER_ID
docker rm -v $DOCKER_CONTAINER_ID

fi

elif [ "$OS_NAME" = "ubuntu" ]; then
# otherwise we run on Ubuntu

docker run --rm=true -v $(pwd):/HermitCore:rw ${OS_TYPE}:${OS_VERSION} /bin/bash -c "bash -xe /HermitCore/docker/tests_inside_docker.sh ${OS_TYPE} ${OS_VERSION}"

fi
