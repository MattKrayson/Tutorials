#!/bin/bash
# This script requires lm-sensors and ifstat to be installed

# Get CPU frequencies
cpu_frequencies=$(grep MHz /proc/cpuinfo | awk '{print $4}')

# Get CPU temperatures
cpu_temperatures=$(sensors | grep 'Core' | awk '{print $3}')

# Print headers for readability
echo -e "CPU MHz   |   Temp   |"
echo -e "----------|----------|"

# Combine the output and format as a table
paste <(echo "$cpu_frequencies") <(echo "$cpu_temperatures")
