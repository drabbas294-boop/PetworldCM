#!/usr/bin/env bash
set -euo pipefail

# Simple MySQL backup script for PetworldCM
DB_NAME="${DB_NAME:-petworld}"
DB_USER="${DB_USER:-root}"
BACKUP_DIR="${BACKUP_DIR:-backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

if command -v mysqldump >/dev/null 2>&1; then
  mysqldump -u "$DB_USER" "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql"
  echo "Backup stored at $BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql"
else
  echo "mysqldump command not found; skipping backup."
fi
