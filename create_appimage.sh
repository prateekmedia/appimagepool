#!/bin/sh

sudo chmod +x appimagetool-x86_64.AppImage
cp -r build/linux/x64/release/bundle/* AppDir
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/appimagepool.png AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/appimagepool.png AppDir/appimagepool.png
mkdir -p AppDir/usr/share/applications
cp assets/appimagepool.desktop AppDir/usr/share/applications/appimagepool.desktop
cp assets/appimagepool.desktop AppDir/appimagepool.desktop
sudo chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ appimagepool-x86_64.AppImage
