#!/bin/bash
# Copyright (c) 2025 @sudoeffect
# All Rights Reserved.
#
# This script is proprietary software. Unauthorized copying,
# modification, or distribution of this script, via any medium,
# is strictly prohibited without prior written consent.

clear
echo -e "\033[1;35m"
echo "┌────────────────────────────────────────────────────────────┐"
echo "│                    \033[1;36m🚀 SUBDOMAIN HARVESTER 🚀\033[1;35m                 │"
echo "├────────────────────────────────────────────────────────────┤"
echo "│    \033[1;33mWayBack Machine + WayMore Combined Power\033[1;35m               │"
echo "│    \033[1;32mMulti-Source Subdomain Discovery Tool By ./SudoEffect\033[1;35m                  │"
echo "└────────────────────────────────────────────────────────────┘"
echo -e "\033[1;31m"
echo "              ⚠️  FOR AUTHORIZED TESTING ONLY ⚠️"
echo -e "\033[0m"

DOMAIN=$1
OUTPUT_FILE="subdomains_$DOMAIN.txt"
TEMP_FILE="wayback_temp.json"
WAYMORE_FILE="waymore_$DOMAIN.txt"

# Function to check if waymore is installed
check_waymore() {
    if ! command -v waymore &> /dev/null; then
        echo "[-] Waymore not installed. Installing..."
        pip3 install waymore
    fi
}

# Step 1: Wayback Machine (existing)
echo "[*] Fetching from Wayback Machine..."
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$DOMAIN&output=json" > "$TEMP_FILE"
cat "$TEMP_FILE" | jq -r '.[1:][] | .[2]' | grep -Eo "[a-zA-Z0-9.-]+\.$DOMAIN" | sort | uniq >> "$OUTPUT_FILE"

# Step 2: Waymore (new)
echo "[*] Fetching from Waymore..."
check_waymore
waymore -i "$DOMAIN" -mode U -o "$WAYMORE_FILE" > /dev/null 2>&1

# Extract subdomains from Waymore output
if [ -f "$WAYMORE_FILE" ]; then
    grep -Eo "[a-zA-Z0-9.-]+\.$DOMAIN" "$WAYMORE_FILE" >> "$OUTPUT_FILE"
fi

# Step 3: Remove duplicates and clean up
sort -u "$OUTPUT_FILE" -o "$OUTPUT_FILE"
rm -f "$TEMP_FILE" "$WAYMORE_FILE"

# Display results
echo "[+] Combined subdomains saved to $OUTPUT_FILE"
echo "[*] Total unique subdomains found: $(wc -l < "$OUTPUT_FILE")"
