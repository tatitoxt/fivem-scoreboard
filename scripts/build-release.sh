#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
version=$(grep -oP "version '\K[0-9.]+" fxmanifest.lua | head -1)
mkdir -p dist
out="dist/orkelya_scoreboard-${version}.zip"
zip -qr "$out" client ui config.lua fxmanifest.lua README.md LICENSE
echo "[release] $out"
