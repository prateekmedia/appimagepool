#!/bin/sh

# Create Application Directory
mkdir -p AppDir

# Create AppRun file(required by AppImage)
echo '#!/bin/sh

cd "$(dirname "$0")"
exec ./appimagepool' > AppDir/AppRun
sudo chmod +x AppDir/AppRun

# Copy all build files to AppDir
cp -aR target/release/data/ AppDir/data/
cp -aR target/release/lib/ AppDir/lib/
install -Dm777 target/release/appimagepool AppDir/appimagepool
for f in $(find -type l);do cp --remove-destination $(readlink $f) $f;done;

## Add Application metadata
# Copy app icon

install -Dm777  assets/appimagepool.png AppDir/appimagepool.png
sudo install -Dm777 AppDir/appimagepool.png AppDir/usr/share/icons/hicolor/256x256/apps/appimagepool.png

# Either copy .desktop file content from file or with echo command
# cp assets/appimagepool.desktop AppDir/appimagepool.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=AppImage Pool
Icon=appimagepool
Exec=appimagepool %u
StartupWMClass=appimagepool
Categories=Utility;
Keywords=AppImage;Store;AppImageHub;Flutter;Gtk;' > AppDir/appimagepool.desktop

sudo install -Dm777 AppDir/appimagepool.desktop AppDir/usr/share/applications/appimagepool.desktop

## Start build
test ! -e appimagetool-x86_64.AppImage && curl -L https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -o appimagetool-x86_64.AppImage
sudo chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ appimagepool-x86_64.AppImage
