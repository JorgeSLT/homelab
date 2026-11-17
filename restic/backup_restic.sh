#!/bin/bash

source .env
export RESTIC_PASSWORD="${RESTIC_PASSWORD}"

export RCLONE_CONFIG="${USER_DIR}/.config/rclone/rclone.conf"

export RESTIC_REPOSITORY="rclone:gdrive:Homelab_Restic"
BACKUP_PATHS="${HOMELAB_DIR} ${DATA_DIR}"

EXCLUDES="--exclude ${DATA_DIR}/media"

echo "=================================================="
echo "Starting backup to Google Drive..."
echo "=================================================="

restic backup $BACKUP_PATHS $EXCLUDES

echo "=================================================="
echo "Applying retention policy (cleanup)..."
echo "=================================================="

restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

echo "Backup and cleanup completed successfully!"