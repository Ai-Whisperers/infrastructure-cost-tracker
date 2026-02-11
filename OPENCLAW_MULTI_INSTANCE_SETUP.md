# OpenClaw Multi-Instance Setup Guide

> **Purpose:** Complete guide for deploying multiple OpenClaw instances across team laptops

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Communication Setup](#communication-setup)
7. [Systemd Services](#systemd-services)
8. [Specialization](#specialization)
9. [Monitoring](#monitoring)
10. [Troubleshooting](#troubleshooting)

---

## 1. Overview

### What is Multi-Instance OpenClaw?

Running multiple OpenClaw instances per user or team, each specialized for different tasks:

| Instance | Purpose | Specialization |
|----------|---------|----------------|
| `openclaw-coder` | Code generation | Git, Docker, MCP coding skills |
| `openclaw-planner` | Project management | Linear, tasks, planning |
| `openclaw-researcher` | Research & analysis | Web search, RAG, docs |
| `openclaw-writer` | Content & marketing | Writing, SEO, social |
| `openclaw-master` | Coordination | All skills, central hub |

### Why Multi-Instance?

- **Specialization:** Each instance optimized for specific task types
- **Isolation:** Issues in one instance don't affect others
- **Resource Management:** Distribute AI API calls
- **Concurrent Work:** Multiple tasks running simultaneously
- **Team Coordination:** Different team members own different instances

---

## 2. Architecture

### Hub-and-Spoke Architecture

```
                    ┌─────────────────────┐
                    │   Central Hub       │
                    │   (Cloud VPS)       │
                    │   openclaw-master   │
                    └──────────┬──────────┘
                               │
                               │ Tailscale VPN
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│   Developer 1 │    │   Developer 2 │    │   Developer 3 │
│               │    │               │    │               │
│ openclaw-coder│    │ openclaw-planner│   │ openclaw-writer│
│ openclaw-research│  │ openclaw-master  │  │ openclaw-coder │
└───────────────┘    └───────────────┘    └───────────────┘
```

### Communication Flow

```
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│ openclaw-     │  ───►   │   Central     │  ───►   │ openclaw-     │
│ coder         │  API    │   MCP Server  │  API    │ planner       │
└───────────────┘         └───────────────┘         └───────────────┘
        │                         │                         │
        │                         │                         │
        └─────────────────────────┴─────────────────────────┘
                                    │
                                    ▼
                          ┌───────────────┐
                          │  Shared       │
                          │  Knowledge    │
                          │  (Qdrant)     │
                          └───────────────┘
```

---

## 3. Prerequisites

### System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| CPU | 2 cores | 4 cores |
| RAM | 8 GB | 16 GB |
| Storage | 10 GB | 50 GB |
| OS | Ubuntu 20.04+ / macOS 12+ | Ubuntu 22.04 / macOS 14+ |

### Required Software

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y nodejs npm git curl

# Verify versions
node --version  # Should be 18+
npm --version

# macOS
brew install node git curl
```

### Account Setup

Before installation, ensure you have:

- [ ] OpenClaw account
- [ ] Anthropic API key
- [ ] OpenRouter API key
- [ ] Tailscale account
- [ ] Linear API key (optional)
- [ ] Qdrant Cloud URL and API key (optional)

---

## 4. Installation

### Step 1: Create Users

```bash
# Create system users for each OpenClaw instance
for instance in coder planner researcher writer master; do
    sudo useradd -m -s /bin/bash openclaw-$instance
    echo "Created user: openclaw-$instance"
done

# Verify users
id openclaw-coder
id openclaw-planner
id openclaw-researcher
id openclaw-writer
id openclaw-master
```

### Step 2: Create Directories

```bash
# Create directories for each instance
for instance in coder planner researcher writer master; do
    sudo mkdir -p /opt/openclaw/$instance
    sudo chown -R openclaw-$instance:openclaw-$instance /opt/openclaw/$instance
    echo "Created directory: /opt/openclaw/$instance"
done

# Create shared directory (for common skills, configs)
sudo mkdir -p /opt/openclaw/shared
sudo chown -R root:root /opt/openclaw/shared
sudo chmod -R 755 /opt/openclaw/shared
```

### Step 3: Install OpenClaw

```bash
# Install globally for all instances
sudo npm install -g openclaw

# Verify installation
openclaw --version
```

### Step 4: Install as Each User

```bash
# Install for each user (repeat for each instance)
for instance in coder planner researcher writer master; do
    sudo -u openclaw-$instance -H bash -c "
        npm install -g openclaw
        mkdir -p ~/.openclaw
    "
    echo "Installed OpenClaw for: openclaw-$instance"
done
```

---

## 5. Configuration

### Step 1: Environment Templates

Create `/opt/openclaw/shared/.env.template`:

```bash
# OpenClaw Environment Template
# Copy to /home/openclaw-{instance}/.openclaw/.env

# AI API Keys
ANTHROPIC_API_KEY=sk-ant-api03-...
OPENROUTER_API_KEY=sk-or-v1-...

# Channel Configuration
TELEGRAM_BOT_TOKEN=your-telegram-token
WHATSAPP_ENABLED=true

# MCP Server (Central Hub)
OPENCLAW_MCP_URL=http://10.0.0.1:3000
OPENCLAW_MCP_ENABLED=true

# Shared Context
OPENCLAW_SHARED_CONTEXT=true
OPENCLAW_TEAM_NETWORK=your-tailnet.ts.net

# Logging
OPENCLAW_LOG_LEVEL=info
OPENCLAW_LOG_FILE=/var/log/openclaw-{instance}.log

# Resource Limits
OPENCLAW_MAX_CONCURRENT=2
OPENCLAW_TIMEOUT_MS=300000

# Instance Type (for specialization)
OPENCLAW_INSTANCE_TYPE={coder|planner|researcher|writer|master}
OPENCLAW_SKILLS_DIR=/opt/openclaw/shared/skills
```

### Step 2: Instance-Specific Configuration

Create `/opt/openclaw/coder/openclaw.json`:

```json
{
  "name": "openclaw-coder",
  "type": "coder",
  "version": "1.0.0",
  "gateway": {
    "bind": "tailscale",
    "port": 18790,
    "password": "secure-password-here"
  },
  "skills": {
    "enabled": [
      "github",
      "coding-agent",
      "docker-workflows",
      "mcp-builder",
      "pr-reviewer"
    ],
    "disabled": [
      "obsidian",
      "blogwatcher"
    ]
  },
  "model": {
    "primary": "anthropic/claude-sonnet-4-20250514",
    "fallback": [
      "anthropic/claude-haiku-3-20250514",
      "openrouter/deepseek/deepseek-chat"
    ]
  },
  "mcp": {
    "enabled": true,
    "server": "http://10.0.0.1:3000"
  },
  "context": {
    "shared": true,
    "teamNetwork": "your-tailnet.ts.net"
  }
}
```

Create `/opt/openclaw/planner/openclaw.json`:

```json
{
  "name": "openclaw-planner",
  "type": "planner",
  "version": "1.0.0",
  "gateway": {
    "bind": "tailscale",
    "port": 18791,
    "password": "secure-password-here"
  },
  "skills": {
    "enabled": [
      "github",
      "linear",
      "project-management",
      "task-orchestrator"
    ],
    "disabled": []
  },
  "model": {
    "primary": "anthropic/claude-sonnet-4-20250514",
    "fallback": [
      "anthropic/claude-haiku-3-20250514"
    ]
  }
}
```

Create `/opt/openclaw/researcher/openclaw.json`:

```json
{
  "name": "openclaw-researcher",
  "type": "researcher",
  "version": "1.0.0",
  "gateway": {
    "bind": "tailscale",
    "port": 18792,
    "password": "secure-password-here"
  },
  "skills": {
    "enabled": [
      "web-search",
      "web-scraper",
      "knowledge-base",
      "market-research",
      "competitor-analysis"
    ],
    "disabled": []
  },
  "model": {
    "primary": "anthropic/claude-sonnet-4-20250514",
    "fallback": [
      "google/gemini-2.0-flash"
    ]
  },
  "knowledge": {
    "enabled": true,
    "vectorDb": "http://10.0.0.1:6333"
  }
}
```

### Step 3: Apply Configuration

```bash
# Apply configurations to each instance
for instance in coder planner researcher writer master; do
    # Copy configuration
    sudo cp /opt/openclaw/$instance/openclaw.json /home/openclaw-$instance/.openclaw/openclaw.json
    sudo chown openclaw-$instance:openclaw-$instance /home/openclaw-$instance/.openclaw/openclaw.json
    
    # Copy environment template and customize
    sudo cp /opt/openclaw/shared/.env.template /home/openclaw-$instance/.openclaw/.env
    sudo sed -i "s/{instance}/$instance/g" /home/openclaw-$instance/.openclaw/.env
    sudo chown openclaw-$instance:openclaw-$instance /home/openclaw-$instance/.openclaw/.env
    
    echo "Applied config to: openclaw-$instance"
done
```

---

## 6. Communication Setup

### Tailscale Network Setup

```bash
# Install Tailscale on all laptops
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale
sudo tailscale up

# Authenticate with your tailnet
# (Follow the OAuth URL shown)

# Verify connection
tailscale status

# Note the IP address (e.g., 100.x.x.x)
# This will be used for communication
```

### MCP Server Setup (Central Hub)

Create `/opt/openclaw/shared/mcp-server/docker-compose.yml`:

```yaml
version: '3.8'

services:
  mcp-server:
    image: your-org/openclaw-mcp-server:latest
    container_name: openclaw-mcp-server
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DATABASE_URL=postgresql://user:pass@postgres:5432/mcp
      - QDRANT_URL=http://qdrant:6333
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
    volumes:
      - mcp-data:/app/data
      - /opt/openclaw/shared/skills:/app/skills:ro
    depends_on:
      - qdrant
    restart: unless-stopped
    networks:
      - openclaw-network

  qdrant:
    image: qdrant/qdrant:latest
    container_name: openclaw-qdrant
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant-data:/qdrant/storage
    restart: unless-stopped
    networks:
      - openclaw-network

volumes:
  mcp-data:
  qdrant-data:

networks:
  openclaw-network:
    driver: bridge
```

### Configure OpenClaw Instances for MCP

```bash
# On each laptop, verify MCP connectivity
curl http://10.0.0.1:3000/health

# Should return: {"status":"healthy"}
```

---

## 7. Systemd Services

### Create Systemd Services

Create `/etc/systemd/system/openclaw-coder.service`:

```ini
[Unit]
Description=OpenClaw Coder Instance
Documentation=https://docs.openclaw.dev
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
User=openclaw-coder
Group=openclaw-coder
WorkingDirectory=/opt/openclaw/coder
Environment=NODE_NO_WARNINGS=1
EnvironmentFile=/home/openclaw-coder/.openclaw/.env
ExecStart=/usr/local/bin/openclaw gateway --config /home/openclaw-coder/.openclaw/openclaw.json
Restart=always
RestartSec=10
RestartPreventExitStatus=0 1

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/openclaw/coder /home/openclaw-coder/.openclaw /var/log
PrivateTmp=true

# Resource limits
MemoryMax=2G
CPUQuota=80%
TasksMax=50

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=openclaw-coder

[Install]
WantedBy=multi-user.target
```

Create `/etc/systemd/system/openclaw-planner.service`:

```ini
[Unit]
Description=OpenClaw Planner Instance
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
User=openclaw-planner
Group=openclaw-planner
WorkingDirectory=/opt/openclaw/planner
Environment=NODE_NO_WARNINGS=1
EnvironmentFile=/home/openclaw-planner/.openclaw/.env
ExecStart=/usr/local/bin/openclaw gateway --config /home/openclaw-planner/.openclaw/openclaw.json
Restart=always
RestartSec=10

# Same security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/openclaw/planner /home/openclaw-planner/.openclaw /var/log
PrivateTmp=true

MemoryMax=2G
CPUQuota=80%
TasksMax=50

StandardOutput=journal
StandardError=journal
SyslogIdentifier=openclaw-planner

[Install]
WantedBy=multi-user.target
```

Create similar services for researcher, writer, and master.

### Enable and Start Services

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable services (start on boot)
for instance in coder planner researcher writer master; do
    sudo systemctl enable openclaw-$instance
    echo "Enabled: openclaw-$instance"
done

# Start services
for instance in coder planner researcher writer master; do
    sudo systemctl start openclaw-$instance
    echo "Started: openclaw-$instance"
done

# Check status
for instance in coder planner researcher writer master; do
    sudo systemctl status openclaw-$instance --no-pager
done
```

### Service Management Commands

```bash
# Check status
sudo systemctl status openclaw-coder

# View logs
sudo journalctl -u openclaw-coder -f

# Restart service
sudo systemctl restart openclaw-coder

# Stop service
sudo systemctl stop openclaw-coder

# Disable service (prevent auto-start)
sudo systemctl disable openclaw-coder
```

---

## 8. Specialization

### Skill Configuration per Instance

#### Coder Instance

```json
{
  "skills": {
    "enabled": [
      "github",
      "coding-agent",
      "docker-workflows",
      "mcp-builder",
      "pr-reviewer",
      "python-best-practices",
      "javascript-typescript",
      "sql-optimization"
    ],
    "disabled": [
      "obsidian",
      "blogwatcher",
      "marketing-tools"
    ]
  },
  "systemPrompt": "You are a specialized AI coding assistant. You excel at writing clean, efficient code, reviewing pull requests, debugging issues, and explaining technical concepts. Focus on best practices, performance, and maintainability."
}
```

#### Planner Instance

```json
{
  "skills": {
    "enabled": [
      "linear",
      "project-management",
      "task-orchestrator",
      "github",
      "documentation"
    ],
    "disabled": [
      "marketing-tools",
      "web-scraper"
    ]
  },
  "systemPrompt": "You are a specialized AI project manager. You excel at breaking down requirements into user stories and tasks, estimating effort, tracking progress, and coordinating team work. Focus on clarity, prioritization, and efficient workflows."
}
```

#### Researcher Instance

```json
{
  "skills": {
    "enabled": [
      "web-search",
      "knowledge-base",
      "market-research",
      "competitor-analysis",
      "documentation"
    ],
    "disabled": [
      "marketing-tools",
      "coding-agent"
    ]
  },
  "systemPrompt": "You are a specialized AI research assistant. You excel at finding information, analyzing markets, comparing competitors, and synthesizing findings. Focus on accuracy, depth, and actionable insights."
}
```

#### Writer Instance

```json
{
  "skills": {
    "enabled": [
      "writing",
      "marketing-tools",
      "seo-optimizer",
      "social-media-generator",
      "documentation"
    ],
    "disabled": [
      "coding-agent",
      "web-scraper"
    ]
  },
  "systemPrompt": "You are a specialized AI content writer. You excel at creating engaging content, optimizing for SEO, crafting marketing messages, and adapting tone for different audiences. Focus on clarity, persuasion, and brand consistency."
}
```

#### Master Instance (Coordinator)

```json
{
  "skills": {
    "enabled": [
      "github",
      "coding-agent",
      "linear",
      "project-management",
      "web-search",
      "writing",
      "task-orchestrator"
    ],
    "disabled": []
  },
  "systemPrompt": "You are the central AI coordinator for the team. You have access to all skills and can delegate tasks to specialized instances. You excel at understanding the big picture, coordinating efforts, and ensuring everything works together seamlessly."
}
```

---

## 9. Monitoring

### Health Check Script

Create `/opt/openclaw/shared/scripts/health-check.sh`:

```bash
#!/bin/bash

# OpenClaw Multi-Instance Health Check

INSTANCES="coder planner researcher writer master"
HEALTHY=0
UNHEALTHY=0

echo "========================================"
echo "OpenClaw Multi-Instance Health Check"
echo "========================================"
echo ""

for instance in $INSTANCES; do
    # Check systemd service status
    status=$(systemctl is-active openclaw-$instance 2>/dev/null)
    
    # Check if port is listening
    port=$(grep -A2 '"gateway"' /opt/openclaw/$instance/openclaw.json | grep '"port"' | grep -o '[0-9]*')
    
    # Check if process is running
    pid=$(pgrep -f "openclaw.*$instance" 2>/dev/null)
    
    echo "Instance: openclaw-$instance"
    echo "  Service Status: $status"
    echo "  Port: $port"
    echo "  PID: ${pid:-none}"
    
    if [ "$status" = "active" ] && [ -n "$port" ]; then
        echo "  Health: ✅ HEALTHY"
        ((HEALTHY++))
    else
        echo "  Health: ❌ UNHEALTHY"
        ((UNHEALTHY++))
    fi
    echo ""
done

echo "========================================"
echo "Summary: $HEALTHY healthy, $UNHEALTHY unhealthy"
echo "========================================"

# Exit with error if any instances are unhealthy
if [ $UNHEALTHY -gt 0 ]; then
    exit 1
fi

exit 0
```

### Prometheus Metrics

Create `/opt/openclaw/shared/metrics/prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'openclaw-coder'
    static_configs:
      - targets: ['localhost:18790']
    metrics_path: /metrics

  - job_name: 'openclaw-planner'
    static_configs:
      - targets: ['localhost:18791']
    metrics_path: /metrics

  - job_name: 'openclaw-researcher'
    static_configs:
      - targets: ['localhost:18792']
    metrics_path: /metrics

  - job_name: 'openclaw-writer'
    static_configs:
      - targets: ['localhost:18793']
    metrics_path: /metrics

  - job_name: 'openclaw-master'
    static_configs:
      - targets: ['localhost:18799']
    metrics_path: /metrics
```

### Alerting Rules

Create `/opt/openclaw/shared/metrics/alerting.yml`:

```yaml
groups:
  - name: openclaw
    rules:
      - alert: OpenClawInstanceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "OpenClaw instance is down"
          description: "Instance {{ $labels.instance }} has been down for more than 5 minutes"

      - alert: OpenClawHighMemory
        expr: container_memory_usage_bytes / container_spec_memory_limit_bytes > 0.85
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "OpenClaw instance using high memory"
          description: "Instance {{ $labels.instance }} is using {{ $value | humanize1024 }}B of memory"

      - alert: OpenClawHighCPU
        expr: rate(container_cpu_usage_seconds_total[5m]) > 0.8
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "OpenClaw instance using high CPU"
          description: "Instance {{ $labels.instance }} is using {{ $value | humanizePercentage }} CPU"
```

---

## 10. Troubleshooting

### Common Issues

#### Issue: Service Won't Start

```bash
# Check logs
sudo journalctl -u openclaw-coder -n 100

# Check configuration
openclaw doctor --config /home/openclaw-coder/.openclaw/openclaw.json

# Check permissions
ls -la /home/openclaw-coder/.openclaw/

# Verify environment
cat /home/openclaw-coder/.openclaw/.env
```

#### Issue: Can't Connect to MCP Server

```bash
# Test connectivity
curl http://10.0.0.1:3000/health

# Check firewall
sudo ufw status

# Verify Tailscale
tailscale status

# Check DNS resolution
nslookup mcp-server.your-tailnet.ts.net
```

#### Issue: High Memory Usage

```bash
# Check memory per instance
ps aux | grep openclaw

# Check system memory
free -h

# Check OpenClaw logs for memory warnings
sudo journalctl -u openclaw-coder | grep -i memory

# Restart instance
sudo systemctl restart openclaw-coder
```

#### Issue: API Rate Limits

```bash
# Check API usage
openclaw status

# Check logs for rate limit errors
sudo journalctl -u openclaw-coder | grep -i "rate limit"

# Reduce concurrency
sudo nano /etc/systemd/system/openclaw-coder.service
# Change: CPUQuota=80% -> CPUQuota=50%
```

### Diagnostic Commands

```bash
# Full diagnostic report
/opt/openclaw/shared/scripts/health-check.sh

# Check all ports
netstat -tlnp | grep 1879

# Check all processes
ps aux | grep openclaw

# Check system resources
htop
df -h
free -h

# Check network connections
ss -tlnp | grep 1879

# Check logs for all instances
for instance in coder planner researcher writer master; do
    echo "=== openclaw-$instance ==="
    sudo journalctl -u openclaw-$instance -n 20
done
```

### Rollback Procedure

```bash
# Stop all instances
for instance in coder planner researcher writer master; do
    sudo systemctl stop openclaw-$instance
done

# Revert configuration
git checkout /opt/openclaw/coder/openclaw.json

# Restart
for instance in coder planner researcher writer master; do
    sudo systemctl start openclaw-$instance
done

# Verify
/opt/openclaw/shared/scripts/health-check.sh
```

---

## Appendix

### File Structure Summary

```
/opt/openclaw/
├── coder/
│   ├── openclaw.json
│   └── logs/
├── planner/
│   ├── openclaw.json
│   └── logs/
├── researcher/
│   ├── openclaw.json
│   └── logs/
├── writer/
│   ├── openclaw.json
│   └── logs/
├── master/
│   ├── openclaw.json
│   └── logs/
├── shared/
│   ├── .env.template
│   ├── skills/
│   ├── scripts/
│   │   ├── health-check.sh
│   │   └── backup.sh
│   ├── metrics/
│   │   ├── prometheus.yml
│   │   └── alerting.yml
│   └── mcp-server/
└── data/
```

### Port Assignments

| Instance | Port | Purpose |
|----------|------|---------|
| coder | 18790 | Code generation |
| planner | 18791 | Project management |
| researcher | 18792 | Research & analysis |
| writer | 18793 | Content & marketing |
| master | 18799 | Central coordinator |

### Quick Reference

```bash
# Install all instances
./install-all-instances.sh

# Start all instances
./start-all-instances.sh

# Stop all instances
./stop-all-instances.sh

# Restart all instances
./restart-all-instances.sh

# Check health
./health-check.sh

# View all logs
./tail-all-logs.sh

# Update all instances
./update-all-instances.sh
```

---

**Document Information**
- Created: February 2026
- Version: 1.0
- Status: Production Ready
