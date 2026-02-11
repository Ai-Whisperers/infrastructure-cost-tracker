# OpenClaw Configuration Repository

**Organization:** AI Whisperers  
**Version:** 2026.2.9  
**Security Level:** Production-Hardened  
**Last Updated:** 2026-02-10

---

## 🚀 Quick Start

This repository contains a **production-hardened, security-audited** OpenClaw configuration. Use it to set up OpenClaw on new devices with all security best practices applied.

### Prerequisites

- Linux (Ubuntu/Debian preferred)
- Node.js 18+ 
- npm or pnpm
- Git

### Installation

```bash
# 1. Clone this repository
git clone https://github.com/your-org/openclaw-config.git
cd openclaw-config

# 2. Run the setup script
chmod +x scripts/setup-openclaw.sh
./scripts/setup-openclaw.sh

# 3. Configure your environment variables
cp .env.template ~/.openclaw/.env
nano ~/.openclaw/.env  # Add your API keys

# 4. Start OpenClaw
openclaw gateway
```

---

## 📁 Repository Structure

```
openclaw-config/
├── README.md                    # This file
├── .env.template               # Template for environment variables
├── openclaw.json               # Main configuration (sanitized)
├── cost-limits.json           # Cost control settings
├── exec-approvals.json        # Security approval rules
├── skills/                    # Custom skills (12 audited skills)
│   ├── mcp-builder/
│   ├── pr-reviewer/
│   ├── python-best-practices/
│   └── ... (9 more)
├── scripts/                   # Utility scripts
│   ├── setup-openclaw.sh     # Main setup script
│   ├── backup.sh
│   ├── monitor.sh
│   └── audit-skill.sh
├── security/                  # Security documentation
│   ├── COMPREHENSIVE_SECURITY_AUDIT.md
│   ├── CRITICAL_FIXES_REQUIRED.md
│   └── SKILL_SECURITY_GUIDE.md
└── docs/                      # Additional documentation
    └── SKILL_INSTALLATION_COMPLETE.md
```

---

## 🔒 Security Features

This configuration includes **comprehensive security hardening**:

### ✅ Implemented Security Measures

| Feature | Status | Description |
|---------|--------|-------------|
| **Exec Approvals** | ✅ Enabled | Requires approval for write/delete/exec operations |
| **Cost Limits** | ✅ Active | $10/day warning, $100/month throttle |
| **Secure Password** | ✅ 25 chars | Randomly generated, not guessable |
| **File Permissions** | ✅ 600 | All sensitive files properly restricted |
| **Network Isolation** | ✅ Loopback | Gateway only accessible locally |
| **Secrets Management** | ✅ .env file | All API keys in environment variables |
| **Resource Limits** | ✅ 2 agents | Prevents resource exhaustion |
| **Context TTL** | ✅ 24h | Automatic cleanup of old sessions |
| **No Backup Leaks** | ✅ Clean | All backup files securely deleted |
| **Skills Audited** | ✅ 28 total | All skills verified safe |

### 🛡️ Security Score: 87/100 (B+)

**Assessment:** Production-grade security with minimal attack surface.

---

## 📊 What's Included

### 12 Custom Skills (Created & Audited)

1. **mcp-builder** - Build Model Context Protocol servers
2. **pr-reviewer** - Automated PR review with security checks
3. **conventional-commits** - Standardized commit format
4. **regex-patterns** - Common regex reference
5. **backend-patterns** - Architecture best practices
6. **obsidian** - Personal Knowledge Management
7. **ml-pipeline** - ML workflow patterns
8. **docker-workflows** - Containerization guide
9. **api-testing** - API testing strategies
10. **sql-optimization** - Database query optimization
11. **python-best-practices** - Python patterns
12. **javascript-typescript** - JS/TS modern patterns

### 16 Official Skills

Including: github, 1password, coding-agent, blogwatcher, gog, and more.

### Security Controls

- **Exec Approvals:** Dangerous operations require manual approval
- **Dangerous Pattern Detection:** Blocks rm -rf and similar commands
- **Auto-Approval List:** Only safe read operations approved automatically
- **Cost Tracking:** Real-time cost monitoring with alerts

---

## ⚙️ Configuration

### Environment Variables (.env)

Copy `.env.template` to `~/.openclaw/.env` and configure:

```bash
# Required API Keys
ANTHROPIC_API_KEY=sk-ant-...
DEEPSEEK_API_KEY=sk-...
OPENROUTER_API_KEY=sk-or-v1-...

# Channel Integrations
TELEGRAM_BOT_TOKEN=...        # From @BotFather
WHATSAPP_ENABLED=true         # Scan QR code on first run

# Optional
GOOGLE_GEMINI_API_KEY=...
ELEVENLABS_API_KEY=sk-...
NOTION_API_KEY=secret-...
```

### Gateway Settings

```json
{
  "port": 18789,
  "mode": "local",
  "bind": "loopback",        // Only accessible locally
  "auth": {
    "mode": "password"       // Password in .env file
  }
}
```

### Model Configuration

