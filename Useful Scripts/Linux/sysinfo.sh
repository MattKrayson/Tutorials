#!/bin/bash
# This script displays CPU frequencies, temperatures, and network statistics for a user-selected interface

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if ifstat is installed
if ! command_exists ifstat; then
    echo "Error: ifstat is not installed. Please install it and try again."
    exit 1
fi

# Get CPU frequencies
cpu_frequencies=$(grep MHz /proc/cpuinfo | awk '{print $4}')

# Get CPU temperatures
cpu_temperatures=$(sensors | grep 'Core' | awk '{print $3}')

# Function to list network interfaces
list_interfaces() {
    echo "Available network interfaces:"
    ip -o link show | awk -F': ' '{print $2}'
}

# Function to prompt user for interface selection
select_interface() {
    local interfaces
    interfaces=$(ip -o link show | awk -F': ' '{print $2}')
    echo "$interfaces"
    read -p "Enter the interface name (e.g., enp3s0): " interface
    echo "$interface"
}

# Prompt user to select an interface
selected_interface=$(select_interface)

# Print headers for readability
echo "CPU MHz   |   Temp   |   RX    |    TX"
echo "----------|----------|--------|--------"

# Combine the output and format as a table
paste <(echo "$cpu_frequencies") <(echo "$cpu_temperatures") <(ifstat -i $selected_interface | awk 'NR==3 {print $1, $2}') <(ifstat -i $selected_interface | awk 'NR==3 {print $3, $4}') | column -t
