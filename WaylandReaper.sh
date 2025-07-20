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
process_name=$(ps -p "$active_window_pid" -o comm= 2>/dev/null)

# Check if process name was successfully retrieved
if [ -z "$process_name" ]; then
    echo "Failed to retrieve process name for PID $active_window_pid"
    exit 1
fi

# Check against the whitelist
for whitelisted_process in "${whitelist[@]}"; do
    if [[ "$process_name" == "$whitelisted_process" ]]; then
        echo "Whitelisted process: $process_name, ignoring"
        exit 1
    fi
done

# Try normal termination first
kill "$active_window_pid"

# Wait for process to terminate with timeout (3 seconds)
timeout=30  # 30 * 0.1 = 3 seconds
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if ! ps -p "$active_window_pid" > /dev/null 2>&1; then
        echo "Process $process_name (PID: $active_window_pid) terminated gracefully"
        exit 0
    fi
    sleep 0.1
    elapsed=$((elapsed + 1))
done

# Force-kill the process if it's still running after timeout
if ps -p "$active_window_pid" > /dev/null 2>&1; then
    echo "Force killing process $process_name (PID: $active_window_pid)"
    kill -9 "$active_window_pid"
    
    # Verify the process was killed
    sleep 0.1
    if ps -p "$active_window_pid" > /dev/null 2>&1; then
        echo "Failed to terminate process $process_name (PID: $active_window_pid)"
        exit 1
    else
        echo "Process $process_name (PID: $active_window_pid) force terminated"
    fi
fi
