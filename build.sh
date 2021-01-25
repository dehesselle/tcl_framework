#!/usr/bin/env bash

WRK_DIR=$(mktemp -d /Users/Shared/work/tcl.XXXXXXX)

SDKROOT=/opt/sdks/MacOSX10.11.sdk

export PATH=/Users/Shared/work/bin:/usr/bin:/bin:/usr/sbin:/sbin
if [ -z $SDKROOT ]; then
  SDKROOT=$(xcrun --show-sdk-path)
fi
export SDKROOT
export MACOSX_DEPLOYMENT_TARGET=$(/usr/libexec/PlistBuddy -c 'Print :DefaultProperties:MACOSX_DEPLOYMENT_TARGET' $SDKROOT/SDKSettings.plist)

##########

cd $WRK_DIR
curl -L https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz | tar xz
cd tcl*/macosx
./configure --prefix=$WRK_DIR --enable-64bit --enable-framework --libdir=$WRK_DIR/Library/Frameworks
make -j$(sysctl -n hw.ncpu)
install_name_tool -change /Library/Frameworks/Tcl.framework/Versions/8.6/Tcl $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/8.6/Tcl $WRK_DIR/build/tcl/tclsh8.6

make install DESTDIR=$WRK_DIR NATIVE_TCLSH=$WRK_DIR/build/tcl/tclsh8.6

cp $WRK_DIR/build/tcl/tclsh8.6 $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/8.6
install_name_tool -change $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/8.6/Tcl @executable_path/Tcl $WRK_DIR/Library/Frameworks/Tcl.framework/Versions/8.6/tclsh8.6
