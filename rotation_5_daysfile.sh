#!/bin/bash
#############################################
# 5-Day Backup Rotation + Amazon S3 Upload
# Author: Crest
#############################################

# === CONFIGURATION ===
SOURCE_DIR="/home/ubuntu/data"       # Directory to back up
BACKUP_DIR="/home/ubuntu/backups"    # Local storage for backup files
S3_BUCKET="s3://my-backup-bucket"    # AWS S3 bucket destination
RETENTION_DAYS=5                     # Rotate through 5 backup slots

# === CREATE BACKUP DIRECTORY IF NOT EXISTS ===
mkdir -p "$BACKUP_DIR"               # Create directory with parent dirs if needed

# === SET BACKUP FILE NAME BASED ON DAY OF WEEK ===
# Cycles through slots 1-5, creating a 5-day rotation
DAY_INDEX=$(( ($(date +%s) / 86400) % RETENTION_DAYS + 1 ))
# Calculate: current epoch seconds / seconds per day, mod 5, +1 = slot 1-5
BACKUP_FILE="$BACKUP_DIR/backup-$DAY_INDEX.tar.gz"
# Name file as backup-1.tar.gz through backup-5.tar.gz

echo "=============================================="
echo "Running Backup Rotation - Slot: $DAY_INDEX"   # Show which rotation slot
echo "Backup File: $BACKUP_FILE"                    # Show backup file path
echo "=============================================="

# === CREATE TAR BACKUP (OVERWRITE OLD ONE IN ROTATION) ===
# Compress and archive the contents of SOURCE_DIR into a gzip-compressed tar file at the path specified by BACKUP_FILE
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# === VERIFY TAR BACKUP CREATION ===
if [ $? -eq 0 ]; then
    echo "Backup created successfully."
else
    echo "Backup failed!"
    exit 1
fi

# === UPLOAD TO S3 (overwrites same rotation file) ===
aws s3 cp "$BACKUP_FILE" "$S3_BUCKET/backup-$DAY_INDEX.tar.gz"

if [ $? -eq 0 ]; then
    echo "Uploaded to S3 successfully."
else
    echo "S3 upload failed!"
    exit 1
fi

echo "Backup completed!"
echo "=============================================="
