# WaylandReaper
## Overview

WaylandReaper is a script for GNOME desktops using Wayland. It lets users close the current window forcefully. It works with GNOME 45+.

## Purpose

WaylandReaper does for Wayland what this command does for X11: `kill -9 $(xprop -id $(xdotool getwindowfocus) | grep _NET_WM_PID | cut -d " " -f 3)`. It uses [window-calls-extended](https://github.com/hseliger/window-calls-extended) to get window info.

### Note:
Before using WaylandReaper, install the [Window Calls Extended](https://github.com/hseliger/window-calls-extended) extension.

## Dependencies

- [Window Calls Extended](https://github.com/hseliger/window-calls-extended)
- `gnome-shell`  ≥ 45

## Installation

To install the script, run this command in your terminal:

```sh
sudo sh -c "curl -o /usr/local/bin/WaylandReaper.sh https://raw.githubusercontent.com/NastyaGrifon/WaylandReaper/main/WaylandReaper.sh && chmod +x /usr/local/bin/WaylandReaper.sh"
```

## Usage
After installation, you can use WaylandReaper as a command or set up a shortcut for it.

Run the script with this command:

`WaylandReaper.sh`

This will close the current focused window.

## Disclaimer

Use this script carefully. Closing apps forcefully might lose unsaved work. The script comes as-is, with no promises. You use it at your own risk.

## Credits

WaylandReaper uses the [window-calls-extended](https://github.com/hseliger/window-calls-extended) Gnome Extension for window info.

You can help improve the script or report issues on GitHub.
