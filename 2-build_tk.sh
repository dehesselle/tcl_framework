#!/usr/bin/env bash

# This file is part of https://github.com/dehesselle/tcltk_framework
# SPDX-License-Identifier: MIT

### Tk version #################################################################

TK_VER_MAJOR=8
TK_VER_MINOR=6
TK_VER_PATCH=11
TK_VER=$TK_VER_MAJOR.$TK_VER_MINOR
TK_VER_FULL=$TK_VER.$TK_VER_PATCH
TK_URL=https://prdownloads.sourceforge.net/tcl/tk$TK_VER_FULL-src.tar.gz

## work directory ##############################################################

if [ -z $WRK_DIR ]; then
  WRK_DIR=$(mktemp -d /Users/Shared/work/tk.XXXXXX)
else
  WRK_DIR=$(mktemp -d $WRK_DIR/tk.XXXXXX)
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

curl -L $TK_URL | tar -C $WRK_DIR -xz
cd $WRK_DIR/tk*/unix

./configure \
  --enable-64bit \
  --enable-aqua \
  --enable-framework \
  --prefix=$WRK_DIR \
  --with-tcl=$(echo $WRK_DIR/../tcl.*/Library/Frameworks/Tcl.framework)

make -j$(sysctl -n hw.ncpu)

make install DESTDIR=$WRK_DIR

install_name_tool \
  -id Tk \
  $WRK_DIR/Library/Frameworks/Tk.framework/Versions/$TK_VER/Tk

WISH_EXE=$WRK_DIR/Library/Frameworks/Tk.framework/Versions/$TK_VER/Resources/\
Wish.app/Contents/MacOS/Wish

otool -L $WISH_EXE

install_name_tool \
  -change /Library/Frameworks/Tcl.framework/Versions/8.6/Tcl \
  @executable_path/../../../../../../../Tcl.framework/Tcl \
  $WISH_EXE

otool -L $WISH_EXE

install_name_tool \
  -change $(otool -L $WISH_EXE | grep "lib/Tk" | awk '{ print $1 }') \
  @executable_path/../../../../Tk \
  $WISH_EXE

otool -L $WISH_EXE

### packages artifacts #########################################################

tar -C $WRK_DIR/Library/Frameworks \
  -cjf $WRK_DIR/../Tk.framework.tar.bz2 \
  Tk.framework
