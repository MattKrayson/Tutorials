
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
# Run NVIDIA command
nvidia-smi