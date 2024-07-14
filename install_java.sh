#!/bin/bash

# Update package index
sudo apt-get update

# Install Java
sudo apt-get install -y default-jdk

# Verify Java installation
java -version

# Check if Java was installed successfully
if [ $? -eq 0 ]; then
    echo "Java was installed successfully."
else
    echo "Java installation failed."
fi