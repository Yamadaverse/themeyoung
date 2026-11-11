# Installation

```bash
chmod +x install.sh analyze.sh uninstall.sh
sudo ./analyze.sh
sudo ./install.sh
```

Run `analyze.sh` first and resolve all warnings manually. The installer never modifies PHP. Review the log under `logs/` after every run.

The package currently refuses installation while the theme payload is incomplete.
