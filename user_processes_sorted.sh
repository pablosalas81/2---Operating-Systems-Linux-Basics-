#!/bin/bash

# Check all processes running for the current user
echo "Processes running for user: $USER"

# Ask for user input to sort by memory or CPU
read -p "Sort processes by memory (m) or CPU (c) consumption? " sort_option

# Fetch and sort the processes based on user input
if [[ "$sort_option" == "m" ]]; then
    echo "Sorting by memory consumption..."
    ps aux --sort=-%mem | grep "^$USER" | grep -v grep
elif [[ "$sort_option" == "c" ]]; then
    echo "Sorting by CPU consumption..."
    ps aux --sort=-%cpu | grep "^$USER" | grep -v grep
else
    echo "Invalid option. Please enter 'm' for memory or 'c' for CPU."
fi