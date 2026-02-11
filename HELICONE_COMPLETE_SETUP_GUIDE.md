# 🚀 Helicone AI Gateway - Complete Setup Guide

**For AI Whisperers Multi-Instance OpenClaw Infrastructure**

**Status:** Production-Ready Configuration  
**Date:** 2026-02-10  
**Version:** 1.0

---

## 📋 OVERVIEW

This document provides complete instructions for deploying **Helicone AI Gateway** as the centralized LLM proxy for all AI Whisperers OpenClaw instances.

### Why Helicone?
- ✅ **Performance:** Rust-based (faster than Python/LiteLLM)
- ✅ **Observability:** Built-in dashboard for cost tracking
- ✅ **Caching:** Automatic response caching (20-40% cost savings)
- ✅ **Self-hosted:** Full control, data stays in your infrastructure
- ✅ **FREE:** Open source (MIT license)

---

## 🏗️ ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────┐
│                    AI WHISPERERS INFRA                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Helicone AI Gateway                     │   │
│  │               (Docker Container)                     │   │
│  │                   Port: 8585                         │   │
│  │                                                      │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │         Configuration (config.yaml)          │    │   │
│  │  │                                              │    │   │
│  │  │  Providers:                                │    │   │
│  │  │  ├─ DeepSeek ($49.99 balance) ✅            │    │   │
│  │  │  ├─ OpenAI (add credits)                   │    │   │
│  │  │  ├─ Anthropic (add credits)                │    │   │
│  │  │  └─ Gemini (key provided)                  │    │   │
│  │  │                                              │    │   │
│  │  │  Features:                                 │    │   │
│  │  │  ├─ Caching (TTL: 1 hour)                  │    │   │
│  │  │  ├─ Rate Limiting                          │    │   │
│  │  │  ├─ Load Balancing                         │    │   │
│  │  │  └─ Cost Tracking                          │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  └────────────────────┬────────────────────────────────┘   │
│                       │                                     │
│         ┌─────────────┼─────────────┐                      │
│         │             │             │                      │
│  ┌──────┴──────┐ ┌────┴────┐ ┌─────┴──────┐               │
│  │ OpenClaw #1 │ │OpenClaw#2│ │ OpenClaw #3│              │
│  │  (Dev)      │ │ (Prod)  │ │  (Backup)  │               │
│  └─────────────┘ └─────────┘ └────────────┘               │
│                                                             │
│  Dashboard: http://localhost:8586                          │
│  API: http://localhost:8585/v1                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 PREREQUISITES

### Required Software
- **Docker** 20.10+ or **Docker Compose** 2.0+
- **Git** (for configuration management)
- **curl** (for testing)

### System Requirements
- **CPU:** 2+ cores
- **RAM:** 4GB minimum (8GB recommended)
- **Storage:** 10GB for logs and cache
- **Network:** Port 8585 (gateway), 8586 (dashboard)

---

## 🚀 INSTALLATION

### Step 1: Install Docker (if not installed)

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker compose version
```

### Step 2: Create Helicone Directory Structure

```bash
# Create directory
mkdir -p /opt/helicone
cd /opt/helicone

