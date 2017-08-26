#!/bin/bash

OS_NAME=$1
OS_VERSION=$2

if [ "$OS_NAME" = "centos" ]; then

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
yum install -y binutils gcc gcc-c++ texinfo kernel-headers rpm-build kernel-devel

elif [ "$OS_NAME" = "ubuntu" ]; then

apt-get -qq update
apt-get install -y binutils texinfo gcc g++ packaging-dev build-essential kernel-package

fi
