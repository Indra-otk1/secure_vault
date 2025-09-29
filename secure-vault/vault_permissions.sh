#!/bin/bash
# CyberSec Ops: Secure Vault Challenge - Step 2: Vault Permissions

VAULT_DIR="$HOME/secure_vault"
KEYS_FILE="$VAULT_DIR/keys.txt"
SECRETS_FILE="$VAULT_DIR/secrets.txt"
LOGS_FILE="$VAULT_DIR/logs.txt"

# --- 1. Check if secure_vault exists ---
if [ ! -d "$VAULT_DIR" ]; then
    echo "❌ ERROR: secure_vault directory not found at $VAULT_DIR."
    echo "Please run vault_setup.sh first."
    exit 1
fi

echo "Starting Vault Permissions Configuration for $VAULT_DIR..."

# --- Function to handle permission updates ---
update_permission() {
    local file_path=$1
    local file_name=$(basename "$file_path")
    local default_perm=$2

    echo ""
    echo "Current permissions for $file_name:"
    ls -l "$file_path" | awk '{print $1}'

    read -r -p "Do you want to update permissions for $file_name (y/N)? " update_choice
    
    if [[ "$update_choice" =~ ^[Yy]$ ]]; then
        read -r -p "Enter new permission (e.g., 600) or press Enter for default ($default_perm): " new_perm
        
        # If user pressed Enter, use default
        if [ -z "$new_perm" ]; then
            new_perm="$default_perm"
        fi

        # Use chmod to apply the permission
        if [[ "$new_perm" =~ ^[0-7]{3,4}$ ]]; then
            chmod "$new_perm" "$file_path"
            echo "Perms set to $new_perm for $file_name."
        else
            echo "⚠️ Invalid permission format. Using default $default_perm."
            chmod "$default_perm" "$file_path"
        fi
    else
        # If not updating, or choosing no, apply default if not specified
        echo "Keeping existing permissions."
        if [ -z "$(stat -c '%a' "$file_path" 2>/dev/null)" ]; then
            chmod "$default_perm" "$file_path"
            echo "Applying default ($default_perm) just in case."
        fi
    fi
}

# --- 2. Apply updates for each file ---
# keys.txt -> 600
update_permission "$KEYS_FILE" 600

# secrets.txt -> 640
update_permission "$SECRETS_FILE" 640

# logs.txt -> 644
update_permission "$LOGS_FILE" 644

# --- 3. Display all final file permissions ---
echo ""
echo "✅ Final Vault File Permissions:"
ls -l "$VAULT_DIR"

