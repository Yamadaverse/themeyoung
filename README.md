# NEOBRUTALISM Theme for Pterodactyl

Source package for the NEOBRUTALISM theme customization currently collected from the user's Pterodactyl Panel.

## Target

- Ubuntu 24.04
- Pterodactyl Panel 1.15.2

This repository contains theme source files only. It is **not yet a production-ready one-command installer**.

## Included features represented by these source files

- NEOBRUTALISM stylesheet and admin stylesheet
- Theme settings page/controller
- Light/dark background image settings
- Background video settings
- Global music player partial
- Frontend dashboard/server-list and console customizations
- Theme settings database migrations

## Important safety notes

1. Back up the panel files and database before applying anything.
2. Several files in this package modify stock Pterodactyl files. Do not blindly overwrite a different panel version; review and merge the changes against the exact installed source.
3. Apply the three theme migrations only after reviewing them and backing up the database. Never use `migrate:fresh`, `db:wipe`, or destructive rollback as an installation shortcut.
4. Uploaded backgrounds, videos, and music are user data. Keep `storage/app/public/theme/` intact during upgrades/uninstalls.
5. Do not add `.env`, database dumps, API keys, passwords, private uploads, `vendor/`, or `node_modules/` to this repository.
6. This project does not install, upgrade, downgrade, or modify PHP. PHP and extensions must only be inspected; any repair is manual by the server administrator.
7. Do not run experimental installation/build steps on a live production panel. Test first on a disposable copy of Ubuntu 24.04 + Pterodactyl 1.15.2.

## File groups

### Theme-owned files
- `app/Http/Controllers/Admin/ThemeSettingsController.php`
- `resources/views/admin/theme-settings/index.blade.php`
- `resources/views/layouts/partials/theme-audio-player.blade.php`
- `resources/scripts/assets/css/neobrutalism.css`
- `public/themes/pterodactyl/css/neobrutal-admin.css`
- `database/migrations/2026_11_11_*.php`

### Guarded integration / merge files
These are Pterodactyl core files with theme modifications. Review and merge, do not blindly replace:
- `resources/views/layouts/admin.blade.php`
- `resources/views/templates/wrapper.blade.php`
- `routes/admin.php`
- `resources/scripts/index.tsx`
- `resources/scripts/components/dashboard/ServerRow.tsx`
- `resources/scripts/components/server/console/ServerConsoleContainer.tsx`
- `resources/scripts/components/server/console/PowerButtons.tsx`
- `resources/scripts/routers/ServerRouter.tsx`

## Migrations

Run only after a verified backup and after confirming that the panel is the intended version:

```bash
php artisan migrate --force
```

This command applies pending migrations for the entire panel, not just this theme. Inspect `php artisan migrate:status` first and understand the migration files before proceeding. Do not automatically run migration rollbacks.

## Current package status

- Source archive integrity checked.
- PHP syntax checked for the controller and three migration files.
- This package does not include uploaded media or private server configuration.
- No installation/build was run against the live VPS.
- A safe automated installer still requires guarded patch logic, complete payload validation, backup/restore testing, and disposable-environment testing.
