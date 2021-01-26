#!/usr/bin/env bash

TCL_VER_MAJOR=8
TCL_VER_MINOR=6
TCL_VER_PATCH=11
TCL_VER=$TCL_VER_MAJOR.$TCL_VER_MINOR
TCL_VER_FULL=$TCL_VER.$TCL_VER_PATCH
TCL_URL=https://prdownloads.sourceforge.net/tcl/tcl$TCL_VER_FULL-src.tar.gz

#########

WRK_DIR=$(mktemp -d /Users/Shared/work/tcl.XXXXXX)

SDKROOT=/opt/sdks/MacOSX10.11.sdk

export PATH=/Users/Shared/work/bin:/usr/bin:/bin:/usr/sbin:/sbin
if [ -z $SDKROOT ]; then
  SDKROOT=$(xcrun --show-sdk-path)
fi
export SDKROOT
export MACOSX_DEPLOYMENT_TARGET=$(/usr/libexec/PlistBuddy -c 'Print :DefaultProperties:MACOSX_DEPLOYMENT_TARGET' $SDKROOT/SDKSettings.plist)

##########

cd $WRK_DIR
curl -L $TCL_URL | tar xz
cd tcl*/unix
./configure --prefix=$WRK_DIR --enable-64bit --enable-framework
make -j$(sysctl -n hw.ncpu)
install_name_tool -change /Library/Frameworks/Tcl.framework/Versions/$TCL_VER/Tcl @executable_path/Tcl tclsh
make install DESTDIR=$WRK_DIR NATIVE_TCLSH=$(pwd)/tclsh

cp tclsh $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/$TCL_VER/tclsh$TCL_VER
