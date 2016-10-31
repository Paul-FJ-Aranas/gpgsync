#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
cd $ROOT

# Clean up from last time
echo Deleting old build folder
rm -rf $ROOT/build &>/dev/null 2>&1

# Build the osx launcher
echo Building OSX launcher
cd $ROOT/install/osx-launcher
cargo build --release
cd $ROOT
export OSX_LAUNCHER=$ROOT/install/osx-launcher/target/release/osx-launcher

# Build the .app
echo Building \'GPG Sync.app\'

# Create the right directories
export APP_CONTENTS="$ROOT/build/GPG Sync.app/Contents"
mkdir -p "$APP_CONTENTS"
mkdir "$APP_CONTENTS/Frameworks"
mkdir "$APP_CONTENTS/MacOS"
mkdir "$APP_CONTENTS/Resources"

# Add the Info.plist file
VERSION=`cat $ROOT/share/version`
sed s/{VERSION}/$VERSION/g "$ROOT/install/Info.plist" > "$APP_CONTENTS/Info.plist"

# Add the osx launcher
cp $OSX_LAUNCHER "$APP_CONTENTS/MacOS/gpgsync"


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
