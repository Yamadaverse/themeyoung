#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/lib/common.sh"
require_root
log_init install
"$ROOT_DIR/analyze.sh" --quiet || die "Preflight gagal. Periksa log analyze."
check_supported_target
validate_payload
create_backup
apply_payload
run_build
log "Instalasi payload selesai. Periksa log dan verifikasi panel melalui browser."
