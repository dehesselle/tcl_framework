#!/usr/bin/env bash

# This file is part of https://github.com/dehesselle/tcl_framework
# SPDX-License-Identifier: MIT

### Tcl version ################################################################

TCL_VER_MAJOR=8
TCL_VER_MINOR=6
TCL_VER_PATCH=11
TCL_VER=$TCL_VER_MAJOR.$TCL_VER_MINOR
TCL_VER_FULL=$TCL_VER.$TCL_VER_PATCH
TCL_URL=https://prdownloads.sourceforge.net/tcl/tcl$TCL_VER_FULL-src.tar.gz

### work directory #############################################################

if [ -z $WRK_DIR ]; then
  WRK_DIR=$(mktemp -d /Users/Shared/work/tcl.XXXXXX)
fi

mkdir -p $WRK_DIR

### path #######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

### target platform ############################################################

if [ -z $SDKROOT ]; then
  SDKROOT=$(xcrun --show-sdk-path)
fi
export SDKROOT

# get deployment target version from SDK
export MACOSX_DEPLOYMENT_TARGET=$(/usr/libexec/PlistBuddy \
  -c 'Print :DefaultProperties:MACOSX_DEPLOYMENT_TARGET' \
  $SDKROOT/SDKSettings.plist)

### build ######################################################################

LOG=$WRK_DIR/build.log
echo "SDKROOT=$SDKROOT" >> $LOG
echo "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET" >> $LOG

curl -L $TCL_URL | tar -C $WRK_DIR -xz
cd $WRK_DIR/tcl*/unix

./configure --prefix=$WRK_DIR --enable-64bit --enable-framework
make -j$(sysctl -n hw.ncpu)
install_name_tool \
  -change /Library/Frameworks/Tcl.framework/Versions/$TCL_VER/Tcl \
  @executable_path/Tcl \
  tclsh
make install DESTDIR=$WRK_DIR NATIVE_TCLSH=$(pwd)/tclsh

cp tclsh \
  $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/$TCL_VER/tclsh$TCL_VER

### packages artifacts #########################################################

tar -C $WRK_DIR/Library/Frameworks \
  -cjf $WRK_DIR/Tcl.framework.tar.bz2 \
  Tcl.framework
tar -C $WRK_DIR/Library \
  -cjf $WRK_DIR/Tcl.tar.bz2 \
  Tcl
