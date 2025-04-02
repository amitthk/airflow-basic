#!/bin/bash

# Navigate to the home directory
cd "$HOME_DIR"

# Download the Oracle Instant Client
curl -O https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basic-linux.x64-23.7.0.25.01.zip

# Create the instant client directory
mkdir "$INSTANT_CLIENT_DIR"

# Unzip the downloaded file
unzip "$INSTANT_CLIENT_ZIP"

# Check GLIBC version
GLIBC_VERSION=$(ldd --version | head -n 1 | awk '{print $NF}')
echo "GLIBC version: $GLIBC_VERSION"

# Add the Instant Client directory to LD_LIBRARY_PATH and PATH
export LD_LIBRARY_PATH="$HOME_DIR/$INSTANT_CLIENT_DIR:$LD_LIBRARY_PATH"
export PATH="$HOME_DIR/$INSTANT_CLIENT_DIR:$PATH"

# Clean up the zip file (optional)
rm "$INSTANT_CLIENT_ZIP"

echo "Oracle Instant Client installed and environment variables set."
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "PATH: $PATH"

