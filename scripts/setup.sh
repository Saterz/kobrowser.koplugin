#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/build/netsurf"
REVISION="$(cat "$ROOT/netsurf-revision")"
REPOSITORY="https://github.com/netsurf-browser/netsurf.git"

git init "$SOURCE"
git -C "$SOURCE" remote add origin "$REPOSITORY"
git -C "$SOURCE" fetch --depth=1 origin "$REVISION"
git -C "$SOURCE" checkout --detach FETCH_HEAD
