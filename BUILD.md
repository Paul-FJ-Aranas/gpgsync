# Build instructions

## Mac OS X

Install Xcode from the Mac App Store. Once it's installed, run it for the first time to set it up.

If you don't already have it installed, install [Homebrew](http://brew.sh/).

Install some dependencies using Homebrew:

```sh
brew install python3 pyqt5 qt5
```

Note that there's no simple way to install specific versions of Homebrew packages. If you're following these instructions in the future, you might need to modify `install/build_osx.sh` to use new paths of the newer versions of these packages.

Install some dependencies using pip3:

```sh
virtualenv -p python3 env
. env/bin/activate
pip3 install -r requirements.txt
```

Download and install the [Rust programming language](https://www.rust-lang.org/en-US/), which is required for building the OSX launcher.

Now you're ready to build the actual app. Go to the `gpgsync` folder before and run this to build the app:

```sh
install/build_osx.sh
```

Now you should have `build/GPG Sync.app`.

To codesign and build a .pkg for distribution:

```sh
install/build_osx.sh --release
```

Now you should have `dist/GPGSync.pkg`. NOTE: This isn't implemented yet.

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
