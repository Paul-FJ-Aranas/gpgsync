#!/bin/bash

CONTENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

export PATH="$CONTENTS_DIR/MacOS/bin"
export PYTHONHOME="$CONTENTS_DIR/MacOS"
export PYTHONPATH="$CONTENTS_DIR/MacOS/lib/python3.5"
export GPGSYNC_RESOURCE_DIR="$CONTENTS_DIR/Resources/share"

"$CONTENTS_DIR/MacOS/GPG Sync" -c "import gpgsync; gpgsync.main()"
