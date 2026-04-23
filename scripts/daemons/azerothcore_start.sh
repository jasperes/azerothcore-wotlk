#!/bin/bash
set -euo pipefail

# ===== CONFIGURATION =====
WORK_DIR="/opt/azerothcore-wotlk"
MISE_CMD="/root/.local/bin/mise"
LOG_FILE="/var/log/azerothcore_start.log"
# =========================

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start logging
log "========== Starting Server Script =========="

# Check work directory
if [ ! -d "$WORK_DIR" ]; then
  log "ERROR: Work directory $WORK_DIR does not exist"
  exit 1
fi

# Check mise
if [ ! -x "$MISE_CMD" ]; then
  log "ERROR: $MISE_CMD not found in PATH"
  exit 1
fi

# Change to work directory
cd "$WORK_DIR" || {
  log "ERROR: Could not cd into $WORK_DIR"
  exit 1
}

# Start server
log "Running: $MISE_CMD run start"
if $MISE_CMD run start >> "$LOG_FILE" 2>&1; then
  log "Server Started successfully"
else
  log "ERROR: Start command failed (exit code $?)"
  exit 1
fi

log "Script finished successfully"
exit 0
