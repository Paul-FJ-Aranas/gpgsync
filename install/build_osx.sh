#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
cd $ROOT

APP_PATH="$ROOT/build/GPG Sync.app"
PKG_PATH="$ROOT/dist/GPGSync.pkg"

# Clean up from last time
if [ "$1" = "--clean" ]; then
  # Delete old build, dist
  rm -rf "$ROOT/build" "$ROOT/dist" &>/dev/null 2>&1
  exit
else
  # Just clean up the old .app folder and .pkg
  rm -rf "$APP_PATH" "$PKG_PATH" &>/dev/null 2>&1
fi

mkdir -p $ROOT/build

# Make sure we have the proper dependencies
if [ ! -d "$ROOT/build/env" ]; then
  pyvenv-3.5 "$ROOT/build/env"
  . "$ROOT/build/env/bin/activate"
  mkdir "$ROOT/build/packages"
  pip3 install -r "$ROOT/requirements.txt" --target "$ROOT/build/packages"
fi

# Build the .app
echo "Building $APP_PATH"

# Create the right directories
mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

# Add the Info.plist file
VERSION=`cat $ROOT/share/version`
sed s/{VERSION}/$VERSION/g "$ROOT/install/Info.plist" > "$APP_PATH/Contents/Info.plist"

# Add the icon, and other resources
cp "$ROOT/install/gpgsync.icns" "$APP_PATH/Contents/Resources/gpgsync.icns"
cp -r "$ROOT/share" "$APP_PATH/Contents/Resources/share"

# Add python
PYTHON_PATH="/Library/Frameworks/Python.framework/Versions/3.5/"
mkdir -p "$APP_PATH/Contents/MacOS/bin"
cp "$PYTHON_PATH/bin/python3.5" "$APP_PATH/Contents/MacOS/bin"
cp "$PYTHON_PATH/Python" "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/MacOS/lib"

# Add python modules
cp -r "$PYTHON_PATH/lib/python3.5" "$APP_PATH/Contents/MacOS/lib"
cp -r "$ROOT/build/packages" "$APP_PATH/Contents/MacOS/lib/"
cp -r "$ROOT/gpgsync" "$APP_PATH/Contents/MacOS/lib/packages/"

# Add the osx launcher
cp "$ROOT/install/osx-launcher.sh" "$APP_PATH/Contents/MacOS/launcher.sh"
cp "$ROOT/install/osx-launcher.py" "$APP_PATH/Contents/MacOS/launcher.py"
chmod 755 "$APP_PATH/Contents/MacOS/launcher.sh"

if [ "$1" = "--release" ]; then
  mkdir -p "$ROOT/build"

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
