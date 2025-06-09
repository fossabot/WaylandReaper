#!/bin/bash

# Define the whitelist of process names
whitelist=(
    guake
    gnome-shell
    # Add more process names to the whitelist as needed
)

# Get the PID of the active window
if ! active_window_pid=$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/WindowsExt --method org.gnome.Shell.Extensions.WindowsExt.FocusPID | awk -F"'" '{print $2}'); then
    echo "Failed to communicate with GNOME Shell"
    exit 1
fi

# Check if the PID is successfully obtained
if [ -z "$active_window_pid" ]; then
    echo "Failed to determine the PID of the active window."
    exit 1
fi

# Verify if the process exists
if ! ps -p "$active_window_pid" > /dev/null; then
    echo "Process $active_window_pid does not exist"
    exit 1
fi

# Get the process name associated with the PID
process_name=$(ps -p "$active_window_pid" -o comm=)

# Check against the whitelist
if [[ "${whitelist[@]}" =~ "$process_name" ]]; then
    echo "Whitelisted process: $process_name, ignoring"
    exit 1
fi

# Try normal termination first
kill "$active_window_pid"

# Wait a short moment to see if the process terminates
sleep 0.5

# Check if process is still running
if ps -p "$active_window_pid" > /dev/null; then
    # Force-kill the process if it's still running
    kill -9 "$active_window_pid"
fi
