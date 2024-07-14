#!/bin/bash

# Function to print error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Install NodeJS and NPM
echo "Installing NodeJS and NPM..."
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash - || error_exit "Failed to add NodeSource repository"
sudo apt-get install -y nodejs || error_exit "Failed to install NodeJS"

# Print installed versions
echo "NodeJS version installed:"
node -v || error_exit "Failed to get NodeJS version"
echo "NPM version installed:"
npm -v || error_exit "Failed to get NPM version"

# Download the artifact file
echo "Downloading artifact file..."
curl -O https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz || error_exit "Failed to download artifact file"

# Unzip the downloaded file
echo "Unzipping artifact file..."
tar -xzf bootcamp-node-envvars-project-1.0.0.tgz || error_exit "Failed to unzip artifact file"

# Set environment variables
export APP_ENV=dev
export DB_USER=myuser
export DB_PWD=mysecret

# Check if environment variables are set
if [ -z "$APP_ENV" ] || [ -z "$DB_USER" ] || [ -z "$DB_PWD" ]; then
    error_exit "One or more required environment variables are not set"
fi

# Change into the unzipped package directory
cd package || error_exit "Failed to change directory to package"

# Run the NodeJS application
echo "Installing dependencies and starting the application..."
npm install || error_exit "Failed to install npm dependencies"
nohup node server.js > server.log 2>&1 &

echo "NodeJS application is running in the background."