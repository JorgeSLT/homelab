#!/bin/bash

cd "$(dirname "$0")" || exit 1

source .env
export RESTIC_PASSWORD="${RESTIC_PASSWORD}"
export RCLONE_CONFIG="${USER_DIR}/.config/rclone/rclone.conf"

export RESTIC_REPOSITORY="rclone:gdrive:Homelab_Restic"
BACKUP_PATHS="${HOMELAB_DIR} ${DATA_DIR}"

EXCLUDES="--exclude ${DATA_DIR}/media"

echo "=================================================="
echo "Creating secure database dumps before backup..."
echo "=================================================="

mkdir -p "${DATA_DIR}/dumps"

# Penpot Dump
echo "-> Dumping Penpot (PostgreSQL)..."
docker exec -e PGPASSWORD="${PENPOT_DB_PASS}" penpot-postgres pg_dump -U penpot -c penpot > "${DATA_DIR}/dumps/penpot_backup.sql"

# Vaultwarden Dump
echo "-> Dumping Vaultwarden (SQLite)..."
sqlite3 "${DATA_DIR}/vaultwarden/db.sqlite3" ".backup '${DATA_DIR}/vaultwarden/db_backup.sqlite3'"

echo "=================================================="
echo "Starting backup to Google Drive..."
echo "=================================================="

restic backup $BACKUP_PATHS $EXCLUDES

echo "=================================================="
echo "Applying retention policy (cleanup)..."
echo "=================================================="

restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

echo "Backup and cleanup completed successfully!"
