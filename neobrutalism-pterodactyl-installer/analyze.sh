#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/lib/common.sh"
QUIET=0
[[ "${1:-}" == "--quiet" ]] && QUIET=1
log_init analyze
failures=0
check() { local label="$1"; shift; if "$@"; then report "OK" "$label"; else report "WARN" "$label"; failures=$((failures+1)); fi; }
report() { [[ "$QUIET" -eq 1 ]] && return 0; printf '[%s] %s\n' "$1" "$2"; }
PANEL_DIR="${PANEL_DIR:-/var/www/pterodactyl}"
check "Ubuntu 24.04.x" is_ubuntu_2404
check "Panel directory exists: $PANEL_DIR" test -d "$PANEL_DIR"
check "Pterodactyl version is 1.15.2" panel_version_ok
check "PHP CLI available (inspection only)" command -v php
check "Composer available" command -v composer
check "Node.js available" command -v node
check "Yarn available" command -v yarn
check "Nginx available" command -v nginx
check "Sufficient free disk space (>= 2 GiB)" disk_ok
check "Payload manifest exists" test -s "$ROOT_DIR/payload/manifest.txt"
check "Payload files present" payload_files_ok
if [[ "$QUIET" -eq 1 ]]; then
  [[ "$failures" -eq 0 ]]
else
  printf '\nPemeriksaan selesai. Temuan: %s warning/check gagal.\n' "$failures"
  printf 'Log: %s\n' "$LOG_FILE"
  printf 'Catatan: PHP hanya diperiksa; tidak akan diubah oleh installer.\n'
fi
