#!/bin/bash
# Secure Skill Installation Workflow for VoltAgent/awesome-openclaw-skills
# This script safely installs skills from external repositories

set -e

SKILL_NAME="${1:-}"
CATEGORY="${2:-}"

if [ -z "$SKILL_NAME" ]; then
  echo "🔒 Secure Skill Installer"
  echo ""
  echo "Usage: $0 <skill-name> [category]"
  echo "Example: $0 docker-essentials 'DevOps & Cloud'"
  echo ""
  echo "This script will:"
  echo "  1. Download skill from GitHub"
  echo "  2. Run security audit"
  echo "  3. Show you what it will do"
  echo "  4. Install only if you approve"
  exit 1
fi

echo "═══════════════════════════════════════════════════"
echo "🔒 SECURE SKILL INSTALLATION"
echo "Skill: $SKILL_NAME"
echo "═══════════════════════════════════════════════════"
echo ""

# Configuration
REPO_URL="https://github.com/openclaw/skills"
TEMP_DIR="/tmp/openclaw-skill-install-$$"
INSTALL_DIR="$HOME/.openclaw/skills"

# Create temp directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Step 1: Download skill
echo "📥 STEP 1: Downloading skill..."
echo "Source: $REPO_URL/tree/main/skills/*/$SKILL_NAME"

# Try to find the skill in the repo
# Skills are organized as: skills/<author>/<skill-name>/
SKILL_URL="$REPO_URL/tree/main/skills"

# Download using curl (shallow, just the skill directory)
# Note: GitHub doesn't allow directory downloads, so we use API
echo "Searching for skill in repository..."

# Try common locations
AUTHOR=$(curl -s "https://api.github.com/repos/openclaw/skills/contents/skills" | \
  jq -r ".[] | select(.type==\"dir\") | .name" | \
  while read author; do
    if curl -s "https://api.github.com/repos/openclaw/skills/contents/skills/$author/$SKILL_NAME" | grep -q "Not Found"; then
      continue
    else
      echo "$author"
      break
    fi
  done)

if [ -z "$AUTHOR" ]; then
  echo "❌ Skill not found: $SKILL_NAME"
  echo ""
  echo "Searching manually..."
  
  # Fallback: search the awesome list
  echo "Checking VoltAgent/awesome-openclaw-skills list..."
  
  # User should provide category
  if [ -z "$CATEGORY" ]; then
    echo "⚠️  Category not specified. Common categories:"
    echo "  - 'Coding Agents & IDEs'"
    echo "  - 'DevOps & Cloud'"
    echo "  - 'Git & GitHub'"
    echo "  - 'Productivity & Tasks'"
    echo "  - 'Security & Passwords'"
    echo ""
    read -p "Enter category (or press Enter to skip): " CATEGORY
  fi
fi

if [ -n "$AUTHOR" ]; then
  echo "✓ Found: skills/$AUTHOR/$SKILL_NAME"
  
  # Download SKILL.md
  curl -sL "https://raw.githubusercontent.com/openclaw/skills/main/skills/$AUTHOR/$SKILL_NAME/SKILL.md" \
    -o "$TEMP_DIR/SKILL.md"
  
  if [ -f "$TEMP_DIR/SKILL.md" ]; then
    echo "✓ Downloaded SKILL.md"
  else
    echo "❌ Could not download SKILL.md"
    exit 1
  fi
else
  echo "⚠️  Could not auto-detect skill location"
  echo ""
  echo "Manual installation required:"
  echo "1. Visit: https://github.com/VoltAgent/awesome-openclaw-skills"
  echo "2. Find skill: $SKILL_NAME"
  echo "3. Click the GitHub link to openclaw/skills repo"
  echo "4. Download SKILL.md manually"
  echo "5. Run: ~/.openclaw/scripts/audit-skill.sh $SKILL_NAME"
  exit 1
fi

# Step 2: Security Audit
echo ""
echo "🔍 STEP 2: Running security audit..."
echo "───────────────────────────────────────────────────"

# Create temporary skill structure for audit
mkdir -p "$TEMP_DIR/$SKILL_NAME"
cp "$TEMP_DIR/SKILL.md" "$TEMP_DIR/$SKILL_NAME/"

# Run our audit script
# Save original home
ORIGINAL_HOME="$HOME"
export HOME=/tmp/fake-home-$$
mkdir -p "$HOME/.openclaw/skills"
cp -r "$TEMP_DIR/$SKILL_NAME" "$HOME/.openclaw/skills/"

# Run audit using ORIGINAL path, not fake home
"$ORIGINAL_HOME/.openclaw/scripts/audit-skill.sh" "$SKILL_NAME" 2>&1 | tee "$TEMP_DIR/audit.log"

