#!/bin/bash
# Comprehensive Skill Installation for AI Whisperers
# Categories: Marketing, Coding, Git, DevOps, Automation, Research, Tools, Productivity, 
# Finance, Data, Communication, Speech, Calendar, Self-Hosted, Agent Protocols

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TOTAL_INSTALLED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

echo "═══════════════════════════════════════════════════════════════════════"
echo "  🤖 AI WHISPERERS - COMPREHENSIVE SKILL INSTALLATION"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo "This will install carefully selected skills across 15 categories:"
echo "  ✓ Marketing & Sales"
echo "  ✓ Coding & Development"
echo "  ✓ Git & GitHub"
echo "  ✓ DevOps & Cloud"
echo "  ✓ Automation"
echo "  ✓ Research & Search"
echo "  ✓ Tools & Utilities"
echo "  ✓ Tasks & Productivity"
echo "  ✓ Finance"
echo "  ✓ Data & Analytics"
echo "  ✓ Communication"
echo "  ✓ Speech & Transcription"
echo "  ✓ Calendar & Scheduling"
echo "  ✓ Self-Hosted & Automation"
echo "  ✓ Agent-to-Agent Protocols"
echo ""
echo "⚠️  Each skill will be security-audited before installation"
echo ""
read -p "Continue? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Installation cancelled."
    exit 0
fi

install_skill_batch() {
    local category=$1
    shift
    local skills=($@)
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════"
    echo "  📂 CATEGORY: $category"
    echo "═══════════════════════════════════════════════════════════════════════"
    echo ""
    
    for skill in "${skills[@]}"; do
        echo -e "${BLUE}Installing: $skill${NC}"
        
        if [ -d "$HOME/.openclaw/skills/$skill" ]; then
            echo -e "${GREEN}  ✓ Already installed${NC}"
            ((TOTAL_SKIPPED++))
            continue
        fi
        
        if ~/.openclaw/scripts/secure-install-skill.sh "$skill" "$category" 2>&1 | tee "/tmp/skill-install-$skill.log"; then
            echo -e "${GREEN}  ✓ Successfully installed: $skill${NC}"
            ((TOTAL_INSTALLED++))
        else
            echo -e "${YELLOW}  ⚠ Failed or skipped: $skill${NC}"
            echo "    Check: /tmp/skill-install-$skill.log"
            ((TOTAL_FAILED++))
        fi
        echo ""
    done
}

# CATEGORY 1: CODING & DEVELOPMENT (Essential)
install_skill_batch "Coding Agents & IDEs" \
    "coding-agent" \
    "python" \
    "debug-pro" \
    "mcp-builder" \
    "claude-optimised" \
    "test-runner" \
    "tdd-guide" \
    "regex-patterns" \
    "backend-patterns" \
    "skill-creator"

# CATEGORY 2: GIT & GITHUB (Essential)
install_skill_batch "Git & GitHub" \
    "github" \
    "git-sync" \
    "git-essentials" \
    "git-workflows" \
    "conventional-commits" \
    "git-summary" \
    "pr-reviewer" \
    "commit-analyzer" \
    "git-helper"

# CATEGORY 3: DEVOPS & CLOUD (High Priority)
install_skill_batch "DevOps & Cloud" \
    "docker-essentials" \
    "github" \
    "deploy-agent" \
    "ssh-tunnel" \
    "emergency-rescue"

# CATEGORY 4: RESEARCH & SEARCH (Essential for AI/ML)
install_skill_batch "Search & Research" \
    "exa-web-search-free" \
    "cellcog" \
    "microsoft-docs" \
    "deepwiki" \
    "trend-watcher"

# CATEGORY 5: DATA & ANALYTICS
install_skill_batch "Data & Analytics" \
    "budget-variance-analyzer" \
    "model-usage" \
    "data-analysis"

# CATEGORY 6: PRODUCTIVITY & TASKS
install_skill_batch "Productivity & Tasks" \
    "summarize" \
    "blogwatcher" \
    "obsidian" \
    "task-status" \
    "pndr" \
    "hour-meter" \
    "deepwork-tracker"

# CATEGORY 7: TOOLS & UTILITIES
install_skill_batch "CLI Utilities" \
    "bat-cat" \
    "vhs-recorder" \
    "get-tldr" \
    "backup" \
    "git-crypt-backup"

# CATEGORY 8: PDF & DOCUMENTS
install_skill_batch "PDF & Documents" \
    "nano-pdf" \
    "pdf-tools"

# CATEGORY 9: COMMUNICATION
install_skill_batch "Communication" \
    "gog" \
    "whatsapp-styling-guide"

# CATEGORY 10: MARKETING & SALES
install_skill_batch "Marketing & Sales" \
    "meta-video-ad-deconstructor" \
    "aisa-twitter-api" \
    "go2gg"

# CATEGORY 11: FINANCE (Careful with these)
install_skill_batch "Finance" \
    "copilot-money" \
    "financial-calculator" \
    "openinsider"

# CATEGORY 12: CALENDAR & SCHEDULING
install_skill_batch "Calendar & Scheduling" \
    "hour-meter"

# CATEGORY 13: SPEECH & TRANSCRIPTION
install_skill_batch "Speech & Transcription" \
    "voice-reply"

# CATEGORY 14: SELF-HOSTED & AUTOMATION
install_skill_batch "Self-Hosted & Automation" \
    "perry-workspaces" \
    "docker-sandbox" \
    "deploy-moltbot-to-fly" \
    "smart-auto-updater"

# CATEGORY 15: AGENT-TO-AGENT PROTOCOLS
install_skill_batch "Agent-to-Agent Protocols" \
    "agentchat" \
    "mcp-builder" \
    "ec-task-orchestrator" \
    "agent-commons" \
    "perry-coding-agents"

# CATEGORY 16: SECURITY & MONITORING
install_skill_batch "Security & Passwords" \
    "healthcheck" \
    "skill-vetting" \
    "emergency-rescue" \
    "side-peace"

# CATEGORY 17: NOTES & KNOWLEDGE MANAGEMENT
install_skill_batch "Notes & PKM" \
    "obsidian" \
    "logseq" \
    "content-id-guide"

echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "  📊 INSTALLATION COMPLETE"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}✓ Installed: $TOTAL_INSTALLED${NC}"
echo -e "${YELLOW}⚠ Skipped/Existing: $TOTAL_SKIPPED${NC}"
echo -e "${RED}✗ Failed: $TOTAL_FAILED${NC}"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "  🔧 POST-INSTALLATION SETUP"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo "1. Enable installed skills:"
echo "   openclaw skills list"
echo ""
echo "2. Configure API keys in ~/.openclaw/.env:"
echo "   # For GitHub integration"
echo "   GITHUB_TOKEN=your_token_here"
echo ""
echo "   # For Google Workspace (if using gog)"
echo "   GOOGLE_CLIENT_ID=..."
echo "   GOOGLE_CLIENT_SECRET=..."
echo ""
echo "   # For Docker (if using docker-essentials)"
echo "   DOCKER_HOST=unix:///var/run/docker.sock"
echo ""
echo "3. Test skills:"
echo "   openclaw skills check <skill-name>"
echo ""
echo "4. Monitor costs:"
echo "   tail -f ~/.openclaw/logs/costs.log"
echo ""
echo "5. Review security:"
echo "   openclaw security audit"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"

exit 0
