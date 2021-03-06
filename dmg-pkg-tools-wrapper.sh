#!/bin/bash

# Wrapper for command-line access to dmg-pkg-tools.sh

# Sample usages:
# ./dmg-pkg-tools-wrapper.sh --extract ../cross-mac/xcode_3.2.6_and_ios_sdk_4.3.dmg files/pkgs MacOSX10.5.pkg iPhoneSDK4_3.pkg
# ./dmg-pkg-tools-wrapper.sh --extract xcode_4.2.1_for_lion.dmg files files/pkgs InstallXcodeLion.pkg

. $(dirname "$0")/dmg-pkg-tools.sh

_OPERATION=$1
if [[ "$_OPERATION" == "--help" ]] || [[ -z $1 ]] ; then
	echo "$0 --cache <dmg-file> <dest> <--keep-mounted> <--key KEY> <dst-files-folder> FILES..."
	echo "$0 --extract <dmg-file> <--keep-mounted> <--key KEY> <dst-files-folder> FILES..."
	echo "$0 --extract-cached CACHED_PKG_FILES..."
	echo "$0 --list <dmg-file>"
	echo "$0 --umount"
	exit 1
fi
shift
TMPDIR=$PWD/tmp
MNTDIR=$PWD/mnt
INSTDIR=$PWD/install
mkdir -p $TMPDIR
build_tools_dmg $TMPDIR $INSTDIR
if [[ "$_OPERATION" = "--cache" ]] || [[ "$_OPERATION" = "--extract" ]] ; then
	DMGFILE=$1
	if [[ ! -f $DMGFILE ]] ; then
		echo "Couldn't find dmg file $DMGFILE"
		exit
	fi
	shift
	KEEP_MOUNTED=0
	if [[ "$1" == "--keep-mounted" ]] ; then
		KEEP_MOUNTED=1
		shift
	fi
	KEY=0
	if [[ "$1" == "--key" ]] ; then
		shift
		KEY=$1
		shift
	fi
	DEST=$1
	shift
	DEST=${DEST%/*}
	if [[ ! -d $DEST ]] ; then
		message "Created $DEST folder"
		mkdir -p $DEST
	fi
	if [[ "$_OPERATION" == "--extract" ]] ; then
		# For --extract, XDEST is where the package's contents get written (e.g. files/sdks)
		XDEST=$1
		shift
	fi
	FILES=("$@")
	CACHED_PACKAGES=( $(cache_packages $DMGFILE $DEST $KEEP_MOUNTED $KEY $TMPDIR $MNTDIR "${FILES[@]}") )
	echo "Cached packages ${CACHED_PACKAGES[@]}"
	if [[ "$_OPERATION" == "--extract" ]] ; then
		extract_packages_cached $XDEST ${CACHED_PACKAGES[@]}
	fi
elif [[ "$_OPERATION" == "--extract-cached" ]] ; then
	FILES=("$@")
	extract_packages_cached $TMPDIR $FILES
elif [[ "$_OPERATION" == "--list" ]] ; then
	DMGFILE=$1
	shift
	mount_dmg $TMPDIR $DMGFILE $MNT_DIR
	find $MNT_DIR
	exit 0
elif [[ "$_OPERATION" == "--umount" ]] ; then
	umount_dmg
fi
