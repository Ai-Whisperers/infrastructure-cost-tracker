# Team Onboarding Process

> **Purpose:** Complete guide for onboarding new team members to the AI-first startup infrastructure

## Table of Contents

1. [Pre-Onboarding](#pre-onboarding)
2. [Day 1: Hardware & Access](#day-1-hardware--access)
3. [Day 2: Development Environment](#day-2-development-environment)
4. [Day 3: AI Tools Setup](#day-3-ai-tools-setup)
5. [Day 4: Workflow Training](#day-4-workflow-training)
6. [Day 5: First Project](#day-5-first-project)
7. [Ongoing Training](#ongoing-training)
8. [Troubleshooting](#troubleshooting)

---

## 1. Pre-Onboarding

### Manager Checklist (Before Day 1)

- [ ] Order laptop (specs per guide)
- [ ] Create email account
- [ ] Create GitHub organization invite
- [ ] Create Linear workspace invite
- [ ] Create Tailscale invite
- [ ] Prepare welcome package
- [ ] Schedule onboarding meetings
- [ ] Assign onboarding buddy

### New Team Member Preparation

```
📦 Welcome Package to Ship:
├── Laptop (configured if possible)
├── Company sticker pack
├── Welcome letter with login credentials
├── Quick start guide
├── Contact list (who to ask for what)
└── Schedule for first week
```

### Credentials to Prepare

| Account | Access Level | Notes |
|---------|--------------|-------|
| **Email** | Standard | Company domain |
| **GitHub** | Team member | Repository access |
| **Linear** | Team member | Project access |
| **Tailscale** | Standard | Device access |
| **1Password** | Standard | Shared vaults |
| **Slack/Discord** | Standard | Channel access |

---

## 2. Day 1: Hardware & Access

### Morning: Hardware Setup

#### Laptop Unboxing & Initial Setup

```bash
#!/bin/bash
# 01-initial-setup.sh

echo "========================================"
echo "Initial Laptop Setup - AI Startup"
echo "========================================"

# 1. System Updates
echo "Running system updates..."
sudo apt update && sudo apt upgrade -y  # Ubuntu
# or: Software Update (macOS)

# 2. Install Homebrew (macOS) or base tools (Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    sudo apt install -y curl git vim htop unzip
fi

# 3. Configure Git
echo "Configuring Git..."
git config --global user.name "Your Name"
git config --global user.email "your@company.com"
git config --global init.defaultBranch main

# 4. Generate SSH Key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "your@company.com"

# 5. Display SSH key for GitHub
echo ""
echo "========================================"
echo "Add this SSH key to GitHub:"
echo "========================================"
cat ~/.ssh/id_ed25519.pub
echo ""
```

#### Verify Hardware Requirements

| Component | Minimum | Your Laptop | Status |
|-----------|---------|-------------|--------|
| **CPU** | 2 cores | | ☐ |
| **RAM** | 16 GB | | ☐ |
| **Storage** | 50 GB free | | ☐ |
| **Battery** | Working | | ☐ |

### Afternoon: Account Access

#### Access Checklist

```markdown
# Day 1 Access Checklist - [Name]

## Email Setup
- [ ] Login to company email
- [ ] Configure email client
- [ ] Set up signatures
- [ ] Join Slack/Discord

## GitHub Setup
- [ ] Accept organization invite
- [ ] Configure SSH key
- [ ] Clone coordinating repo
- [ ] Verify repository access

## Project Management
- [ ] Login to Linear
- [ ] Explore workspace
- [ ] Join relevant projects

## Communication
- [ ] Login to Tailscale
- [ ] Connect to network
- [ ] Verify connectivity

## Security
- [ ] Enable 2FA on all accounts
- [ ] Login to 1Password
- [ ] Review security policy
```

#### Test Connectivity

```bash
# Verify all connections
echo "Testing connectivity..."

# GitHub
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."

# Tailscale
tailscale status
# Expected: Shows connected devices

# Internal services
curl -s https://api.company.com/health
# Expected: {"status":"healthy"}
```

---

## 3. Day 2: Development Environment

### Morning: Core Tools Installation

```bash
#!/bin/bash
# 02-install-development-tools.sh

echo "========================================"
echo "Development Environment Setup"
echo "========================================"

# 1. Install Node.js 22 LTS
echo "Installing Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 3. Install GitHub CLI
echo "Installing GitHub CLI..."
curl -fsSL https://cli.github.com/packages/第三版/install.sh | sudo bash

# 4. Install VS Code
echo "Installing VS Code..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install --cask visual-studio-code
else
    sudo apt install -y software-properties-common apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install -y code
fi

# 5. Install Python & Tools
echo "Installing Python tools..."
sudo apt install -y python3 python3-pip python3-venv
pip3 install --user pipx
pipx install black isort flake8 mypy

echo ""
echo "========================================"
echo "Development tools installed!"
echo "========================================"
```

### Afternoon: IDE Configuration

#### VS Code Extensions

```json
{
  "recommendations": [
    // AI & Coding
    "anthropic-ai.claude-code-editor",
    "ms-vscode.vscode-typescript-next",
    "esbenp.prettier-标准",
    
    // Git
    "eamodio.gitlens",
    "github.vscode-pull-request-github",
    
    // Docker & DevOps
    "ms-azuretools.vscode-docker",
    "ms-vscode-remote.remote-containers",
    
    // Productivity
    "streetsidesoftware.code-spell-checker",
    "gruntfuggly.todo-tree",
    "shd101wyy.markdown-preview-enhanced"
  ]
}
```

#### Cursor Configuration

```json
{
  "cursor": {
    "enabled": true,
    "model": "claude-sonnet-4-20250514",
    "context": {
      "enabled": true,
      "includeGit": true,
      "includeTests": true,
      "includeDocumentation": true
    },
    "autocomplete": {
      "enabled": true,
      "suggestOnDemand": false
    }
  },
  "workbench": {
    "colorTheme": "GitHub Dark",
    "fontSize": 14,
    "fontFamily": "'JetBrains Mono', monospace"
  },
  "editor": {
    "formatOnSave": true,
    "tabSize": 2,
    "wordWrap": "on"
  }
}
```

### Verify Development Environment

```bash
# Run verification script
./scripts/verify-environment.sh

# Expected output:
# ✓ Node.js v22.10.0
# ✓ Docker v24.0.7
# ✓ GitHub CLI gh version 2.45.0
# ✓ Python 3.12.0
# ✓ VS Code installed
# ✓ Cursor installed
```

---

## 4. Day 3: AI Tools Setup

### Morning: OpenClaw Installation

```bash
#!/bin/bash
# 03-install-openclaw.sh

echo "========================================"
echo "OpenClaw Installation"
echo "========================================"

# 1. Install OpenClaw CLI
echo "Installing OpenClaw..."
npm install -g openclaw

# 2. Verify installation
openclaw --version

# 3. Configure OpenClaw
echo "Configuring OpenClaw..."
mkdir -p ~/.openclaw

# Create configuration
cat > ~/.openclaw/openclaw.json << 'EOF'
{
  "name": "openclaw-[USERNAME]",
  "version": "1.0.0",
  "gateway": {
    "bind": "tailscale",
    "port": 18789
  },
  "skills": {
    "enabled": [
      "github",
      "coding-agent",
      "docker-workflows"
    ],
    "disabled": []
  },
  "model": {
    "primary": "anthropic/claude-sonnet-4-20250514",
    "fallback": [
      "anthropic/claude-haiku-3-20250514",
      "openrouter/deepseek/deepseek-chat"
    ]
  }
}
EOF

# 4. Configure environment
cat > ~/.openclaw/.env << 'EOF'
ANTHROPIC_API_KEY=sk-ant-api03-...
OPENROUTER_API_KEY=sk-or-v1-...
TELEGRAM_BOT_TOKEN=
WHATSAPP_ENABLED=false
EOF

echo "OpenClaw installed!"
echo "Run: openclaw doctor"
```

### Afternoon: AI Tools Training

#### Tutorial: Using Cursor for AI Coding

```markdown
# Cursor AI Coding Tutorial

## Getting Started

1. Open Cursor (not VS Code)
2. Connect to your project: `Cmd+O`
3. Start chatting: `Cmd+L`

## Key Commands

| Command | Action |
|---------|--------|
| `Cmd+K` | Generate code |
| `Cmd+L` | Chat about code |
| `Cmd+I` | Generate file |
| `Cmd+Enter` | Accept suggestion |

## Best Practices

1. **Be Specific**
   ```
   ❌ "Make this work"
   ✅ "Add user authentication with JWT tokens"
   ```

2. **Provide Context**
   ```
   ❌ "Write a function"
   ✅ "Write a function to validate email addresses.
        Use regex pattern from RFC 5322.
        Return boolean."
   ```

3. **Iterate**
   ```
   1. Generate initial code
   2. Review and test
   3. Ask for improvements
   4. Repeat
   ```

## Practice Exercise

Complete the coding challenge in `/training/coding-challenge/`
```

#### Tutorial: OpenClaw for Project Management

```markdown
# OpenClaw Project Management Tutorial

## Accessing OpenClaw

1. Start OpenClaw: `openclaw gateway`
2. Access dashboard: http://localhost:18789
3. Connect via Terminal: `openclaw chat`

## Commands

| Command | Description |
|---------|-------------|
| `openclaw task create "description"` | Create new task |
| `openclaw status` | Check task status |
| `openclaw sync linear` | Sync with Linear |
| `openclaw report daily` | Generate daily report |

## Practice

1. Create a new task in Linear
2. Ask OpenClaw to generate user stories
3. Sync changes back to repository
```

---

## 5. Day 4: Workflow Training

### Morning: Coordinating Repo Walkthrough

```markdown
# Coordinating Repository Walkthrough

## Structure Overview

```
ai-startup-coordination/
├── 📄 README.md              # Start here!
├── 📄 BUSINESS_PLAN.md       # Company strategy
├── 📄 ORCHESTRATION.md       # How we work
├── 📄 ROADMAP.md             # Company roadmap
│
├── 📁 projects/              # All projects live here
│   ├── [project-name]/
│   │   ├── README.md
│   │   ├── user-stories/
│   │   ├── specs/
│   │   └── code/
│
├── 📁 ideas/                 # Idea catalog
│   ├── ideas.json
│   └── [categorized-ideas]/
│
├── 📁 knowledge/             # Knowledge base
│   ├── company-policies/
│   ├── technical-docs/
│   └── market-research/
│
└── 📁 tickets/               # All tasks & bugs
```

## Daily Workflow

1. **Morning Standup**
   - Check [ROADMAP.md](./ROADMAP.md)
   - Review assigned tickets in Linear
   - Check for new ideas in [ideas/](./ideas/)

2. **Development**
   - Create branch from ticket
   - Develop with Cursor AI assistance
   - Write tests
   - Create PR

3. **End of Day**
   - Update ticket status
   - Document progress
   - Log work in daily standup

## Key Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `README.md` | Project overview | First day |
| `ORCHESTRATION.md` | Workflow rules | As needed |
| `projects/[name]/README.md` | Project details | Onboarding |
| `ideas/ideas.json` | Idea tracking | New ideas |
```

### Afternoon: Hands-On Exercises

#### Exercise 1: Create a New Idea

```bash
# 1. Navigate to ideas directory
cd ai-startup-coordination
cd ideas

# 2. Create new idea file
cat > idea-XXX.md << 'EOF'
---
id: idea-XXX
title: Your Idea Title
category: product
status: backlog
priority: medium
tags: [tag1, tag2]
created: 2026-02-11
author: Your Name
---

# Your Idea Title

## Summary
Brief description of the idea

## Problem
What problem does this solve?

## Solution
How will you solve it?

## Next Steps
1. [ ] First step
2. [ ] Second step
EOF

# 3. Add to ideas.json
# (Use the script)
npm run ideas:add idea-XXX.md

# 4. Commit and push
git add .
git commit -m "feat: add new idea - your idea title"
git push origin main
```

#### Exercise 2: Generate Tickets from Requirements

```bash
# 1. Create a requirements document
cat > projects/demo/requirements.md << 'EOF'
# Demo Project Requirements

We need to build a simple todo list application.

Features:
- Users can create todos
- Users can mark todos as done
- Users can delete todos
- Todos are persisted in local storage
EOF

# 2. Ask OpenClaw to generate tickets
openclaw tickets generate \
  --file projects/demo/requirements.md \
  --project demo

# 3. Review generated tickets
cat projects/demo/user-stories/*.md
```

#### Exercise 3: Complete a Small Task

```bash
# 1. Find an available task
openclaw task list --status=ready --limit=5

# 2. Assign to yourself
openclaw task claim [TASK-ID]

# 3. Create branch
git checkout -b feature/[TASK-ID]-short-description

# 4. Complete with Cursor AI assistance
# (Use Cursor to write code)

# 5. Create PR
gh pr create --title "feat: short description" \
  --body "Completes task [TASK-ID]"
```

---

## 6. Day 5: First Project

### Morning: Assign First Project

#### Project Assignment Template

```markdown
# First Project: [Project Name]

## Overview
[Brief description of project]

## Your Role
[Specific responsibilities]

## Goals for Week 1
- [ ] Goal 1
- [ ] Goal 2
- [ ] Goal 3

## Key Contacts
- **Mentor:** [Name] - [Slack handle]
- **Project Lead:** [Name] - [Slack handle]

## Resources
- [Project README](./projects/[project]/README.md)
- [Architecture Spec](./projects/[project]/specs/architecture.md)
- [API Documentation](./projects/[project]/specs/api.md)

## Definition of Done
- [ ] Code written and tested
- [ ] PR created and reviewed
- [ ] Documentation updated
- [ ] Demo presented
```

### Afternoon: First PR

#### First Pull Request Checklist

- [ ] Created feature branch
- [ ] Made changes following coding standards
- [ ] Added tests
- [ ] Updated documentation
- [ ] Ran linting and formatting
- [ ] Created PR with clear description
- [ ] Linked to ticket
- [ ] Requested review from mentor

---

## 7. Ongoing Training

### Week 1-2: Learning

| Day | Focus | Activity |
|-----|-------|----------|
| Mon | Basics | Complete all Day 1-4 exercises |
| Tue | Practice | Work on sample project |
| Wed | Tools | Deep dive into Cursor features |
| Thu | Workflow | Practice full workflow |
| Fri | Review | Present learnings to team |

### Month 1: Mastery

| Week | Focus | Goals |
|------|-------|-------|
| 1 | Environment | Be comfortable with all tools |
| 2 | Workflow | Complete first project independently |
| 3 | Efficiency | Use AI tools effectively |
| 4 | Contribution | Contribute to improving workflows |

### Training Resources

| Resource | Description | Access |
|----------|-------------|--------|
| **Cursor Documentation** | AI coding best practices | cursor.sh/docs |
| **OpenClaw Guide** | OpenClaw usage | docs.openclaw.dev |
| **Company Wiki** | Internal processes | Notion/Confluence |
| **Mentor Hours** | 1:1 with experienced team member | Schedule weekly |

---

## 8. Troubleshooting

### Common Issues

#### Issue: Can't Connect to Tailscale

```bash
# Check Tailscale status
tailscale status

# Restart Tailscale
sudo systemctl restart tailscaled

# Check firewall
sudo ufw status

# Verify network
ping 8.8.8.8
```

#### Issue: Cursor Not Connecting to Repository

```bash
# Verify GitHub authentication
gh auth status

# Re-authenticate if needed
gh auth login

# Verify repository access
gh repo view [org]/[repo]
```

#### Issue: OpenClaw Won't Start

```bash
# Check logs
journalctl -u openclaw -n 100

# Verify configuration
openclaw doctor

# Check port availability
netstat -tlnp | grep 18789

# Restart service
sudo systemctl restart openclaw
```

#### Issue: Permission Denied

```bash
# Check group membership
groups

# Add to docker group
sudo usermod -aG docker $USER

# Re-login or run
newgrp docker

# Verify permissions
ls -la ~/.ssh/
```

### Help Contacts

| Issue | Contact | Response Time |
|-------|---------|---------------|
| **Hardware** | IT Support | Same day |
| **Access** | Security Lead | 2 hours |
| **Tools** | Onboarding Buddy | 1 hour |
| **Workflow** | Team Lead | 4 hours |
| **Urgent** | #help-desk (Slack) | Immediate |

---

## Quick Reference Card

### Day 1 Quick Commands

```bash
# Check all services
openclaw doctor

# View tasks
openclaw task list

# Sync with Linear
openclaw sync linear

# Daily standup
openclaw report daily
```

### Key Links

| Resource | URL |
|----------|-----|
| **Coordinating Repo** | github.com/Ai-Whisperers/work-coordination |
| **Linear Workspace** | linear.app/company |
| **Documentation** | wiki.company.com |
| **Support Channel** | #help-desk (Slack) |

### First Week Goals

- [ ] Complete all Day 1-5 activities
- [ ] Submit first PR
- [ ] Add first idea to catalog
- [ ] Complete one full workflow
- [ ] Meet with mentor 3+ times

---

**Document Information**
- Created: February 2026
- Version: 1.0
- Status: Production Ready