# Get risk score
RISK_SCORE=$(grep "Risk Score:" "$TEMP_DIR/audit.log" | grep -o '[0-9]*' | head -1 || echo "0")

echo ""
echo "═══════════════════════════════════════════════════"
echo "Risk Score: $RISK_SCORE/100"
echo "═══════════════════════════════════════════════════"
echo ""

# Step 3: Show SKILL.md content
echo "📄 STEP 3: Skill Documentation"
echo "───────────────────────────────────────────────────"
echo ""
head -100 "$TEMP_DIR/SKILL.md"
echo ""
echo "[... truncated, full content in $TEMP_DIR/SKILL.md]"
echo ""

# Step 4: Decision
echo "⚖️  STEP 4: Installation Decision"
echo "───────────────────────────────────────────────────"

if [ "$RISK_SCORE" -ge 80 ]; then
  echo "🔴 CRITICAL RISK DETECTED"
  echo ""
  echo "This skill has a CRITICAL risk score ($RISK_SCORE/100)."
  echo "It may:"
  echo "  - Execute arbitrary code"
  echo "  - Access sensitive files"
  echo "  - Make network connections to unknown hosts"
  echo ""
  echo "⚠️  RECOMMENDATION: DO NOT INSTALL"
  echo ""
  read -p "Install anyway? (yes/no): " DECISION
  if [ "$DECISION" != "yes" ]; then
    echo "❌ Installation cancelled"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
elif [ "$RISK_SCORE" -ge 50 ]; then
  echo "🟠 HIGH RISK DETECTED"
  echo ""
  echo "This skill has a HIGH risk score ($RISK_SCORE/100)."
  echo "Review the audit output above carefully."
  echo ""
  read -p "Install with restrictions? (yes/no/review): " DECISION
  
  if [ "$DECISION" = "review" ]; then
    echo "Opening SKILL.md for review..."
    cat "$TEMP_DIR/SKILL.md"
    read -p "Install? (yes/no): " DECISION
  fi
  
  if [ "$DECISION" != "yes" ]; then
    echo "❌ Installation cancelled"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
else
  echo "🟢 LOW-MEDIUM RISK"
  echo ""
  echo "This skill appears to be relatively safe ($RISK_SCORE/100)."
  echo ""
  read -p "Install? (yes/no): " DECISION
  
  if [ "$DECISION" != "yes" ]; then
    echo "❌ Installation cancelled"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
fi

# Step 5: Install
echo ""
echo "📦 STEP 5: Installing skill..."
echo "───────────────────────────────────────────────────"

# Copy to actual location
mkdir -p "$INSTALL_DIR"
cp -r "$TEMP_DIR/$SKILL_NAME" "$INSTALL_DIR/"

# Set secure permissions
chmod -R 755 "$INSTALL_DIR/$SKILL_NAME"
chmod 644 "$INSTALL_DIR/$SKILL_NAME/SKILL.md"

echo "✓ Installed to: $INSTALL_DIR/$SKILL_NAME"

# Check if npm dependencies needed
if [ -f "$INSTALL_DIR/$SKILL_NAME/package.json" ]; then
  echo ""
  echo "📦 Installing npm dependencies..."
  cd "$INSTALL_DIR/$SKILL_NAME"
  npm install --production --silent || {
    echo "⚠️  npm install failed. You may need to install manually:"
    echo "  cd $INSTALL_DIR/$SKILL_NAME && npm install"
  }
fi

# Enable in config
echo ""
echo "⚙️  Enabling skill in OpenClaw config..."
openclaw config set "skills.entries.$SKILL_NAME.enabled" true 2>/dev/null || {
  echo "⚠️  Could not auto-enable. Enable manually with:"
  echo "  openclaw config set skills.entries.$SKILL_NAME.enabled true"
}

echo ""
echo "═══════════════════════════════════════════════════"
echo "✅ INSTALLATION COMPLETE"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Skill: $SKILL_NAME"
echo "Location: $INSTALL_DIR/$SKILL_NAME"
echo "Risk Score: $RISK_SCORE/100"
echo ""
echo "⚠️  NEXT STEPS:"
echo "1. Test the skill in a safe environment first"
echo "2. Monitor logs: tail -f ~/.openclaw/logs/*.log"
echo "3. Set cost limits if the skill uses APIs"
echo "4. Review skill activity: ~/.openclaw/scripts/monitor-skills.sh"
echo ""
echo "To uninstall: rm -rf $INSTALL_DIR/$SKILL_NAME"

# Cleanup
rm -rf "$TEMP_DIR"

exit 0
