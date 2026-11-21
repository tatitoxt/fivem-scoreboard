#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$PWD"
CACHE="${E2E_CACHE_DIR:-$ROOT/.cache/fxserver}"
RUN="$ROOT/.cache/e2e-run"
rm -rf "$RUN"; mkdir -p "$RUN/resources"
mkdir -p "$RUN/resources/orkelya_scoreboard" "$RUN/resources/orkelya_scoreboard_probe"
cp -r client ui config.lua fxmanifest.lua "$RUN/resources/orkelya_scoreboard/"
cp -r tests/e2e_probe/* "$RUN/resources/orkelya_scoreboard_probe/"
cat > "$RUN/server.cfg" <<CFG
endpoint_add_tcp "0.0.0.0:30120"
sv_hostname "orkelya_scoreboard e2e"
sv_licenseKey "$FIVEM_LICENSE_KEY"
set fx_enableAuthSession "0"
endpoint_add_udp "127.0.0.1:30120"
sv_maxclients 1
set sv_lan 1
add_ace resource.orkelya_scoreboard_probe command.quit allow
ensure orkelya_scoreboard
ensure orkelya_scoreboard_probe
CFG
changelog="https://changelogs-live.fivem.net/api/changelog/versions/linux/server"
artifact_url=${FXSERVER_ARTIFACT_URL:-$(curl -fsSL --retry 3 "$changelog" | python3 -c 'import json,sys;print(json.load(sys.stdin)["recommended_download"])')}
[[ $artifact_url =~ /([0-9]+)-[0-9a-f]+/fx\.tar\.xz$ ]] || { echo '[e2e] URL inesperada'; exit 2; }
build="${BASH_REMATCH[1]}"
fx_dir="$CACHE/$build"
if [[ ! -x "$fx_dir/alpine/opt/cfx-server/FXServer" ]]; then
  mkdir -p "$fx_dir"
  curl -fSL --retry 3 -o "$fx_dir/fx.tar.xz" "$artifact_url"
  tar -xf "$fx_dir/fx.tar.xz" -C "$fx_dir"
fi
cd "$RUN"
tail -f /dev/null | timeout --kill-after=10 60 bash "$fx_dir/run.sh" +set onesync on +exec server.cfg > log.txt 2>&1 || true
grep -aE "SCORETEST" log.txt || true
grep -qa "RESULT status=PASS" log.txt
