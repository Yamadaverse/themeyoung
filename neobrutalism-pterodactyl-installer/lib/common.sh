#!/usr/bin/env bash
# Shared safe helpers. No PHP package/service/config mutations are permitted.
PANEL_DIR="${PANEL_DIR:-/var/www/pterodactyl}"
BACKUP_ROOT="${BACKUP_ROOT:-/var/backups/neobrutalism-pterodactyl}"
LOG_DIR="${LOG_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/logs}"
log_init() {
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/${1}-$(date +%Y%m%d-%H%M%S).log"
  touch "$LOG_FILE"
}
log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "${LOG_FILE:-/dev/null}"; }
die() { log "ERROR: $*"; exit 1; }
require_root() { [[ "${EUID}" -eq 0 ]] || die "Jalankan dengan sudo/root."; }
is_ubuntu_2404() {
  [[ -r /etc/os-release ]] || return 1
  . /etc/os-release
  [[ "${ID:-}" == ubuntu && "${VERSION_ID:-}" == 24.04 ]]
}
panel_version_ok() {
  [[ -f "$PANEL_DIR/composer.json" ]] || return 1
  grep -Eq '"version"[[:space:]]*:[[:space:]]*"v?1\.15\.2"' "$PANEL_DIR/composer.json" && return 0
  # Some releases expose the version through package metadata rather than composer.json.
  grep -RqsE 'Pterodactyl.*1\.15\.2|"version"[[:space:]]*:[[:space:]]*"1\.15\.2"' "$PANEL_DIR/package.json" "$PANEL_DIR/config" 2>/dev/null
}
check_supported_target() {
  is_ubuntu_2404 || die "OS tidak didukung. Target: Ubuntu 24.04.x."
  panel_version_ok || die "Versi Panel tidak terdeteksi sebagai 1.15.2. Instalasi dihentikan."
  [[ -d "$PANEL_DIR" ]] || die "Panel tidak ditemukan: $PANEL_DIR"
}
disk_ok() {
  local avail
  avail="$(df -Pk "$PANEL_DIR" 2>/dev/null | awk 'NR==2 {print $4}')"
  [[ "${avail:-0}" -ge 2097152 ]]
}
payload_files_ok() {
  [[ -s "$(dirname -- "${BASH_SOURCE[0]}")/../payload/manifest.txt" ]] || return 1
  local base rel
  base="$(dirname -- "${BASH_SOURCE[0]}")/.."
  while IFS= read -r rel; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    [[ -f "$base/payload/$rel" ]] || return 1
  done < "$base/payload/manifest.txt"
}
validate_payload() {
  payload_files_ok || die "Payload theme belum lengkap. Lihat docs/PAYLOAD.md; tidak ada file panel yang diubah."
  grep -q '^PAYLOAD_STATUS=complete$' "$ROOT_DIR/payload/payload.conf" 2>/dev/null || die "Payload belum ditandai complete setelah audit."
}
create_backup() {
  local stamp target
  stamp="$(date +%Y%m%d-%H%M%S)"
  target="$BACKUP_ROOT/$stamp"
  mkdir -p "$target"
  cp "$ROOT_DIR/payload/manifest.txt" "$target/manifest.txt"
  while IFS= read -r rel; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    if [[ -e "$PANEL_DIR/$rel" ]]; then
      mkdir -p "$target/$(dirname "$rel")"
      cp -a "$PANEL_DIR/$rel" "$target/$rel"
    fi
  done < "$ROOT_DIR/payload/manifest.txt"
  printf '%s\n' "$target" > "$BACKUP_ROOT/LATEST"
  log "Backup dibuat: $target"
}
apply_payload() {
  while IFS= read -r rel; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    install -D -m 0644 "$ROOT_DIR/payload/$rel" "$PANEL_DIR/$rel"
    log "Dipasang: $rel"
  done < "$ROOT_DIR/payload/manifest.txt"
}
run_build() {
  cd "$PANEL_DIR"
  command -v yarn >/dev/null 2>&1 || die "Yarn tidak tersedia; build dilewati dan instalasi dihentikan."
  yarn run tsc || die "TypeScript check gagal."
  yarn run build:production || die "Build production gagal. Gunakan backup untuk pemulihan."
  log "Build production berhasil."
}
