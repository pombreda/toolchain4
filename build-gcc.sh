#!/bin/bash

. ./bash-tools.sh

if [[ -z $1 ]] ; then
    error "Please pass in a prefix suffix as argument"
    exit 1
fi

rm -rf bld-$1/gcc-5665.3-11 src-$1/gcc-5666.3
PREFIX_SUFFIX=$1 ./toolchain.sh gcc

#[[ -f tc4-bld-src-$(uname-bt).7z ]] && rm rc-bld-src-$(uname-bt).7z

#mv src src-$(uname-bt)
#mv bld bld-$(uname-bt)
# 7za a tc4-bld-src-$(uname-bt).7z bld-$(uname-bt) src-$(uname-bt)
#mv src-$(uname-bt) src
#mv bld-$(uname-bt) bld
