#!/bin/bash


VAULT_DIR="$HOME/secure_vault"

echo "Starting Secure Vault Setup..."

# --- 1. Create the secure_vault directory ---
if [ ! -d "$VAULT_DIR" ]; then
    mkdir -p "$VAULT_DIR"
    echo "Directory created: $VAULT_DIR"
else
    echo "Directory already exists: $VAULT_DIR"
fi

# Define file paths
KEYS_FILE="$VAULT_DIR/keys.txt"
SECRETS_FILE="$VAULT_DIR/secrets.txt"
LOGS_FILE="$VAULT_DIR/logs.txt"

# --- 2. Create files and add welcome messages using I/O redirection ---

# keys.txt
echo "--- WELCOME TO THE KEY STORAGE ---" > "$KEYS_FILE"
echo "File created: $KEYS_FILE"

# secrets.txt
echo "--- WELCOME TO THE CONFIDENTIAL DATA VAULT ---" > "$SECRETS_FILE"
echo "File created: $SECRETS_FILE"

# logs.txt
echo "--- SYSTEM LOGS START HERE ---" > "$LOGS_FILE"
echo "File created: $LOGS_FILE"

# --- 3. Print success message and list files ---
echo ""
echo "✅ Vault Setup Complete."
echo "Listing contents of $VAULT_DIR (long format):"
ls -l "$VAULT_DIR"

# Set initial permissions (for safety and to prevent errors in step 2 if run alone)
chmod 600 "$KEYS_FILE"
chmod 640 "$SECRETS_FILE"
chmod 644 "$LOGS_FILE"

