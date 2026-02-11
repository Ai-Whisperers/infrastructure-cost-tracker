# Skill Security Policy for VoltAgent/awesome-openclaw-skills

> **⚠️ CRITICAL WARNING:** This repository contains 2,999 community-contributed skills. While the maintainers filter out obvious malware, **YOU ARE RESPONSIBLE** for auditing any skill before installation.

## 🚨 Known Security Filters Applied

The maintainers have already filtered out:
- **1,180** spam/bot accounts
- **672** crypto/blockchain/finance (high risk)
- **396** malicious (identified by security audits)
- **8** non-English descriptions

**Remaining:** 2,999 skills that passed basic filters

**BUT:** Passing filters ≠ Safe to use

---

## 🔒 Mandatory Security Workflow

### NEVER Install Directly. Always Use This Process:

```bash
# 1. Choose a skill from the awesome list
#    https://github.com/VoltAgent/awesome-openclaw-skills

# 2. Use the secure installer (audits before install)
~/.openclaw/scripts/secure-install-skill.sh <skill-name> [category]

# 3. Review the audit output
# 4. Approve only if risk score is acceptable
```

---

## 🎯 Risk Categories by Skill Type

### 🟢 Generally Safer (Lower Risk)
- **Documentation skills** - Read-only access to docs
- **Static analysis tools** - Code linters, formatters
- **Local utilities** - File organizers, text processors
- **Read-only integrations** - Weather, search APIs

**Risk Score:** 0-20
**Action:** Can install with standard precautions

### 🟡 Medium Risk (Review Required)
- **GitHub/Git integrations** - Can modify repos
- **Cloud provider tools** - AWS, GCP, Azure access
- **Communication tools** - Email, Slack, Discord
- **Database tools** - SQL clients, data manipulation

**Risk Score:** 20-50
**Action:** Review SKILL.md, check permissions, enable exec approvals

### 🟠 High Risk (Manual Review Mandatory)
- **Docker/container tools** - Can access host system
- **Code execution agents** - Can run arbitrary code
- **Shell/command tools** - Direct system access
- **Multi-agent orchestrators** - Complex, hard to audit

**Risk Score:** 50-80
**Action:** Full code review, sandbox if possible, strict limits

### 🔴 Critical Risk (Avoid or Extreme Caution)
- **Crypto/trading tools** - Financial risk
- **System administration** - Can modify OS
- **Network penetration tools** - Security scanning
- **Skills with `eval()` or `exec()`** - Code injection risk

**Risk Score:** 80-100
**Action:** Only install if absolutely necessary, run in isolated VM

---

## 🛡️ Pre-Installation Checklist

For EACH skill you want to install:

- [ ] **Source verified**
  - [ ] From openclaw/skills repo (not random GitHub)
  - [ ] SKILL.md exists and is readable
  - [ ] Author has other contributions (not single-purpose account)

- [ ] **Purpose understood**
  - [ ] Read SKILL.md completely
  - [ ] Understand what it does
  - [ ] Confirm it doesn't duplicate existing skill

- [ ] **Permissions reviewed**
  - [ ] Check what binaries it requires
  - [ ] Check what files it accesses
  - [ ] Check what network hosts it contacts
  - [ ] Check what APIs it uses

- [ ] **Dependencies audited**
  - [ ] Check package.json for suspicious packages
  - [ ] Run `npm audit` if applicable
  - [ ] Look for postinstall scripts
  - [ ] Check for network dependencies

- [ ] **Tested safely**
  - [ ] Install in isolated environment first
  - [ ] Test with non-sensitive data
  - [ ] Monitor network connections
  - [ ] Check file system access

- [ ] **Monitoring enabled**
  - [ ] Exec approvals configured
  - [ ] Cost limits set
  - [ ] Logging enabled
  - [ ] Alerts configured

---

## ⚠️ Red Flags - DO NOT INSTALL

Stop immediately if you see:

1. **Requires `sudo`** - No skill should need root
2. **Pipes curl to shell** - `curl | sh` pattern
3. **Obfuscated code** - Minified/encrypted JavaScript
4. **No SKILL.md** - Can't verify what it does
5. **Requires password/token** - Asks for sensitive credentials
6. **New account** - Author created account just for this skill
7. **VirusTotal flags** - Check ClawHub for scan results
8. **Excessive permissions** - Wants access to unrelated files
9. **No source code** - Only provides compiled/minified files
10. **Typosquatting** - Name similar to popular skill (e.g., `githubb` vs `github`)

---

## 🔍 How to Audit a Skill

### Step 1: Check ClawHub

Visit: `https://www.clawhub.ai/skills/<skill-name>`

Look for:
- VirusTotal scan results
- Download count (more = more scrutiny)
- Reviews/comments
- Last updated date

### Step 2: Read SKILL.md

```bash
# Download and read
curl -sL https://raw.githubusercontent.com/openclaw/skills/main/skills/<author>/<skill>/SKILL.md
```