- **Primary:** openrouter/deepseek/deepseek-chat
- **Fallback 1:** anthropic/claude-3-5-sonnet
- **Fallback 2:** openai/gpt-4o

---

## 🚀 Setup Script

The `setup-openclaw.sh` script automates:

1. **Dependency Installation**
   - Node.js verification
   - OpenClaw CLI installation

2. **Configuration Setup**
   - Creates ~/.openclaw directory
   - Copies hardened configuration
   - Sets secure file permissions

3. **Skill Installation**
   - Installs 12 custom skills
   - Enables 16 official skills
   - Verifies no malicious skills

4. **Security Hardening**
   - Sets exec approvals
   - Configures cost limits
   - Generates secure password
   - Locks file permissions

5. **Verification**
   - Runs security audit
   - Tests gateway startup
   - Validates configuration

### Usage

```bash
# Standard setup
./scripts/setup-openclaw.sh

# With custom workspace
./scripts/setup-openclaw.sh --workspace /path/to/workspace

# Dry run (show what would be done)
./scripts/setup-openclaw.sh --dry-run
```

---

## 🔍 Security Audit Results

**Latest Audit:** 2026-02-10

### Findings

- ✅ **0 Critical** vulnerabilities
- ⚠️ **2 Warnings** (see below)
- ℹ️ **1 Info** note

### Active Warnings

1. **Trusted Proxies Not Configured**
   - Risk: Low (loopback only)
   - Action: Only needed if using reverse proxy
   - Status: Acceptable for local-only setup

2. **Models Below GPT-5 Family**
   - Risk: Low (fallbacks only)
   - Action: Update when GPT-5 available
   - Status: Using best available (Claude 3.5 Sonnet, GPT-4o)

### Security Verification

```bash
# Run security audit
openclaw security audit

# Check for exposed secrets
grep -E "(botToken|password|apiKey)" ~/.openclaw/openclaw.json
# Should return nothing

# Verify file permissions
ls -la ~/.openclaw/.env ~/.openclaw/openclaw.json
# Should show -rw------- (600)
```

---

## 📈 Cost Controls

**Budget Limits:**
- **Daily:** $10.00 (warn)
- **Monthly:** $100.00 (throttle)
- **Per Request:** $2.00 (confirm)

**Notifications:** Telegram alerts at 50%, 75%, 90%, 100%

**Tracking:** Enabled with log rotation

---

## 🔧 Maintenance

### Daily

```bash
# Check status
openclaw status

# Review exec approvals
openclaw approvals list

# Monitor costs
tail -f ~/.openclaw/logs/costs.log
```

### Weekly

```bash
# Security audit
openclaw security audit

# Review installed skills
openclaw skills list

# Check for updates
openclaw update check
```

### Monthly

```bash
# Rotate API keys
# Review access patterns
# Update model fallbacks
# Full backup
./scripts/backup.sh
```

---

## 🆘 Troubleshooting

### Gateway Won't Start

```bash
# Check logs
openclaw logs --follow

# Verify config
openclaw doctor

# Force restart
openclaw gateway --force
```

### Skills Not Working

```bash
# Check skill status
openclaw skills check

# Re-enable skill
openclaw config set skills.entries.<skill>.enabled true

# Restart gateway
openclaw gateway restart
```

### Security Alerts

1. **Stop OpenClaw:** `openclaw gateway stop`
2. **Check logs:** Review recent activity
3. **Rotate keys:** Regenerate exposed API keys
4. **Verify config:** Ensure no secrets in openclaw.json
5. **Restart:** `openclaw gateway`

---

## 📚 Documentation

- [Comprehensive Security Audit](security/COMPREHENSIVE_SECURITY_AUDIT.md)
- [Critical Fixes Guide](security/CRITICAL_FIXES_REQUIRED.md)
- [Skill Security Guide](security/SKILL_SECURITY_GUIDE.md)
- [Setup Completion Guide](docs/SKILL_INSTALLATION_COMPLETE.md)

---

## ⚠️ Security Warnings

### DO NOT

- ❌ Install skills from ClawHub without auditing
- ❌ Use external memory systems (MemU, MemOS, etc.)
- ❌ Store secrets in openclaw.json
- ❌ Share your .env file
- ❌ Expose gateway to internet without reverse proxy

### DO

- ✅ Use only official/trusted skills
- ✅ Keep all secrets in .env file
- ✅ Regular security audits
- ✅ Rotate API keys monthly
- ✅ Monitor cost usage
- ✅ Keep OpenClaw updated

---

## 🤝 Contributing

To add new skills or configurations:

1. Audit skill for security
2. Document in SKILL.md
3. Update this README
4. Submit PR with security review

---

## 📄 License

Private configuration for AI Whisperers organization.

---

## 📞 Support

- **Issues:** Create GitHub issue
- **Security:** See [CRITICAL_FIXES_REQUIRED.md](security/CRITICAL_FIXES_REQUIRED.md)
- **Documentation:** See [docs/](docs/)

---

**Last Security Audit:** 2026-02-10  
**Security Score:** 87/100 (B+)  
**Status:** Production Ready ✅
