#!/bin/bash
# Load secret variables from the local .env (located 1 directory above)
source "$(dirname "${BASH_SOURCE[0]}")/../.env"

DATE=$(date +"%Y-%m-%d_%H-%M")
CONFIG="${USER_DIR}/.config/rclone/rclone.conf"
MINECRAFT_DIR="${DATA_DIR}/minecraft"
BACKUP_NAME="world_${DATE}.tar.gz"

echo "Compressing the world..."
tar -czf "/tmp/${BACKUP_NAME}" -C "${MINECRAFT_DIR}" world

echo "Uploading to Google Drive..."
rclone copy "/tmp/${BACKUP_NAME}" gdrive:Minecraft_Backups/ --config "${CONFIG}"
rm "/tmp/${BACKUP_NAME}"

echo "Cleaning up old backups (keeping the latest 5)..."
rclone lsf gdrive:Minecraft_Backups/ --config "${CONFIG}" | sort | head -n -5 | while read FILE; do
    if [ -n "$FILE" ]; then
        rclone deletefile "gdrive:Minecraft_Backups/${FILE}" --config "${CONFIG}" --drive-use-trash=false
        echo "Permanently deleted from Google Drive: ${FILE}"
    fi
done
echo "Backup completed successfully!"