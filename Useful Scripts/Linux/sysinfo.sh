#!/bin/bash

# Function to get IP address of an interface
get_ip_address() {
    ip addr show dev $1 | awk '/inet / {print $2}' | cut -d'/' -f1
}

# List network interfaces
echo "Available network interfaces:"
echo "============================"
interfaces=($(ip addr show | awk '/^[0-9]+:/ {print $2}' | cut -d':' -f1))
for iface in "${interfaces[@]}"; do
    echo "$iface"
done

# Prompt user to select an interface
read -p "Enter the name of the interface you want to select: " selected_interface

# Validate user input
if [[ -z "$selected_interface" ]]; then
    echo "No interface selected. Exiting."
    exit 1
fi

# Get CPU frequencies
cpu_frequencies=$(grep MHz /proc/cpuinfo | awk '{print $4}')

# Get CPU temperatures
cpu_temperatures=$(sensors | grep 'Core' | awk '{print $3}')

# Get network activity
network_activity=$(ifstat -i "$selected_interface" 0.1 1 | awk 'NR==3 {print $1, $2}')

# Display IP address of selected interface
selected_ip=$(get_ip_address $selected_interface)

# Print headers for readability
echo -e "\nSelected Network Interface: $selected_interface"
echo "==============================================="
echo -e "IP Address: $selected_ip\n"

# Print CPU and network activity headers
echo -e "CPU MHz   |   Temp   |   RX |  TX"
echo -e "----------|----------|-------------"

# Combine the output and format as a table
paste <(echo "$cpu_frequencies") <(echo "$cpu_temperatures") <(echo "$network_activity") | awk -F'\t' '{printf "%-8s  | %-7s  | %-5s  %-5s \n"  , $1, $2, $3, $4}'

# Run NVIDIA command (if available)
if command -v nvidia-smi &> /dev/null; then
    echo -e "\nNVIDIA GPU Information:"
    echo "======================="
    nvidia-smi
fi

echo "Done."
 