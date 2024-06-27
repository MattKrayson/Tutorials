#!/bin/bash

# Get CPU frequencies
cpu_frequencies=$(grep MHz /proc/cpuinfo | awk '{print $4}')

# Get CPU temperatures
cpu_temperatures=$(sensors | grep 'Core' | awk '{print $3}')

# Get network activity (adjust 'eth0' to your network interface)
network_activity=$(ifstat -i eno1 0.1 1 | awk 'NR==3 {print $1, $2}')

# Print headers for readability
echo -e "CPU MHz   |   Temp   |   RX |  TX"
echo -e "----------|----------|-------------"

# Combine the output and format as a table
paste <(echo "$cpu_frequencies") <(echo "$cpu_temperatures") <(echo "$network_activity") | awk -F'\t' '{printf "%-8s  | %-7s  | %-5s  %-5s \n"  , $1, $2, $3, $4}'

# Run NVIDIA command
nvidia-smi