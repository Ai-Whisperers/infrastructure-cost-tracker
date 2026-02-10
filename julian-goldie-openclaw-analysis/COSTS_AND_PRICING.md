# OpenClaw Complete Costs & Pricing Guide

> **Last Updated:** February 2026
> **Sources:** Official Anthropic pricing docs, Hetzner Cloud, claude.com/pricing

---

## 1. AI Model API Pricing (Anthropic — Per 1M Tokens)

Source: [docs.anthropic.com/en/docs/about-claude/pricing](https://docs.anthropic.com/en/docs/about-claude/pricing)

### Current Models

| Model | Input (≤200K) | Output (≤200K) | Input (>200K) | Output (>200K) | Cache Write | Cache Read |
|-------|--------------|----------------|---------------|----------------|-------------|------------|
| **Claude Opus 4.6** | $5.00 | $25.00 | $10.00 | $37.50 | $6.25 | $0.50 |
| **Claude Opus 4.5** | $5.00 | $25.00 | — | — | $6.25 | $0.50 |
| **Claude Opus 4.1** | $15.00 | $75.00 | — | — | $18.75 | $1.50 |
| **Claude Opus 4** | $15.00 | $75.00 | — | — | $18.75 | $1.50 |
| **Claude Sonnet 4.5** | $3.00 | $15.00 | $6.00 | $22.50 | $3.75 | $0.30 |
| **Claude Sonnet 4** | $3.00 | $15.00 | $6.00 | $22.50 | $3.75 | $0.30 |
| **Claude Haiku 4.5** | $1.00 | $5.00 | — | — | $1.25 | $0.10 |
| **Claude Haiku 3.5** | $0.80 | $4.00 | — | — | $1.00 | $0.08 |
| **Claude Haiku 3** | $0.25 | $1.25 | — | — | $0.30 | $0.03 |

### Batch Processing (50% discount)

| Model | Batch Input | Batch Output |
|-------|------------|--------------|
| Claude Opus 4.6 | $2.50 | $12.50 |
| Claude Sonnet 4.5 | $1.50 | $7.50 |
| Claude Haiku 4.5 | $0.50 | $2.50 |
| Claude Haiku 3 | $0.125 | $0.625 |

### Tool Pricing (Anthropic)

| Tool | Price |
|------|-------|
| Web Search | $10 per 1,000 searches |
| Web Fetch | FREE (token costs only) |
| Code Execution | 1,550 free hours/org/month, then $0.05/hr |
| Computer Use | Standard tool-use token pricing |

### Fast Mode (Opus 4.6 only — 6x premium)

| Context | Input | Output |
|---------|-------|--------|
| ≤200K tokens | $30/MTok | $150/MTok |
| >200K tokens | $60/MTok | $225/MTok |

---

## 2. Claude Subscription Plans (claude.com/pricing)

Source: [claude.com/pricing](https://claude.com/pricing)

### For OpenClaw OAuth Auth (Subscription-Based)

| Plan | Price | Key Benefit for OpenClaw |
|------|-------|--------------------------|
| **Free** | $0/mo | Very limited. Not useful for agents. |
| **Pro** | $20/mo ($17/mo annual) | Includes Claude Code + Cowork. "More usage" vs Free. Good for light agent use. |
| **Max (5x)** | $100/mo | 5x Pro usage. Priority access. Good for moderate agent use. |
| **Max (20x)** | $200/mo | 20x Pro usage. Best for heavy agent use. |
| **Team** | $25/seat/mo ($20 annual) | SSO, admin controls. Standard seat. |
| **Team Premium** | $125/seat/mo ($100 annual) | 5x more usage than standard team seats. |
| **Enterprise** | Contact Sales | Custom limits, HIPAA, audit logs. |

### API Key vs Subscription: Which is Cheaper?

**Rule of Thumb:**
- **Light Use (<$20/mo API spend):** Pro subscription is better (flat rate, unlimited-ish)
- **Moderate Use ($20-$100/mo API spend):** Max 5x ($100/mo) may break even
- **Heavy Use (>$200/mo API spend):** Raw API keys are cheaper (pay only for what you use)
- **Critical:** OpenClaw supports **OAuth auth** with subscriptions AND **API key** auth. You can mix both!

### Cost Example: Typical Agent Conversation
- Average conversation: ~3,700 tokens
- Using Opus 4.6: ~$0.004 per conversation (input) + ~$0.025 (output) = **~$0.03 per conversation**
- 1,000 conversations/month = **~$30/month on API**

---

## 3. Alternative Model Providers (for OpenClaw via OpenRouter)

Source: Various official docs

| Model | Input/MTok | Output/MTok | Speed | Best For |
|-------|-----------|-------------|-------|----------|
| **GPT-4o mini** | $0.15 | $0.60 | Fast | Cheap summarization |
| **GPT-4o** | $2.50 | $10.00 | Medium | General reasoning |
| **Gemini 2.5 Flash** | $0.075 | $0.30 | Very Fast | Cheapest option |
| **DeepSeek V3** | $0.27 | $1.10 | Medium | Good value reasoning |
| **Kimi K2.5** | ~$0.20 | ~$0.80 | Fast | Budget alternative (see video YY1qFOlsGxo) |

**OpenRouter** adds a small markup (~10-30%) over direct API pricing but provides:
- Single API key for ALL providers
- Automatic failover between providers
- Usage tracking dashboard
- Free credits for new users

---

## 4. VPS / Hosting Pricing

### Hetzner Cloud (Source: hetzner.com/cloud — Verified Feb 2026)

**Shared Cost-Optimized (Best for OpenClaw):**

| Server | vCPU | RAM | SSD | Traffic | Monthly (EUR) | Monthly (USD) |
|--------|------|-----|-----|---------|---------------|---------------|
| **CX23** (Intel/AMD) | 2 | 4 GB | 40 GB | 20 TB | €3.49 | ~$3.85 |
| **CAX11** (ARM Ampere) | 2 | 4 GB | 40 GB | 20 TB | €3.79 | ~$4.17 |
| **CX33** (Intel/AMD) | 4 | 8 GB | 80 GB | 20 TB | €5.49 | ~$6.04 |

**Shared Regular Performance:**

| Server | vCPU | RAM | SSD | Traffic | Monthly (EUR) |
|--------|------|-----|-----|---------|---------------|
| **CPX11** (AMD) | 2 | 2 GB | 40 GB | varies | €4.99 |
| **CPX21** (AMD) | 3 | 4 GB | 80 GB | varies | €9.49 |
| **CPX31** (AMD) | 4 | 8 GB | 160 GB | varies | €16.49 |

**Dedicated (Overkill for OpenClaw):**

| Server | vCPU | RAM | SSD | Monthly (EUR) |
|--------|------|-----|-----|---------------|
| **CCX13** (AMD) | 2 | 8 GB | 80 GB | €12.49 |
| **CCX23** (AMD) | 4 | 16 GB | 160 GB | €24.49 |

**🏆 BEST VALUE:** CX23 at **€3.49/mo** — 2 vCPU, 4GB RAM is more than enough for OpenClaw + Node.js.

### Oracle Cloud Free Tier

| Resource | Specs | Price |
|----------|-------|-------|
| ARM Ampere A1 | Up to 4 OCPUs, 24 GB RAM | **FREE forever** |
| AMD Compute | 1/8 OCPU, 1 GB RAM | **FREE forever** |
| Boot Volume | 200 GB total | **FREE** |
| Outbound Data | 10 TB/month | **FREE** |

**Caveat:** Hard to get — many regions are "out of capacity". Accounts can be reclaimed if idle.

### DigitalOcean

| Droplet | vCPU | RAM | SSD | Transfer | Monthly |
|---------|------|-----|-----|----------|---------|
| Basic | 1 | 512 MB | 10 GB | 500 GB | $4/mo |
| Basic | 1 | 1 GB | 25 GB | 1 TB | $6/mo |
| Basic | 2 | 2 GB | 50 GB | 2 TB | $12/mo |

### AWS EC2

| Instance | vCPU | RAM | Free Tier | Paid (us-east-1) |
|----------|------|-----|-----------|-------------------|
| t3.micro | 2 | 1 GB | 12 months free | ~$7.59/mo |
| t3.small | 2 | 2 GB | No | ~$15.18/mo |

**Verdict:** AWS is 2-4x more expensive than Hetzner for equivalent specs.

---

## 5. Connectivity Pricing

| Service | Free Tier | Paid |
|---------|-----------|------|
| **Tailscale** | 100 devices, 3 users | $6/user/mo (Starter) |
| **Cloudflare Tunnel** | Unlimited tunnels | FREE (Zero Trust plan) |
| **ngrok** | 1 agent, 20K requests/mo | $8/mo (Personal) |

**🏆 BEST VALUE:** Tailscale free tier — 100 devices is absurd for personal use.

---

## 6. Process Management

| Tool | Price | Notes |
|------|-------|-------|
| **PM2** (Node.js) | FREE (MIT license) | PM2 Plus (monitoring) from $14/mo |
| **systemd** (Linux) | FREE (built-in) | Recommended for production |
| **Docker** | FREE (Engine) | Desktop: free personal, $5/mo business |

---

## 7. Optional Services

| Service | Free Tier | Paid |
|---------|-----------|------|
| **Supabase** (Database) | 500 MB DB, 1 GB storage, 50K MAU | $25/mo (Pro) |
| **Qdrant Cloud** (Vector) | Community: free (self-hosted) | $25/mo (Managed) |
| **Redis Cloud** | 30 MB | $5/mo (250 MB) |

---

## 8. Total Monthly Cost Scenarios

### 🟢 The "Free" Setup

| Component | Cost |
|-----------|------|
| Host: Oracle Cloud Free Tier | $0 |
| Connectivity: Tailscale Free | $0 |
| Process: systemd | $0 |
| AI: Claude Pro subscription (OAuth) | $20/mo |
| **TOTAL** | **$20/mo** |

### 🟡 The "Budget" Setup

| Component | Cost |
|-----------|------|
| Host: Hetzner CX23 | €3.49/mo (~$3.85) |
| Connectivity: Tailscale Free | $0 |
| Process: PM2 Free | $0 |
| AI: Anthropic API (Haiku 3 heavy + Sonnet light) | ~$15/mo |
| **TOTAL** | **~$19/mo** |

### 🔵 The "Reliable" Setup

| Component | Cost |
|-----------|------|
| Host: Hetzner CX33 | €5.49/mo (~$6.04) |
| Connectivity: Tailscale Free | $0 |
| Process: PM2 + systemd | $0 |
| AI: Claude Max 5x (OAuth) | $100/mo |
| Backup: Hetzner Snapshots | ~$1/mo |
| **TOTAL** | **~$107/mo** |

### 🔴 The "90% Cost Cut" Setup (from video YY1qFOlsGxo)

| Component | Cost |
|-----------|------|
| Host: Hetzner CX23 | €3.49/mo |
| AI: Kimi K2.5 via OpenRouter (instead of Opus) | ~$5-10/mo |
| Connectivity: Tailscale Free | $0 |
| **TOTAL** | **~$9-14/mo** |

The "90% savings" comes from replacing Claude Opus ($15-25/MTok output) with cheaper models like Kimi K2.5 (~$0.80/MTok) for routine tasks. Quality drops, but for bulk SEO content, it's acceptable.

---

## 9. Cost Optimization Strategies

### Strategy 1: Model Routing (Most Impact)
Use cheap models for 80% of tasks, expensive models for 20%:
- **Haiku 3** ($0.25/$1.25 per MTok) for: reading emails, summarizing, formatting
- **Sonnet 4** ($3/$15 per MTok) for: coding, planning, complex analysis
- **Opus 4.6** ($5/$25 per MTok) for: critical decisions, code review
- **Savings:** 60-80% vs using Opus for everything

### Strategy 2: Prompt Caching (Technical)
Cache frequently-used system prompts:
- Cache read: $0.50/MTok (vs $5.00 normal input for Opus)
- **90% savings on repeated context**

### Strategy 3: Batch Processing
For non-urgent tasks (overnight SEO reports, bulk content):
- 50% off all token pricing
- **Savings:** 50% on batch-eligible workloads

### Strategy 4: Subscription vs API
- Track your monthly API spend for 2 weeks
- If >$100/mo → stick with API (more control)
- If <$50/mo → Pro subscription ($20) + API for overflow
- OpenClaw supports **auth profile rotation** — mix both

### Strategy 5: Cron Scheduling
Don't leave the agent "hot" 24/7 if you don't need it:
- `openclaw cron` to schedule active hours
- Prevents the agent from processing noise (spam, group chats) at 3AM
