#!/bin/bash

# === CONFIGURATION ===

# Discord Webhook URL
WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN"

# Email settings
TO_EMAIL="bibyvarghese2001@gmail.com"
SUBJECT="🚨 Internet Connection Alert"

# === MONITOR LOOP ===

while true; do
    # Check internet connection
    if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        MESSAGE="❌ Internet is DOWN at $TIMESTAMP Connect with Possible Wifi"

        # Send to Discord
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"$MESSAGE\"}" \
             $WEBHOOK_URL

        # Send Email
        echo "$MESSAGE" | mail -s "$SUBJECT" "$TO_EMAIL"
    fi

    # Wait 30 seconds
    sleep 30
done
