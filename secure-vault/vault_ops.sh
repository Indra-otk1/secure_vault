#!/bin/bash
# CyberSec Ops: Secure Vault Challenge - Step 3: Vault Operations

VAULT_DIR="$HOME/secure_vault"
SECRETS_FILE="$VAULT_DIR/secrets.txt"
LOGS_FILE="$VAULT_DIR/logs.txt"
KEYS_FILE="$VAULT_DIR/keys.txt" # Defined but never accessed

# --- Check if vault and files exist ---
if [ ! -d "$VAULT_DIR" ] || [ ! -f "$SECRETS_FILE" ] || [ ! -f "$LOGS_FILE" ]; then
    echo "❌ ERROR: Vault directory or required files not found."
    echo "Please run vault_setup.sh and vault_permissions.sh first."
    exit 1
fi

# --- Core Functions ---

add_secret() {
    read -r -p "Enter the new secret to add: " new_secret
    # Append the new secret to secrets.txt
    echo "SECRET: $new_secret" >> "$SECRETS_FILE"
    echo "✅ Secret added."
}

update_secret() {
    read -r -p "Enter text pattern of secret to REPLACE (e.g., SECRET: old_value): " old_pattern
    if [ -z "$old_pattern" ]; then
        echo "⚠️ Update cancelled."
        return
    fi

    read -r -p "Enter the ENTIRE new secret line (e.g., SECRET: new_value): " new_secret_line
    if [ -z "$new_secret_line" ]; then
        echo "⚠️ Update cancelled."
        return
    fi
    
    # Use grep to check for a match first
    if grep -qF "$old_pattern" "$SECRETS_FILE"; then
        # Use sed -i to replace the line in place
        sed -i "s|.*$old_pattern.*|$new_secret_line|" "$SECRETS_FILE"
        echo "✅ Secret updated."
    else
        echo "❌ No match found for '$old_pattern'. Secret not updated."
    fi
}

add_log_entry() {
    read -r -p "Enter log message: " log_message
    # Use date to generate a timestamp and append to logs.txt
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $log_message" >> "$LOGS_FILE"
    echo "✅ Log entry added."
}

access_keys() {
    # Requirement: Always print "ACCESS DENIED" (never show keys.txt)
    echo "🚫 ACCESS DENIED 🚫"
    echo "Attempt to access keys logged."
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] ACCESS DENIED: Attempted access to keys.txt." >> "$LOGS_FILE"
}

# --- Menu Loop ---
while true; do
    echo ""
    echo "--- Secure Vault Operations Menu ---"
    echo "1. Add Secret"
    echo "2. Update Secret (Requires pattern matching)"
    echo "3. Add Log Entry (Timestamped)"
    echo "4. Access Keys (ACCESS DENIED)"
    echo "5. Exit"
    echo "------------------------------------"
    read -r -p "Enter option [1-5]: " choice
    
    case "$choice" in
        1)
            add_secret
            ;;
        2)
            update_secret
            ;;
        3)
            add_log_entry
            ;;
        4)
            access_keys
            ;;
        5)
            echo "Shutting down Vault Operations. Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please enter a number from 1 to 5."
            ;;
    esac
done

