#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/lib/common.sh"
require_root
log_init uninstall
PANEL_DIR="${PANEL_DIR:-/var/www/pterodactyl}"
BACKUP_ROOT="${BACKUP_ROOT:-/var/backups/neobrutalism-pterodactyl}"
[[ -d "$BACKUP_ROOT" ]] || die "Folder backup tidak ditemukan: $BACKUP_ROOT"
latest="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -name '20*' -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)"
[[ -n "$latest" ]] || die "Belum ada backup installer yang dapat dipulihkan."
echo "Backup yang akan dipulihkan: $latest"
read -r -p "Ketik RESTORE untuk melanjutkan: " answer
[[ "$answer" == "RESTORE" ]] || die "Dibatalkan."
while IFS= read -r rel; do
  [[ -n "$rel" ]] || continue
  if [[ -f "$latest/$rel" ]]; then
    install -D -m 0644 "$latest/$rel" "$PANEL_DIR/$rel"
    log "Dipulihkan: $rel"
  fi
done < "$latest/manifest.txt"
log "Pemulihan file selesai. Database tidak disentuh oleh skrip ini."