Check for:
- Clear description of functionality
- Reasonable requirements
- No suspicious commands
- No requests for sensitive data

### Step 3: Check Source

```bash
# Look at all files in the skill
git clone --depth 1 https://github.com/openclaw/skills.git
cd skills/skills/<author>/<skill>
ls -la

# Check for executable scripts
find . -type f \( -name "*.js" -o -name "*.sh" -o -name "*.py" \)

# Search for dangerous patterns
grep -r "eval\|exec\|child_process\|spawn\|sudo" . --include="*.js"
```

### Step 4: Run Audit Script

```bash
~/.openclaw/scripts/audit-skill.sh <skill-name>
```

---

## 🚫 Specific Skills to AVOID

Based on risk analysis, avoid these unless you fully understand them:

### Financial Risk
- Any crypto/trading bot
- Any skill requiring exchange API keys
- Any skill handling money/transactions

### System Risk
- `docker-essentials` - Can access Docker socket (root equivalent)
- `aws-infra` - Can modify cloud infrastructure
- Any skill with `privileged: true`

### Data Risk
- Skills requiring database passwords
- Skills accessing `.env` files
- Skills with broad file system access

### Network Risk
- Skills making requests to unknown hosts
- Skills acting as proxies
- Skills with webhook receivers

---

## ✅ Recommended Skills (Lower Risk)

From the VoltAgent list, these appear safer:

| Skill | Category | Risk | Why |
|-------|----------|------|-----|
| `github` | Git & GitHub | 🟡 Medium | Official, well-documented |
| `blogwatcher` | Productivity | 🟢 Low | Read-only RSS |
| `weather` | Utilities | 🟢 Low | Simple API call |
| `pdf-tools` | Documents | 🟢 Low | Local processing |
| `obsidian` | Notes | 🟢 Low | Local file access only |

---

## 🛠️ If You Must Install High-Risk Skills

### Create Isolated Environment

```bash
# Option 1: Docker Sandbox
docker run -it --rm \
  --name openclaw-sandbox \
  -v ~/.openclaw/workspace:/workspace \
  --security-opt no-new-privileges:true \
  --cap-drop ALL \
  node:20-alpine

# Option 2: VM
# Run OpenClaw in a VM with no sensitive data

# Option 3: Dedicated User
sudo useradd -m openclaw-isolated
sudo su - openclaw-isolated
# Install skills here only
```

### Set Strict Limits

```json
{
  "skills": {
    "high-risk-skill": {
      "enabled": true,
      "maxCostPerDay": 5.00,
      "maxCommandsPerHour": 10,
      "requireConfirmation": true,
      "blockedPaths": ["~/.ssh", "~/.openclaw/.env", "/etc"],
      "allowedHosts": ["api.specific-service.com"]
    }
  }
}
```

---

## 📊 Your Current Security Posture

### ✅ Already Implemented
- [x] Exec approvals configured
- [x] API keys in .env (mode 600)
- [x] Secure gateway password
- [x] Cost limits set
- [x] Session isolation enabled
- [x] Resource limits configured

### 🔄 Ongoing
- [ ] Monitor skill activity
- [ ] Review logs regularly
- [ ] Update skills
- [ ] Audit new skills before install

---

## 🆘 If You Install a Malicious Skill

### Immediate Actions

```bash
# 1. Stop OpenClaw immediately
pkill -f openclaw

# 2. Remove the skill
rm -rf ~/.openclaw/skills/<skill-name>

# 3. Check for unauthorized changes
git -C ~/.openclaw diff

# 4. Check running processes
ps aux | grep -E "(openclaw|node|python)" | grep -v grep

# 5. Check network connections
ss -tuln | grep ESTABLISHED

# 6. Rotate API keys
# - Generate new Anthropic key
# - Generate new OpenRouter key
# - Update ~/.openclaw/.env

# 7. Review logs
tail -100 ~/.openclaw/logs/*.log | grep -i error

# 8. Restart with monitoring
openclaw gateway --verbose 2>&1 | tee /tmp/openclaw-recovery.log
```

---

## 📚 Resources

- **ClawHub:** https://www.clawhub.ai/
- **VirusTotal:** https://www.virustotal.com/
- **OpenClaw Security Docs:** https://docs.openclaw.ai/security
- **npm Security:** https://docs.npmjs.com/security
- **OWASP:** https://owasp.org/

---

## ✋ Final Warning

> **YOU are responsible for what you install.**
> 
> The awesome-openclaw-skills list is a curated collection, not a guarantee of safety. Every skill runs with the same permissions as your user account. A malicious skill can:
> - Steal all your API keys
> - Delete your files
> - Install persistent malware
> - Impersonate you to contacts
> - Rack up thousands in API costs

**When in doubt, DON'T install.**

**If you must install, audit first.**

**Always monitor after installation.**

---

**Last Updated:** February 10, 2026  
**Applies to:** VoltAgent/awesome-openclaw-skills repository  
**Maintainer:** ai-whisperers security policy
