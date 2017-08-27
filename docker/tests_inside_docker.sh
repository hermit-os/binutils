#!/bin/bash

OS_NAME=$1
OS_VERSION=$2

cd /rwth-os/binutils/

if [ "$OS_NAME" = "centos" ]; then

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
yum install -y binutils gcc gcc-c++ texinfo kernel-headers rpm-build kernel-devel boost-devel cmake git tar gzip make autotools

# Prepare the RPM environment
mkdir -p /tmp/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cat >> /etc/rpm/macros.dist << EOF
%dist .osg.el${OS_VERSION}
%osg 1
EOF

elif [ "$OS_NAME" = "ubuntu" ]; then

apt-get -qq update
apt-get install -y binutils texinfo gcc g++ packaging-dev build-essential kernel-package

time debuild -us -uc -j2
md5sum ../*.deb

fi
