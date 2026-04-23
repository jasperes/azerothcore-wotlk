#!/bin/bash
set -euo pipefail

# ===== CONFIGURATION =====
WORK_DIR="/opt/azerothcore-wotlk"
MISE_CMD="/root/.local/bin/mise"
LOG_FILE="/var/log/azerothcore_restart.log"
BACKUP_TARGET_DIR="/opt/azerothcore-wotlk/backups"
BACKUP_MAX_DAYS="3"
# =========================

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "========== Starting Server Stop & Reboot =========="

# Check work directory
if [ ! -d "$WORK_DIR" ]; then
    log "ERROR: Work directory $WORK_DIR does not exist"
    exit 1
fi

# Check mise
if [ ! -x "$MISE_CMD" ]; then
    log "ERROR: $MISE_CMD not executable or not found"
    exit 1
fi

# Change to work directory
cd "$WORK_DIR" || {
    log "ERROR: Could not cd into $WORK_DIR"
    exit 1
}

# Stop the server
log "Running: $MISE_CMD run stop"
if $MISE_CMD run stop >> "$LOG_FILE" 2>&1; then
    log "Stop command completed successfully"
else
    log "ERROR: Stop command failed (exit code $?)"
fi

# Wait a few seconds to ensure everything is flushed
sleep 10

# Run backup
log "Running: $MISE_CMD run backup"
if $MISE_CMD run backup >> "$LOG_FILE" 2>&1; then
  log "Backup command completed successfully"
else
  log "ERROR: Backup command failed (exit code $?)"
  exit 1
fi

# Clean old backups (older than 7 days)
if [ -d "$BACKUP_TARGET_DIR" ]; then
  log "Cleaning backups older than $BACKUP_MAX_DAYS days in $BACKUP_TARGET_DIR"
  find "$BACKUP_TARGET_DIR" -type f -mtime +$BACKUP_MAX_DAYS -delete -print >> "$LOG_FILE" 2>&1
  log "Cleanup finished"
else
  log "WARNING: Backup target directory $BACKUP_TARGET_DIR does not exist - skipping cleanup"
fi

# Reboot the machine
log "Rebooting system now"
/sbin/shutdown -r now >> "$LOG_FILE" 2>&1
