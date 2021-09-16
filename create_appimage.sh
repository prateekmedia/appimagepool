#!/bin/sh

# Create Application Directory
mkdir -p AppDir

# Create AppRun file(required by AppImage)
echo '#!/bin/sh

cd "$(dirname "$0")"
exec ./appimagepool' > AppDir/AppRun
chmod +x AppDir/AppRun

# Copy all build files to AppDir
cp -aR target/release/data/ AppDir/data/
cp -aR target/release/lib/ AppDir/lib/
install -Dm777 target/release/appimagepool AppDir/appimagepool
for f in $(find -type l);do cp --remove-destination $(readlink $f) $f;done;

## Add Application metadata
# Copy app icon

install -Dm644  assets/appimagepool.svg AppDir/appimagepool.svg
install -Dm644 AppDir/appimagepool.svg AppDir/usr/share/icons/hicolor/128x128/apps/appimagepool.svg

# Copy .desktop file content from file

install -Dm644  assets/appimagepool.desktop AppDir/appimagepool.desktop
install -Dm644 AppDir/appimagepool.desktop AppDir/usr/share/applications/appimagepool.desktop

# Add appdata to appimage
install -Dm644 assets/appimagepool.appdata.xml AppDir/appimagepool.appdata.xml
install -Dm644 AppDir/appimagepool.appdata.xml AppDir/usr/share/metainfo/appimagepool.appdata.xml

## Start build
test ! -e appimagetool-x86_64.AppImage && curl -L https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -o appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ appimagepool-x86_64.AppImage
