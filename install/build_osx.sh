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
#cp "$PYTHON_PATH/Python" "$APP_PATH/Contents/MacOS"

# Add only the python modules we need
MODULES="LICENSE.txt
__future__.py
_collections_abc.py
_compat_pickle.py
_dummy_thread.py
_osx_support.py
_sitebuiltins.py
_sysconfigdata.py
_weakrefset.py
abc.py
ast.py
base64.py
bisect.py
calendar.py
cgi.py
codecs.py
collections
contextlib.py
copy.py
copyreg.py
datetime.py
dis.py
dummy_threading.py
email
encodings
enum.py
fnmatch.py
functools.py
genericpath.py
hashlib.py
heapq.py
hmac.py
html
http
importlib
inspect.py
io.py
json
keyword.py
linecache.py
locale.py
logging
mimetypes.py
opcode.py
operator.py
os.py
pickle.py
platform.py
posixpath.py
queue.py
quopri.py
random.py
re.py
reprlib.py
selectors.py
shutil.py
signal.py
site.py
socket.py
sre_compile.py
sre_constants.py
sre_parse.py
stat.py
string.py
struct.py
subprocess.py
sysconfig.py
tarfile.py
tempfile.py
threading.py
token.py
tokenize.py
traceback.py
types.py
urllib
uu.py
uuid.py
warnings.py
weakref.py"
mkdir -p "$APP_PATH/Contents/MacOS/lib/python3.5"
for FILE in $MODULES; do
  cp -r "$PYTHON_PATH/lib/python3.5/$FILE" "$APP_PATH/Contents/MacOS/lib/python3.5/"
done

# Add only the dynamic libraries we need
LIB_DYNLOAD="_md5.cpython-35m-darwin.so
_posixsubprocess.cpython-35m-darwin.so
_random.cpython-35m-darwin.so
_scproxy.cpython-35m-darwin.so
_sha1.cpython-35m-darwin.so
_sha256.cpython-35m-darwin.so
_sha512.cpython-35m-darwin.so
_socket.cpython-35m-darwin.so
_struct.cpython-35m-darwin.so
binascii.cpython-35m-darwin.so
math.cpython-35m-darwin.so
select.cpython-35m-darwin.so
zlib.cpython-35m-darwin.so"
mkdir -p "$APP_PATH/Contents/MacOS/lib/python3.5/lib-dynload"
for FILE in $LIB_DYNLOAD; do
  cp -r "$PYTHON_PATH/lib/python3.5/lib-dynload/$FILE" "$APP_PATH/Contents/MacOS/lib/python3.5/lib-dynload"
done

# Add only the modules from pip that we need
MODULES="PyQt5
packaging
pyparsing.py
requests
sip.so
six.py
socks.py
sockshandler.py
urllib3"
mkdir -p "$APP_PATH/Contents/MacOS/lib/packages"
for FILE in $MODULES; do
  cp -r "$ROOT/build/packages/$FILE" "$APP_PATH/Contents/MacOS/lib/packages/"
done

# Delete the parts of PyQt5 we don't need
PYQT5_TRASH="
Qt/lib/QtBluetooth.framework
Qt/lib/QtCLucene.framework
Qt/lib/QtConcurrent.framework
Qt/lib/QtDesigner.framework
Qt/lib/QtHelp.framework
Qt/lib/QtLocation.framework
Qt/lib/QtMacExtras.framework
Qt/lib/QtMultimedia.framework
Qt/lib/QtMultimediaWidgets.framework
Qt/lib/QtNetwork.framework
Qt/lib/QtNfc.framework
Qt/lib/QtOpenGL.framework
Qt/lib/QtPositioning.framework
Qt/lib/QtQml.framework
Qt/lib/QtQuick.framework
Qt/lib/QtQuickWidgets.framework
Qt/lib/QtSensors.framework
Qt/lib/QtSerialPort.framework
Qt/lib/QtSql.framework
Qt/lib/QtSvg.framework
Qt/lib/QtTest.framework
Qt/lib/QtWebChannel.framework
Qt/lib/QtWebEngineCore.framework
Qt/lib/QtWebEngineWidgets.framework
Qt/lib/QtWebSockets.framework
Qt/lib/QtXml.framework
Qt/lib/QtXmlPatterns.framework
Qt/plugins/audio
Qt/plugins/bearer
Qt/plugins/generic
Qt/plugins/geoservices
Qt/plugins/iconengines
Qt/plugins/imageformats/libqdds.dylib
Qt/plugins/imageformats/libqgif.dylib
Qt/plugins/imageformats/libqico.dylib
Qt/plugins/imageformats/libqjpeg.dylib
Qt/plugins/imageformats/libqmacjp2.dylib
Qt/plugins/imageformats/libqsvg.dylib
Qt/plugins/imageformats/libqtga.dylib
Qt/plugins/imageformats/libqtiff.dylib
Qt/plugins/imageformats/libqwbmp.dylib
Qt/plugins/imageformats/libqwebp.dylib
Qt/plugins/mediaservice
Qt/plugins/platforms/libqminimal.dylib
Qt/plugins/platforms/libqoffscreen.dylib
Qt/plugins/playlistformats
Qt/plugins/position
Qt/plugins/printsupport
Qt/plugins/sceneparsers
Qt/plugins/sensorgestures
Qt/plugins/sensors
Qt/plugins/sqldrivers
QtBluetooth.so
QtDBus.so
QtDesigner.so
QtHelp.so
QtLocation.so
QtMacExtras.so
QtMultimedia.so
QtMultimediaWidgets.so
QtNetwork.so
QtNfc.so
QtOpenGL.so
QtPositioning.so
QtPrintSupport.so
QtQml.so
QtQuick.so
QtQuickWidgets.so
QtSensors.so
QtSerialPort.so
QtSql.so
QtSvg.so
QtTest.so
QtWebChannel.so
QtWebEngineCore.so
QtWebEngineWidgets.so
QtWebSockets.so
QtXml.so
QtXmlPatterns.so
_QOpenGLFunctions_2_0.so
_QOpenGLFunctions_2_1.so
_QOpenGLFunctions_4_1_Core.so
__pycache__/pylupdate_main.cpython-35.pyc
__pycache__/pyrcc_main.cpython-35.pyc
pylupdate.so
pylupdate_main.py
pyrcc.so
pyrcc_main.py
uic"
for FILE in $PYQT5_TRASH; do
  rm -r "$APP_PATH/Contents/MacOS/lib/packages/PyQt5/$FILE"
done

# Add gpgsync module
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
