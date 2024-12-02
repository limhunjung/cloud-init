#!/bin/bash

LOG_FILE="/var/log/dcv/server.log"
SEARCH_STRING_3="session - There are 0 active connections on session kadap-sess"
USER="kadap"
SCRIPT_LOG="/home/kadap/.dcv/dcv_monitor.log"

echo "Monitoring script2 started at $(date -u "+%Y-%m-%d %H:%M:%S") UTC" >> "$SCRIPT_LOG"

tail -f "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "$SEARCH_STRING_3" ; then
        echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Detected relevant log entry. deleting DCV session..." >> "$SCRIPT_LOG"


       SESSION_NAME="kadap-sess"

        if sudo dcv close-session "$SESSION_NAME" >> "$SCRIPT_LOG" 2>&1; then
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - DCV session deleted successfully for user: $USER, session name: $SESSION_NAME" >> "$SCRIPT_LOG"
        else
            echo "$(date -u "+%Y-%m-%d %H:%M:%S") UTC - Failed to delete DCV session for user: $USER" >> "$SCRIPT_LOG"
        fi
    fi
done
