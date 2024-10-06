#!/bin/bash

# Define the whitelist of process names
whitelist=(
    guake
    gnome-shell
    # Add more process names to the whitelist as needed
)

# Get the PID of the active window
active_window_pid=$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/WindowsExt --method org.gnome.Shell.Extensions.WindowsExt.FocusPID | awk -F"'" '{print $2}')

# Get the process name associated with the PID
process_name=$(ps -p "$active_window_pid" -o comm=)

# Check if the PID is successfully obtained
if [ -z "$active_window_pid" ]; then
    echo "Failed to determine the PID of the active window."
    exit 1
fi

# Check against the whitelist
if [[ "${whitelist[@]}" =~ "$process_name" ]]; then
    echo "Whitelisted process: $process_name, ignoring"
    exit 1
fi

# Force-kill the process
kill -9 "$active_window_pid"
