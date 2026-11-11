# NEOBRUTALISM Pterodactyl Installer

Installer framework for the custom NEOBRUTALISM theme for **Pterodactyl Panel 1.15.2 on Ubuntu 24.04**.

> This is the installer framework/starter package. The exact theme payload (Laravel/Blade files, React components, CSS, migrations, controllers, routes and assets) must be exported from the already-customized panel and added before this package can install the complete theme. The installer deliberately refuses to install when that payload is absent.

## Commands

```bash
chmod +x install.sh uninstall.sh analyze.sh
sudo ./analyze.sh
sudo ./install.sh
sudo ./uninstall.sh
```

- `analyze.sh`: read-only compatibility and prerequisite checks.
- `install.sh`: strict preflight, backup, payload validation, install and production build.
- `uninstall.sh`: restore the installer-managed backup after confirmation.

## Supported target

- Ubuntu 24.04.x
- Pterodactyl Panel 1.15.2
- Panel root defaults to `/var/www/pterodactyl` (override with `PANEL_DIR=/path`).

Unsupported OS/Panel versions stop installation.

## Safety rules

- Does not install, upgrade, downgrade, or edit PHP or PHP extensions.
- Does not run `yarn upgrade`, Composer update, or dependency upgrades.
- Never stores `.env`, credentials, database dumps, or user uploads in this repository.
- Creates a timestamped backup before applying payload.
- Refuses to overwrite a file unless it is listed in `payload/manifest.txt`.
- Database migrations are not run automatically in this starter. The completed payload must provide a reviewed migration strategy.
- Every run writes logs under `logs/`.

## Payload contract

See `docs/PAYLOAD.md`. The package is intentionally not marked feature-complete until the real modified files are exported and audited.

#Support contact
telegram https://t.me/Babehmodss
