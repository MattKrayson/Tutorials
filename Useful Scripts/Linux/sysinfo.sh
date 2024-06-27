#!/bin/bash
# This script fetches CPU frequencies and temperatures

# Get CPU frequencies
cpu_frequencies=$(grep MHz /proc/cpuinfo | awk '{print $4}')

# Get CPU temperatures
cpu_temperatures=$(sensors | grep 'Core' | awk '{print $3}')

# Print headers for readability
echo "CPU MHz   |   Temp   |"
echo "----------|----------|"

# Combine the output and format as a table
paste <(echo "$cpu_frequencies") <(echo "$cpu_temperatures") | column -t
