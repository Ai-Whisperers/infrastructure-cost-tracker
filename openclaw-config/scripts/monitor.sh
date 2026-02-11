#!/bin/bash
# OpenClaw Health Monitor

LOG_FILE="$HOME/.openclaw/logs/monitor.log"
mkdir -p "$HOME/.openclaw/logs"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check gateway health
if curl -s http://127.0.0.1:18789/health > /dev/null 2>&1; then
    log "✓ Gateway is healthy"
else
    log "✗ Gateway is DOWN"
fi

# Check memory usage
MEMORY=$(ps aux | grep openclaw-gateway | grep -v grep | awk '{print $6}')
if [ -n "$MEMORY" ]; then
    MEMORY_MB=$((MEMORY / 1024))
    log "Memory usage: ${MEMORY_MB}MB"
    
    if [ "$MEMORY_MB" -gt 1500 ]; then
        log "⚠ WARNING: High memory usage detected"
    fi
fi

# Check process count
PROC_COUNT=$(ps aux | grep openclaw | grep -v grep | wc -l)
log "OpenClaw processes: $PROC_COUNT"

# Check disk space
DISK_USAGE=$(df ~/.openclaw | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 80 ]; then
    log "⚠ WARNING: Disk usage at ${DISK_USAGE}%"
fi

log "---"
