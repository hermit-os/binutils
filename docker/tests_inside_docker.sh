#!/bin/bash

OS_NAME=$1
OS_VERSION=$2

if [ "$OS_NAME" = "centos" ]; then

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
yum install -y binutils gcc gcc-c++ texinfo kernel-headers rpm-build

elif [ "$OS_NAME" = "ubuntu" ]; then

sudo apt-get -qq update
sudo apt-get install -y binutils texinfo gcc g++ g++-multilib packaging-dev build-essential kernel-package

fi
