#!/bin/bash

# === CONFIGURATION ===

# Discord Webhook URL
WEBHOOK_URL="https://discord.com/api/webhooks/1363246701074321469/xIJurCW_KN-slv9_E9v6HawTtrllu3Si3UbfBM8HTMBpmL5OR3RFQ_ICUHRKd8WdpvSi"

# Email settings
TO_EMAIL="bibyvarghese2001@gmail.com"
SUBJECT="🌐 Internet Connectivity Alert"

# Log file for down events
LOG_FILE="/home/biby/Intership/internet/connection.log"

# === MONITOR LOOP ===

DURATION=0  # Track duration of downtime
DOWN=false   # Flag to check if the internet is down

while true; do
    # Check if the internet is down by pinging Google's DNS
    if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        if [ "$DOWN" = false ]; then
            # Internet just went down
            DOWN=true
            DURATION=0
            TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
            echo "❌ Internet is DOWN at $TIMESTAMP"
            # Log the downtime
            echo "$TIMESTAMP - Internet DOWN" >> "$LOG_FILE"
        else
            # If already down, track duration
            DURATION=$((DURATION + 30))
        fi
    else
        if [ "$DOWN" = true ]; then
            # Internet just came back up
            DOWN=false
            TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
            MESSAGE="✅ Internet is BACK UP at $TIMESTAMP. Downtime duration: $DURATION seconds."

            # Send to Discord with retry logic
            for i in {1..3}; do
                curl -H "Content-Type: application/json" \
                     -X POST \
                     -d "{\"content\": \"$MESSAGE\"}" \
                     $WEBHOOK_URL && break || sleep 5
            done

            # Send Email if mailutils is installed
            if command -v mail &> /dev/null; then
                echo "$MESSAGE" | mail -s "$SUBJECT" "$TO_EMAIL"
            else
                echo "Error: mail command not found. Please install mailutils." | tee -a "$LOG_FILE"
            fi

            # Reset downtime duration after internet is back up
            DURATION=0
            # Log the up event
            echo "$TIMESTAMP - Internet BACK UP" >> "$LOG_FILE"
        fi
    fi

    # Wait 30 seconds before checking again
    sleep 30
done
