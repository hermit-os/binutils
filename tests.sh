#!/bin/bash

OS_NAME=$1
OS_VERSION=$2
TARGET=$3
PKGNAME=$4

if [ "$OS_NAME" = "centos" ]; then

	# Clean the yum cache
	yum -y clean all
	yum -y clean expire-cache

	# First, install all the needed packages.
	yum install -y wget gettext flex bison binutils gcc gcc-c++ texinfo kernel-headers rpm-build kernel-devel boost-devel cmake git tar gzip make autotools

	wget http://checkinstall.izto.org/files/source/checkinstall-1.6.2.tar.gz
	tar xzvf checkinstall-1.6.2.tar.gz
	cd checkinstall-1.6.2
	./configure
	make
	make install
	cd ..
	rm -rf checkinstall*

	mkdir -p build
	cd build
	../configure --target=${TARGET} --prefix=/opt/hermit --disable-shared --disable-nls --disable-gdb --disable-libdecnumber --disable-readline --disable-sim --disable-libssp --enable-tls --disable-multilib
	make
	checkinstall -R -y --exclude=build --pkggroup=main --maintainer=stefan@eonerc.rwth-aachen.de --pkgsource=https://hermitcore.org --pkgname=${PKGNAME} --pkgversion=2.30.51 --pkglicense=GPL2 make install

else

	export DEBIAN_FRONTEND="noninteractive"

	apt-get -qq update
	apt-get install -y --no-install-recommends bison checkinstall flex gcc libc-dev texinfo

	mkdir -p build
	cd build
	../configure --target=${TARGET} --prefix=/opt/hermit --disable-shared --disable-nls --disable-gdb --disable-libdecnumber --disable-readline --disable-sim --disable-libssp --enable-tls --disable-multilib
	make
	checkinstall -D -y --exclude=build --pkggroup=main --maintainer=stefan@eonerc.rwth-aachen.de --pkgsource=https://hermitcore.org --pkgname=${PKGNAME} --pkgversion=2.30.51 --pkglicense=GPL2 make install

	# Unpack the created .deb and let Travis repackage it.
	# This is a workaround for Bintray, which doesn't understand the default .deb compression of Ubuntu 18.04.
	cd ..
	mkdir -p ${TARGET}_unpacked
	dpkg-deb -R build/${PKGNAME}_2.30.51-1_amd64.deb ${TARGET}_unpacked
	rm -rf build

fi
