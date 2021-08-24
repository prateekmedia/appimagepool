#!/bin/sh

sudo chmod +x appimagetool-x86_64.AppImage
mkdir AppDir/data AppDir/lib
cp -r target/release/data/* AppDir/data/
cp -r target/release/lib/* AppDir/lib/
cp target/release/appimagepool AppDir/appimagepool
for f in $(find -type l);do cp --remove-destination $(readlink $f) $f;done;

mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/appimagepool.png AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/appimagepool.png AppDir/appimagepool.png

mkdir -p AppDir/usr/share/applications
cp assets/appimagepool.desktop AppDir/usr/share/applications/appimagepool.desktop
cp assets/appimagepool.desktop AppDir/appimagepool.desktop

sudo chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ appimagepool-x86_64.AppImage
