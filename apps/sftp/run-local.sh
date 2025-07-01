#!/bin/bash
# Script to generate an SSH key pair for SFTP (no passphrase)
# Usage: ./generate_ssh_key.sh [key_name]

KEY_NAME=${1:-id_rsa}
KEY_DIR="$(dirname "$0")/ssh_keys"

mkdir -p "$KEY_DIR"
# Force overwrite existing key with -f
ssh-keygen -t rsa -b 4096 -f "$KEY_DIR/$KEY_NAME" -N "" -q <<< y

echo "SSH key pair generated at $KEY_DIR/$KEY_NAME and $KEY_DIR/$KEY_NAME.pub"

echo "Stopping any existing SFTP containers..."
docker compose down

echo "Attempting to start SFTP container..."
docker compose up -d

# Check if the demo-sftp container is running
if docker ps --filter "name=demo-sftp" --format '{{.Names}}' | grep -q '^demo-sftp$'; then
    echo "SFTP container is running."
else
    echo "Failed to start SFTP container."
    exit 1
fi