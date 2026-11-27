#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCKFILE="$ROOT/netsurf.lock"

while read -r name url revision extra || [[ -n "$name" ]]; do
    [[ -z "$name" || "$name" == \#* ]] && continue

    if [[ ! "$name" =~ ^[a-zA-Z0-9][a-zA-Z0-9._]*$ || "$url" != https://* || ! "$revision" =~  ^[0-9a-f]{40}$ || -n "$extra" ]]; then
        printf 'Invalid entry in %s for %s (expected name URL commit-SHA)\n' "$LOCKFILE" "$name" >&2
        exit 1
    fi

    source_dir="$ROOT/build/$name"

    printf '=> Cloning %s into %s' "$name" "$source_dir"

    git init --quiet "$source_dir"
    git -C "$source_dir" fetch --depth=1 "$url" "$revision"
    git -C "$source_dir" checkout --detach "$revision"
done < "$LOCKFILE"
