
## dotfiles

### Bash (`.bashrc`)
The [`.bashrc`](/.bashrc) shell

### Openbox (`rc.xml`)
The [`rc.xml`](/rc.xml) - openbox window manager

### Tint2 (`tint2rc`)
The [`tint2rc`](/tint2rc) file configures the Tint2 panel

### Fast File Search (`search.sh` and `ffs_install.sh`)
*   [`search.sh`](/search.sh): A script using `find` and `rofi` for quick file searching and opening with `xdg-open`.
*   [`ffs_install.sh`](/ffs_install.sh): Installs `search.sh` to `/usr/bin/ffs` and attempts to install `rofi`, `xdg-utils`, and `findutils` dependencies.

## Installation
Symlink configuration files to their respective locations (e.g., `~/.bashrc`, `~/.config/openbox/rc.xml`, `~/.config/tint2/tint2rc`).

Install the `ffs` script by running:
```bash
sudo ./ffs_install.sh
```