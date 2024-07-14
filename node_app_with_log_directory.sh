#!/bin/bash

# Function to print error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Check if the log directory parameter is provided
if [ -z "$1" ]; then
    error_exit "Usage: $0 log_directory"
fi

LOG_DIR="$1"

# Check if the log directory exists, if not, create it
if [ ! -d "$LOG_DIR" ]; then
    echo "Creating log directory: $LOG_DIR"
    mkdir -p "$LOG_DIR" || error_exit "Failed to create log directory"
else
    echo "Log directory already exists: $LOG_DIR"
fi

# Get the absolute path of the log directory
LOG_DIR=$(realpath "$LOG_DIR")

# Set environment variables
export APP_ENV=dev
export DB_USER=myuser
export DB_PWD=mysecret
export LOG_DIR

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

# Check if environment variables are set
if [ -z "$APP_ENV" ] || [ -z "$DB_USER" ] || [ -z "$DB_PWD" ]; then
    error_exit "One or more required environment variables are not set"
fi

# Change into the unzipped package directory
cd package || error_exit "Failed to change directory to package"

# Run the NodeJS application
echo "Installing dependencies and starting the application..."
npm install || error_exit "Failed to install npm dependencies"
nohup node server.js > "$LOG_DIR/app.log" 2>&1 &

# Wait a few seconds to give the application time to start
sleep 5

# Check if the application is running
APP_PID=$(pgrep -f "node server.js")

if [ -z "$APP_PID" ]; then
    error_exit "The application failed to start."
fi

echo "The application has successfully started."
echo "Application PID: $APP_PID"

# Find the port the application is listening on
LISTENING_PORT=$(lsof -Pan -p $APP_PID -i | grep LISTEN | awk '{print $9}' | cut -d: -f2)

if [ -z "$LISTENING_PORT" ]; then
    error_exit "Failed to find the port the application is listening on."
fi

echo "The application is listening on port: $LISTENING_PORT"
