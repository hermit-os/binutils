#!/bin/sh -e
# /usr/lib/emacsen-common/packages/remove/binutils

FLAVOR=$1
PACKAGE=binutils

if [ ${FLAVOR} != emacs ]; then
    if test -x /usr/sbin/install-info-altdir; then
        echo remove/${PACKAGE}: removing Info links for ${FLAVOR}
        install-info-altdir --quiet --remove --dirname=${FLAVOR} /opt/hermit/share/info/binutils.info.gz
    fi

    echo remove/${PACKAGE}: purging byte-compiled files for ${FLAVOR}
    rm -rf /opt/hermit/share/${FLAVOR}/site-lisp/${PACKAGE}
fi
