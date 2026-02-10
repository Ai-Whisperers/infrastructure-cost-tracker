# The Golden Setup: Best & Cheapest OpenClaw Infrastructure

> **Last Updated:** February 2026
> **Sources:** Anthropic API docs, Hetzner Cloud pricing, Oracle Cloud docs, OpenClaw CLI help
> **Companion:** See [COSTS_AND_PRICING.md](./COSTS_AND_PRICING.md) for full pricing tables

This guide synthesizes insights from **Julian Goldie, Wes Roth, TechWithTim, David Ondrej**, plus official documentation, to provide the **optimal balance of performance and cost**.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                   YOUR PHONE                     │
│              (WhatsApp / Telegram)                │
└─────────────┬───────────────────────────────────┘
              │ Messages (via platform APIs)
              ▼
┌─────────────────────────────────────────────────┐
│               VPS / Cloud Server                 │
│  ┌─────────────────────────────────────────────┐ │
│  │            OpenClaw Gateway                 │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  │ │
│  │  │ WhatsApp │  │ Telegram │  │  Slack   │  │ │
│  │  │ Channel  │  │ Channel  │  │ Channel  │  │ │
│  │  └──────────┘  └──────────┘  └──────────┘  │ │
│  │                    │                        │ │
│  │              ┌─────▼─────┐                  │ │
│  │              │   Agent   │                  │ │
│  │              │  (Claude) │                  │ │
│  │              └─────┬─────┘                  │ │
│  │         ┌──────────┼──────────┐             │ │
│  │    ┌────▼───┐ ┌────▼───┐ ┌───▼────┐        │ │
│  │    │ Skills │ │Browser │ │ Files  │        │ │
│  │    │ (MCP)  │ │  Auto  │ │ System │        │ │
│  │    └────────┘ └────────┘ └────────┘        │ │
│  └─────────────────────────────────────────────┘ │
│              via Tailscale (encrypted)            │
└─────────────────────────────────────────────────┘
              │ API Calls
              ▼
┌─────────────────────────────────────────────────┐
│           AI Model Provider                      │
│  Anthropic / OpenRouter / OpenAI / etc.          │
└─────────────────────────────────────────────────┘
```

---

## The Three Layers: Compute, Connectivity, Intelligence

### Layer 1: Compute (The Host)

**🏆 Winner: Hetzner CX23 (€3.49/mo) OR Oracle Cloud Free Tier ($0)**

| Provider | Plan | vCPU | RAM | SSD | Price/mo | Verdict |
|----------|------|------|-----|-----|----------|---------|
| **Oracle Cloud** | ARM Ampere A1 | 4 | 24 GB | 200 GB | **FREE** | Best if available |
| **Hetzner** | CX23 | 2 | 4 GB | 40 GB | **€3.49** | Most reliable budget |
| **Hetzner** | CAX11 (ARM) | 2 | 4 GB | 40 GB | **€3.79** | ARM option |
| **DigitalOcean** | Basic | 1 | 1 GB | 25 GB | $6 | Overpriced |
| **AWS EC2** | t3.micro | 2 | 1 GB | 8 GB | ~$7.59 | Only worth it with free tier |

**Why Hetzner over AWS?**
- AWS t3.micro: 1 GB RAM, $7.59/mo → Hetzner CX23: 4 GB RAM, €3.49/mo
- Hetzner gives **4x the RAM for half the price**
- AWS free tier expires after 12 months

**Oracle Cloud Caveats:**
- Hard to provision — regions often "out of capacity"
- Accounts can be reclaimed if idle for too long
- Credit card required even for free tier

### Layer 2: Connectivity (Access)

**🏆 Winner: Tailscale Free Tier**

| Service | Free Tier | Notes |
|---------|-----------|-------|
| **Tailscale** | 100 devices, 3 users | Encrypted mesh VPN. No port forwarding needed. |
| **Cloudflare Tunnel** | Unlimited | Good for HTTP only. Requires domain. |
| **ngrok** | 1 agent, 20K req/mo | Limited. Paid starts at $8/mo. |

**Setup:**
```bash
# On VPS
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# On your phone: Install Tailscale app, login with same account
# Then bind OpenClaw:
openclaw gateway --bind tailnet
```

### Layer 3: Intelligence (Models)

**🏆 Winner: Tiered Model Routing**

The single biggest cost lever. **DO NOT use Opus for everything.**

| Task Type | Recommended Model | Input/MTok | Output/MTok | % of Tasks |
|-----------|-------------------|------------|-------------|------------|
| Reading/summarizing | Haiku 3 | $0.25 | $1.25 | ~50% |
| Content drafting | Haiku 4.5 | $1.00 | $5.00 | ~20% |
| Complex reasoning | Sonnet 4/4.5 | $3.00 | $15.00 | ~25% |
| Critical decisions | Opus 4.6 | $5.00 | $25.00 | ~5% |

**Weighted Monthly Cost (1000 conversations):**
- All Opus: ~$30/mo
- Tiered routing: ~$5-8/mo → **73-83% savings**

**Alternative: Use Kimi K2.5 via OpenRouter** (from video YY1qFOlsGxo)
- ~$0.20 input / $0.80 output per MTok
- 90%+ savings vs Opus, but lower quality for complex tasks

---

## The Complete Setup Script (Production-Grade)

```bash
#!/bin/bash
# OpenClaw Golden Setup — Hetzner CX23 + Ubuntu 24.04

