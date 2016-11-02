#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
cd $ROOT

# Clean up from last time
echo Deleting old build folder
rm -rf $ROOT/build &>/dev/null 2>&1

# Build the .app
echo Building \'GPG Sync.app\'

# Create the right directories
export APP_CONTENTS="$ROOT/build/GPG Sync.app/Contents"
mkdir -p "$APP_CONTENTS"
mkdir -p "$APP_CONTENTS/MacOS"
mkdir -p "$APP_CONTENTS/Resources"

# Add the Info.plist file
VERSION=`cat $ROOT/share/version`
sed s/{VERSION}/$VERSION/g "$ROOT/install/Info.plist" > "$APP_CONTENTS/Info.plist"

# Add the icon, and other resources
cp "$ROOT/install/gpgsync.icns" "$APP_CONTENTS/Resources/gpgsync.icns"
cp -r "$ROOT/share" "$APP_CONTENTS/Resources/share"

# Add python and pip packages
mkdir -p "$APP_CONTENTS/MacOS/bin"
cp "$ROOT/env/bin/python3" "$APP_CONTENTS/MacOS/bin"
cp "$ROOT/env/.Python" "$APP_CONTENTS/MacOS"
cp -r "$ROOT/env/lib" "$APP_CONTENTS/MacOS/lib"

# Make a relative symlink to python3 called "GPG Sync"
cd "$APP_CONTENTS/MacOS"
ln -s bin/python3 "GPG Sync"
cd $ROOT

# Add qt5 and pyqt5, installed by homebrew
cp -r /usr/local/lib/python3.5/site-packages/sip* "$APP_CONTENTS/MacOS/lib/python3.5/site-packages/"
cp -r /usr/local/lib/python3.5/site-packages/PyQt5 "$APP_CONTENTS/MacOS/lib/python3.5/site-packages/"
# todo: add Qt5

# Add gpgsync python module
cp -r "$ROOT/gpgsync" "$APP_CONTENTS/MacOS"
cd "$APP_CONTENTS/MacOS/lib/python3.5/"
ln -s ../../gpgsync gpgsync
cd $ROOT

# Add the osx launcher
cp "$ROOT/install/osx-launcher.sh" "$APP_CONTENTS/MacOS/launcher.sh"
chmod 755 "$APP_CONTENTS/MacOS/launcher.sh"

if [ "$1" = "--release" ]; then
  mkdir -p dist
  APP_PATH="build/GPG Sync.app"
  PKG_PATH="dist/GPGSync.pkg"
  IDENTITY_NAME_APPLICATION="Developer ID Application: FIRST LOOK PRODUCTIONS, INC."
  IDENTITY_NAME_INSTALLER="Developer ID Installer: FIRST LOOK PRODUCTIONS, INC."

  echo "Codesigning the app bundle"
  codesign --deep -s "$IDENTITY_NAME_APPLICATION" "$APP_PATH"

  echo "Creating an installer"
  productbuild --sign "$IDENTITY_NAME_INSTALLER" --component "$APP_PATH" /Applications "$PKG_PATH"

  echo "Cleaning up"
  rm -rf "$APP_PATH"

  echo "All done, your installer is in: $PKG_PATH"
fi
