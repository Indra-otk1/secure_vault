#!/bin/bash


VAULT_DIR="$HOME/secure_vault"
REPORT_FILE="$VAULT_DIR/vault_report.txt"
SECURITY_RISK_THRESHOLD="644"
RISK_DETECTED=0

if [ ! -d "$VAULT_DIR" ]; then
    echo "❌ ERROR: secure_vault directory not found at $VAULT_DIR."
    exit 1
fi

echo "Starting Vault Monitoring Scan..."

{
    echo "=== Secure Vault Monitoring Report ==="
    echo "Generated On: $(date)"
    echo "Vault Location: $VAULT_DIR"
    echo "--------------------------------------"
    printf "%-20s | %-10s | %-10s | %s\n" "FILE NAME" "SIZE (B)" "PERMS" "LAST MODIFIED"
    echo "--------------------------------------"
} > "$REPORT_FILE"

for file_path in "$VAULT_DIR"/*; do
    if [ -f "$file_path" ]; then
        file_name=$(basename "$file_path")
        
       
        file_size=$(stat -c "%s" "$file_path")
        file_perms_octal=$(stat -c "%a" "$file_path")
        file_modified=$(stat -c "%y" "$file_path" | cut -d ' ' -f 1-2)
        
        {
            printf "%-20s | %-10s | %-10s | %s\n" "$file_name" "$file_size" "$file_perms_octal" "$file_modified"
        } >> "$REPORT_FILE"

    
        if [ "$file_perms_octal" -gt "$SECURITY_RISK_THRESHOLD" ]; then
            echo "WARNING: $file_name has permissions $file_perms_octal, which is more open than $SECURITY_RISK_THRESHOLD."
            echo "⚠️ SECURITY RISK DETECTED" >> "$REPORT_FILE"
            RISK_DETECTED=1
        fi
    fi
done


{
    echo "--------------------------------------"
    if [ "$RISK_DETECTED" -eq 1 ]; then
        echo "🚨 WARNING: One or more files have overly permissive access."
    else
        echo "✅ No major security risks detected based on permission checks."
    fi
    echo "= END OF REPORT ="
} >> "$REPORT_FILE"


echo ""
echo "✅ Vault Monitoring Scan Complete."
echo "Report saved to $REPORT_FILE."
cat "$REPORT_FILE"