# ═══════════════════════════════════════════════
# STEP 1: Security Hardening
# ═══════════════════════════════════════════════

# Create dedicated user (NEVER run as root)
sudo useradd -m -s /bin/bash openclaw-agent
sudo usermod -aG sudo openclaw-agent

# Firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 18789/tcp  # OpenClaw gateway port (if needed)
sudo ufw enable

# ═══════════════════════════════════════════════
# STEP 2: Install Dependencies
# ═══════════════════════════════════════════════

# Node.js 22 LTS
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential

# Tailscale (secure remote access)
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# ═══════════════════════════════════════════════
# STEP 3: Install OpenClaw
# ═══════════════════════════════════════════════

sudo -u openclaw-agent npm install -g openclaw

# Run the interactive wizard
sudo -u openclaw-agent openclaw onboard

# ═══════════════════════════════════════════════
# STEP 4: Run as systemd Service (auto-restart)
# ═══════════════════════════════════════════════

sudo tee /etc/systemd/system/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw AI Agent Gateway
After=network.target

[Service]
Type=simple
User=openclaw-agent
WorkingDirectory=/home/openclaw-agent
ExecStart=/usr/bin/openclaw gateway --bind tailnet
Restart=always
RestartSec=10
Environment=NODE_NO_WARNINGS=1

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw

# ═══════════════════════════════════════════════
# STEP 5: Verify
# ═══════════════════════════════════════════════

sudo systemctl status openclaw
sudo -u openclaw-agent openclaw doctor
```

---

## Total Monthly Cost Scenarios

### 🟢 "The Free Setup" — $20/mo
| Component | Cost |
|-----------|------|
| Oracle Cloud Free Tier | $0 |
| Tailscale Free | $0 |
| systemd | $0 |
| Claude Pro (OAuth) | $20/mo |
| **TOTAL** | **$20/mo** |

### 🟡 "The Budget Setup" — ~$19/mo
| Component | Cost |
|-----------|------|
| Hetzner CX23 | ~$3.85 |
| Tailscale Free | $0 |
| PM2 Free | $0 |
| Haiku 3 heavy + Sonnet light (API) | ~$15/mo |
| **TOTAL** | **~$19/mo** |

### 🔵 "The Reliable Setup" — ~$107/mo
| Component | Cost |
|-----------|------|
| Hetzner CX33 | ~$6.04 |
| Tailscale Free | $0 |
| systemd + PM2 | $0 |
| Claude Max 5x (OAuth) | $100/mo |
| Hetzner Snapshots | ~$1/mo |
| **TOTAL** | **~$107/mo** |

### 🔴 "The 90% Cut" — ~$9-14/mo
| Component | Cost |
|-----------|------|
| Hetzner CX23 | ~$3.85 |
| Kimi K2.5 via OpenRouter | ~$5-10/mo |
| Tailscale Free | $0 |
| **TOTAL** | **~$9-14/mo** |
