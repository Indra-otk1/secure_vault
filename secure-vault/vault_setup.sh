#!/bin/bash


VAULT_DIR="$HOME/secure_vault"

echo "Starting Secure Vault Setup..."

if [ ! -d "$VAULT_DIR" ]; then
    mkdir -p "$VAULT_DIR"
    echo "Directory created: $VAULT_DIR"
else
    echo "Directory already exists: $VAULT_DIR"
fi

KEYS_FILE="$VAULT_DIR/keys.txt"
SECRETS_FILE="$VAULT_DIR/secrets.txt"
LOGS_FILE="$VAULT_DIR/logs.txt"

# keys.txt
echo "--- WELCOME TO THE KEY STORAGE ---" > "$KEYS_FILE"
echo "File created: $KEYS_FILE"

# secrets.txt
echo "--- WELCOME TO THE CONFIDENTIAL DATA VAULT ---" > "$SECRETS_FILE"
echo "File created: $SECRETS_FILE"

# logs.txt
echo "--- SYSTEM LOGS START HERE ---" > "$LOGS_FILE"
echo "File created: $LOGS_FILE"

echo ""
echo " Vault Setup Complete."
echo "Listing contents of $VAULT_DIR (long format):"
ls -l "$VAULT_DIR"

chmod 600 "$KEYS_FILE"
chmod 640 "$SECRETS_FILE"
chmod 644 "$LOGS_FILE"

