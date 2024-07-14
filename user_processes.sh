#!/bin/bash

# Check all processes running for the current user
echo "Processes running for user: $USER"
ps aux | grep "^$USER" | grep -v grep
