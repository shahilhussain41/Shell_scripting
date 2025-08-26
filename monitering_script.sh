#!/bin/bash
# Cloud Monitor with Email Alerts

# Set your email address where alerts should be sent
EMAIL="shahilhussain41@gmail.com"

# Subject line for the email (includes hostname of the server)
SUBJECT="⚠️ Cloud Alert from $(hostname)"

# Log file to store monitoring results
LOG="/var/log/cloud_monitor.log"

# Current date & time for log entries
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Get CPU usage: take CPU stats from 'top', extract user+system usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Get Memory usage (%): used/total * 100
MEM=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')

# Get Disk usage (%): from root (/) partition
DISK=$(df / | awk 'END{print +$5}' | sed 's/%//')

# Write current status to log file
echo "[$DATE] CPU: $CPU% | MEM: $MEM% | DISK: $DISK%" >> $LOG

# ------------------ ALERT CONDITIONS ------------------

# If CPU usage > 80%, send an email alert
if [ ${CPU%.*} -gt 80 ]; then
    echo "[$DATE] ALERT: High CPU usage: $CPU%" | mail -s "$SUBJECT - CPU High" $EMAIL
fi

# If Memory usage > 80%, send an email alert
if [ $MEM -gt 80 ]; then
    echo "[$DATE] ALERT: High Memory usage: $MEM%" | mail -s "$SUBJECT - Memory High" $EMAIL
fi

# If Disk usage > 85%, send an email alert
if [ $DISK -gt 85 ]; then
    echo "[$DATE] ALERT: High Disk usage: $DISK%" | mail -s "$SUBJECT - Disk High" $EMAIL
fi
