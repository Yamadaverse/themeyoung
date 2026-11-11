# Troubleshooting

- **Unsupported OS/Panel**: stop; use the exact supported Ubuntu 24.04 / Panel 1.15.2 target.
- **Yarn/Node/Composer missing**: do not let the installer install or upgrade packages blindly. Review the environment and install prerequisites manually.
- **TypeScript/build failure**: inspect the latest log, restore the timestamped backup if needed, and fix the reported source issue.
- **PHP warning**: installer only inspects PHP. An administrator must decide any PHP remediation manually.
- **Payload incomplete**: export and audit the real modified files first; do not force the status flag.