# Create subdirectories
mkdir -p {config,logs,cache}
```

### Step 3: Download Configuration Files

```bash
# Clone or copy configuration from repository
git clone https://github.com/IvanWeissVanDerPol/infrastructure-cost-tracker.git temp
cp temp/openclaw-config/helicone/* /opt/helicone/
rm -rf temp
```

### Step 4: Configure Environment Variables

Create `/opt/helicone/.env`:

```bash
# Helicone Gateway Environment Variables
# AI Whisperers Production Setup

# ==========================================
# API KEYS (Update these with your keys)
# ==========================================

# DeepSeek (Primary - Working with $49.99 balance)
DEEPSEEK_API_KEY=sk-d33f777e08164b13b0d25a7bf31c519b

# OpenAI (Add credits at: https://platform.openai.com/)
OPENAI_API_KEY=sk-your-openai-key-here

# Anthropic (Add credits at: https://console.anthropic.com/)
ANTHROPIC_API_KEY=sk-your-anthropic-key-here

# Gemini (Free tier available)
GOOGLE_GEMINI_API_KEY=AIzaSyCaIdRPNf3bgPyQ3FuVeWkFpn-zfEQIr-Y

# ==========================================
# GATEWAY SETTINGS
# ==========================================
GATEWAY_PORT=8585
DASHBOARD_PORT=8586
LOG_LEVEL=info
CACHE_ENABLED=true
CACHE_TTL=3600

# ==========================================
# SECURITY (Optional)
# ==========================================
# ALLOWED_IPS=127.0.0.1,192.168.1.0/24
# REQUIRE_AUTH=false
```

### Step 5: Create Configuration File

Create `/opt/helicone/config/config.yaml`:

```yaml
# Helicone AI Gateway Configuration
# AI Whisperers - Production Setup

# Server settings
server:
  port: 8585
  host: 0.0.0.0
  workers: 4

# Provider configurations
providers:
  # DeepSeek (Primary - working with $49.99 balance)
  deepseek:
    base_url: https://api.deepseek.com
    api_key: ${DEEPSEEK_API_KEY}
    default_model: deepseek-chat
    timeout: 60
    retries: 3
  
  # OpenAI (Add when you have credits)
  openai:
    base_url: https://api.openai.com
    api_key: ${OPENAI_API_KEY}
    default_model: gpt-4o
    timeout: 60
    retries: 3
  
  # Anthropic (Add when you have credits)
  anthropic:
    base_url: https://api.anthropic.com
    api_key: ${ANTHROPIC_API_KEY}
    default_model: claude-3-5-sonnet-20241022
    timeout: 60
    retries: 3
  
  # Gemini (Your key - needs verification)
  gemini:
    base_url: https://generativelanguage.googleapis.com
    api_key: ${GOOGLE_GEMINI_API_KEY}
    default_model: gemini-2.0-flash
    timeout: 60
    retries: 3

# Routing configuration
routing:
  default_provider: deepseek
  fallback_chain:
    - deepseek
    - gemini
    - openai
    - anthropic

# Caching configuration
caching:
  enabled: true
  ttl: 3600
  max_size: 10000

# Rate limiting
rate_limiting:
  enabled: true
  providers:
    deepseek:
      requests_per_minute: 60
      tokens_per_minute: 100000

# Observability
observability:
  request_logging:
    enabled: true
    log_level: info
  metrics:
    enabled: true
  dashboard:
    enabled: true
    port: 8586

# Cost tracking
cost_tracking:
  enabled: true
  pricing:
    deepseek-chat:
      input: 0.00014
      output: 0.00028
    gpt-4o:
      input: 0.0025
      output: 0.01
    claude-3-5-sonnet:
      input: 0.003
      output: 0.015

# Security
security:
  require_auth: false
  max_request_size: 10MB
  max_tokens_per_request: 8192

# Logging
logging:
  level: info
  format: json
  output: stdout
```

### Step 6: Create Docker Compose File

Create `/opt/helicone/docker-compose.yml`:

```yaml
version: '3.8'

services:
  helicone:
    image: helicone/gateway:latest
    container_name: helicone-gateway
    restart: unless-stopped
    ports:
      - "8585:8585"  # Gateway API
      - "8586:8586"  # Dashboard
    volumes:
      - ./config/config.yaml:/app/config.yaml:ro
      - ./logs:/app/logs
    environment:
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - GOOGLE_GEMINI_API_KEY=${GOOGLE_GEMINI_API_KEY}
      - HELICONE_CONFIG_PATH=/app/config.yaml
    networks:
      - helicone-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8585/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # Optional: Redis for caching (better performance)
  redis:
    image: redis:7-alpine
    container_name: helicone-redis
    restart: unless-stopped
    volumes:
      - redis-data:/data
    networks:
      - helicone-network
    command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru

networks:
  helicone-network:
    driver: bridge

volumes:
  redis-data:
```

### Step 7: Start Helicone

```bash
cd /opt/helicone

# Load environment variables
set -a
source .env
set +a

# Start services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f helicone
```

### Step 8: Verify Installation

```bash
# Test health endpoint
curl http://localhost:8585/health

# Test API with DeepSeek
curl -X POST http://localhost:8585/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DEEPSEEK_API_KEY" \
  -d '{
    "model": "deepseek-chat",
    "messages": [{"role": "user", "content": "Hello from Helicone!"}]
  }'

# Access dashboard
open http://localhost:8586
```

---

## ⚙️ CONFIGURE OPENCLAW TO USE HELICONE

### Step 1: Update OpenClaw Configuration

Edit `~/.openclaw/openclaw.json`:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/deepseek-chat",
        "api_base": "http://localhost:8585/v1",
        "fallbacks": [
          "openai/gemini-2.0-flash",
          "openai/gpt-4o",
          "openai/claude-3-5-sonnet"
        ]
      }
    }
  }
}
```

### Step 2: Update Environment Variables

Edit `~/.openclaw/.env`:

```bash
# OLD (using OpenRouter):
# OPENROUTER_API_KEY=sk-or-v1-xxx

# NEW (using Helicone):
# Point to your Helicone instance
HELIBASE_URL=http://localhost:8585/v1
HELIAPI_KEY=sk-helicone-local  # Can be any value if auth disabled
```

### Step 3: Restart OpenClaw

```bash
openclaw gateway restart

# Verify connection
openclaw status
```

### Step 4: Test Integration

```bash
# Test OpenClaw through Helicone
openclaw agent --message "Hello, confirm you're using Helicone!" --to "agent:local:main"
```

---

## 🔧 MULTI-INSTANCE SETUP

For multiple OpenClaw instances, point all to the same Helicone gateway:

### Instance 1 (Development)
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/deepseek-chat",
        "api_base": "http://helicone-server:8585/v1"
      }
    }
  }
}
```

### Instance 2 (Production)
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/deepseek-chat",
        "api_base": "http://helicone-server:8585/v1"
      }
    }
  }
}
```

### Instance 3 (Backup)
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gemini-2.0-flash",
        "api_base": "http://helicone-server:8585/v1"
      }
    }
  }
}
```

**Benefit:** Update API keys in ONE place (Helicone config), all instances automatically use new keys!

---

## 📊 MONITORING & OBSERVABILITY

### Access Dashboard
- **URL:** http://localhost:8586
- **Features:**
  - Real-time cost tracking
  - Request volume metrics
  - Token usage by provider
  - Cache hit rates
  - Error rates
  - Latency percentiles

### Key Metrics to Watch

| Metric | Target | Alert If |
|--------|--------|----------|
| Request Rate | < 60/min | > 100/min |
| Error Rate | < 1% | > 5% |
| Cache Hit Rate | > 30% | < 20% |
| Avg Latency | < 2s | > 5s |
| Daily Cost | Track | Sudden spike |

### Log Analysis

```bash
# View recent logs
docker compose logs --tail 100 helicone

# Search for errors
docker compose logs helicone | grep ERROR

# Monitor real-time
docker compose logs -f helicone
```

---

## 💰 COST OPTIMIZATION

### Caching Strategy
- **TTL:** 1 hour (configurable)
- **Expected savings:** 20-40%
- **Best for:** Repeated queries, templates

### Provider Routing
```yaml
# Route cheap requests to DeepSeek
# Route complex coding to Claude
# Route creative tasks to GPT-4o

routing:
  rules:
    - condition: "coding_task"
      provider: anthropic
    - condition: "creative_task"
      provider: openai
    - default:
      provider: deepseek  # Cheapest
```

### Budget Alerts
```yaml
cost_tracking:
  budgets:
    daily: 10.00
    monthly: 100.00
  alerts:
    - threshold: 80%
      action: notification
    - threshold: 100%
      action: throttle
```

---

## 🔒 SECURITY HARDENING

### 1. Enable Authentication

```yaml
security:
  require_auth: true
  api_keys:
    - name: openclaw-dev
      key: sk-oc-dev-xxx
      permissions: [read, write]
    - name: openclaw-prod
      key: sk-oc-prod-xxx
      permissions: [read]
```

### 2. IP Whitelisting

```yaml
security:
  allowed_ips:
    - 127.0.0.1
    - 192.168.1.100  # OpenClaw Dev
    - 192.168.1.101  # OpenClaw Prod
    - 10.0.0.0/8     # Internal network
```

### 3. Request Limits

```yaml
security:
  max_request_size: 10MB
  max_tokens_per_request: 8192
  rate_limits:
    per_ip:
      requests_per_minute: 60
      tokens_per_minute: 100000
```

### 4. SSL/TLS (Production)

```yaml
server:
  ssl:
    enabled: true
    cert_file: /path/to/cert.pem
    key_file: /path/to/key.pem
```

---

## 🔄 MAINTENANCE

### Daily Tasks
```bash
# Check status
docker compose ps

# View logs for errors
docker compose logs --tail 50 | grep ERROR

# Monitor resource usage
docker stats helicone-gateway
```

### Weekly Tasks
```bash
# Update Helicone to latest version
docker compose pull
docker compose up -d

# Review cost dashboard
# Check cache hit rates
# Analyze error patterns
```

### Monthly Tasks
```bash
# Rotate API keys
# Review access logs
# Optimize caching rules
# Update pricing configuration
```

---

## 🆘 TROUBLESHOOTING

### Issue: Gateway Won't Start
```bash
# Check logs
docker compose logs helicone

# Verify config syntax
docker run --rm -v $PWD/config:/app/config helicone/gateway:latest --validate

# Check port conflicts
sudo lsof -i :8585
```

### Issue: API Returns Errors
```bash
# Test provider directly
curl https://api.deepseek.com/models \
  -H "Authorization: Bearer $DEEPSEEK_API_KEY"

# Check Helicone logs
docker compose logs helicone | grep -i error
```

### Issue: High Latency
```bash
# Check cache hit rate
# Review dashboard metrics
# Consider adding Redis
docker compose up -d redis
```

---

## 📚 BACKUP & RECOVERY

### Backup Configuration
```bash
# Backup script
tar -czvf helicone-backup-$(date +%Y%m%d).tar.gz \
  /opt/helicone/config \
  /opt/helicone/.env

# Automated backup (cron)
0 2 * * * /opt/helicone/scripts/backup.sh
```

### Disaster Recovery
```bash
# Restore from backup
tar -xzvf helicone-backup-20260210.tar.gz -C /

# Restart services
docker compose up -d
```

---

## 🎯 NEXT STEPS

### Immediate (Today)
1. ✅ Install Docker on server
2. ✅ Deploy Helicone using this guide
3. ✅ Configure with DeepSeek API key
4. ✅ Point OpenClaw to Helicone
5. ✅ Test end-to-end

### Short-term (This Week)
1. Add OpenAI credits ($10-20)
2. Add Anthropic credits ($10-20)
3. Enable authentication
4. Configure IP whitelisting
5. Set up monitoring alerts

### Long-term (This Month)
1. Deploy Redis for caching
2. Set up SSL/TLS
3. Configure multi-region (if needed)
4. Implement advanced routing rules
5. Document team procedures

---

## 📞 SUPPORT

### Resources
- **Helicone Docs:** https://docs.helicone.ai/
- **GitHub:** https://github.com/Helicone/helicone
- **Discord:** https://discord.gg/helicone

### AI Whisperers Internal
- **Repository:** https://github.com/IvanWeissVanDerPol/infrastructure-cost-tracker
- **Config Location:** `/opt/helicone/`
- **Dashboard:** http://localhost:8586

---

## ✅ CHECKLIST

### Pre-deployment
- [ ] Docker installed
- [ ] Ports 8585, 8586 available
- [ ] DeepSeek API key validated ($49.99 balance)
- [ ] Configuration files created
- [ ] Environment variables set

### Deployment
- [ ] Helicone container running
- [ ] Health check passing
- [ ] API responding correctly
- [ ] Dashboard accessible
- [ ] Logs showing no errors

### Integration
- [ ] OpenClaw configured to use Helicone
- [ ] All instances pointing to gateway
- [ ] Test queries successful
- [ ] Cost tracking working
- [ ] Cache functioning

### Production Readiness
- [ ] Authentication enabled
- [ ] IP whitelisting configured
- [ ] SSL/TLS certificates installed
- [ ] Monitoring alerts set up
- [ ] Backup procedures tested
- [ ] Team trained on usage

---

**Last Updated:** 2026-02-10  
**Version:** 1.0  
**Status:** Production-Ready  
**Maintainer:** AI Whisperers Infrastructure Team
