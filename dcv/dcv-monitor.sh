#!/bin/bash

LOG_FILE="/var/log/dcv/server.log"
SCRIPT_LOG="/home/kadap/.dcv/dcv_monitor.log"

SEARCH_STRING_1="authenticator - Received authentication request from client"
SEARCH_STRING_2="authenticator - Skipping credential provider"
SEARCH_STRING_3="session - There are 0 active connections on session kadap-sess"

USER="kadap"
SESSION_NAME="kadap-sess"

echo "Monitoring script started at $(date -u "+%Y-%m-%d %H:%M:%S") UTC" >> "$SCRIPT_LOG"

tail -f "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "$SEARCH_STRING_1" || echo "$line" | grep -q "$SEARCH_STRING_2"; then
        echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Detected relevant log entry. Creating new DCV session..." >> "$SCRIPT_LOG"
       
        if sudo dcv create-session --owner "$USER" "$SESSION_NAME" >> "$SCRIPT_LOG" 2>&1; then
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - DCV session created successfully for user: $USER, session name: $SESSION_NAME" >> "$SCRIPT_LOG"
        else
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Failed to create DCV session for user: $USER" >> "$SCRIPT_LOG"
        fi
    fi
    
    if echo "$line" | grep -q "$SEARCH_STRING_3"; then
        echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Detected relevant log entry. Deleting DCV session..." >> "$SCRIPT_LOG"
       
        if sudo dcv close-session "$SESSION_NAME" >> "$SCRIPT_LOG" 2>&1; then
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - DCV session deleted successfully for user: $USER, session name: $SESSION_NAME" >> "$SCRIPT_LOG"
        else
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Failed to delete DCV session for user: $USER" >> "$SCRIPT_LOG"
        fi
    
    fi
done
