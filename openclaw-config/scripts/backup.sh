#!/bin/bash
# OpenClaw Backup Script

BACKUP_DIR="$HOME/.openclaw/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup config
cp ~/.openclaw/openclaw.json "$BACKUP_DIR/"
cp ~/.openclaw/.env "$BACKUP_DIR/" 2>/dev/null || true

# Backup workspaces
tar czf "$BACKUP_DIR/workspace.tar.gz" -C ~/.openclaw workspace/ 2>/dev/null || true
tar czf "$BACKUP_DIR/workspace-local.tar.gz" -C ~/.openclaw workspace-local/ 2>/dev/null || true

# Backup sessions
cp ~/.openclaw/agents/local/sessions/sessions.json "$BACKUP_DIR/" 2>/dev/null || true

# Keep only last 10 backups
ls -t ~/.openclaw/backups/ | tail -n +11 | xargs -I {} rm -rf ~/.openclaw/backups/{}

echo "Backup completed: $BACKUP_DIR"
