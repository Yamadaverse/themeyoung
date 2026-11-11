# Payload export and audit

The installer framework is ready, but it does not yet contain the actual theme source. Do not mark `PAYLOAD_STATUS=complete` until all required files have been exported from the customized VPS and reviewed.

## Required feature inventory

- Admin dashboard NEOBRUTALISM layout and styles
- Theme Settings page, routes, controller, model and validation
- Photo background upload/storage/display
- Video background upload/storage/display
- Audio/music upload and playback
- Floating music/volume control
- Dashboard server list
- Server console layout, terminal and charts
- Server navigation tabs
- Server power buttons
- Database migration(s), with a reviewed rollback plan
- Blade wrappers/layouts and frontend entry points
- Required public assets and CSS

## Export rules

1. Identify exact changed files from the running panel and existing backups.
2. Never include `.env`, `storage/logs`, uploaded user media, database dumps, credentials, API keys, or private customer data.
3. Do not copy generated `node_modules`, `vendor`, `public/build`, or cache directories.
4. Record every target path in `payload/manifest.txt`.
5. Keep migration files separate and review SQL effects before any migration is run.
6. Test on a clean Pterodactyl 1.15.2 / Ubuntu 24.04 instance before release.

## Important

The starter's `apply_payload` copies complete files. It must only be used for files that are intentionally owned by this theme package. For files that contain upstream Pterodactyl code, create version-specific patch files with precondition checks instead of blindly replacing the whole file.
