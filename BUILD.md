# Build instructions

## Mac OS X

Download and install Python 3 from https://www.python.org/downloads/. I downloaded `python-3.5.2-macosx10.6.pkg`.

Download and install Qt5 from https://www.qt.io/download-open-source/. I downloaded `qt-unified-mac-x64-2.0.3-2-online.dmg`. When installing you can skip the Qt Account page. The OS X build script assumes you installed Qt in `~/Qt/`. Install `Qt 5.7 > OS X`.

Go to the `gpgsync` folder before and run this to build the app. Here's how to build a `build/GPG Sync.app`:

```sh
install/build_osx.sh
```

Here's how to build a codesigned package for distribution, `dist\GPGSync.pkg`:

```sh
install/build_osx.sh --release
```

Here's how to clean everything from an earlier build:

```sh
install/build_osx.sh --clean
```

## Linux distributions

*Debian / Ubuntu / Mint*

Install dependencies:

```sh
sudo apt-get install python3-pyqt5 python3-nose python3-stdeb python3-requests python3-socks python3-packaging gnupg2
```

Make and install a .deb:

```sh
./install/build_deb.sh
sudo dpkg -i deb_dist/gpgsync_*.deb
```

## Run the tests

From the `gpgsync` folder run:

```sh
nosetests
```

Note that one of the tests will fail if you don't have SOCKS5 proxy server listening on port 9050 (e.g. Tor installed).
