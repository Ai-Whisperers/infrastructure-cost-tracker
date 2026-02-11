#!/bin/bash
# Skill Security Auditor
# Run this before installing any new skill

set -e

SKILL_NAME="${1:-}"
if [ -z "$SKILL_NAME" ]; then
  echo "Usage: $0 <skill-name>"
  echo "Example: $0 github"
  exit 1
fi

echo "═══════════════════════════════════════════════════"
echo "🔍 SKILL SECURITY AUDIT: $SKILL_NAME"
echo "═══════════════════════════════════════════════════"
echo ""

# Check if skill exists
if [ ! -d "$HOME/.openclaw/skills/$SKILL_NAME" ]; then
  echo "❌ Skill not found: $SKILL_NAME"
  echo "Available skills:"
  ls ~/.openclaw/skills/ | head -20
  exit 1
fi

cd "$HOME/.openclaw/skills/$SKILL_NAME"

echo "📁 Location: $(pwd)"
echo ""

# 1. Check source/trust
echo "🔐 STEP 1: Trust Verification"
echo "───────────────────────────────────────────────────"

if [ -f "SKILL.md" ]; then
  SOURCE=$(grep -E "source|origin|publisher" SKILL.md | head -3 || echo "Not specified")
  echo "Source info:"
  echo "$SOURCE"
  
  # Check for official/bundled markers
  if grep -q "openclaw-bundled\|openclaw-managed\|official" SKILL.md; then
    echo "✅ Source: Official/OpenClaw (Lower Risk)"
  else
    echo "⚠️  Source: Third-party (Manual review required)"
  fi
else
  echo "❌ No SKILL.md found (Cannot verify source)"
fi
echo ""

# 2. Check requirements
echo "⚙️  STEP 2: Requirements Analysis"
echo "───────────────────────────────────────────────────"

if [ -f "SKILL.md" ]; then
  echo "Required binaries:"
  grep -E "requires.*bin|requires.*cli|npm install|pip install" SKILL.md | head -10 || echo "  None specified"
  
  echo ""
  echo "File system access:"
  grep -E "workspace|~/.|/tmp|/home" SKILL.md | head -5 || echo "  Standard paths only"
  
  echo ""
  echo "Network access:"
  grep -E "api\.|http|curl|wget|fetch" SKILL.md | head -5 || echo "  None obvious"
fi
echo ""

# 3. Check dependencies (if npm)
echo "📦 STEP 3: Dependency Check"
echo "───────────────────────────────────────────────────"

if [ -f "package.json" ]; then
  echo "Found package.json"
  
  # Count dependencies
  DEPS=$(cat package.json | jq '.dependencies | length' 2>/dev/null || echo "0")
  DEV_DEPS=$(cat package.json | jq '.devDependencies | length' 2>/dev/null || echo "0")
  
  echo "Dependencies: $DEPS"
  echo "Dev Dependencies: $DEV_DEPS"
  
  # Check for suspicious patterns
  echo ""
  echo "Checking for suspicious patterns..."
  
  SUSPICIOUS=$(cat package.json | jq -r '.dependencies | keys[]' 2>/dev/null | grep -iE "(http|curl|wget|netcat|nc|socket|eval|exec|child|spawn)" || true)
  if [ -n "$SUSPICIOUS" ]; then
    echo "⚠️  Suspicious dependencies found:"
    echo "$SUSPICIOUS"
  else
    echo "✅ No obviously suspicious dependencies"
  fi
  
  # Check for postinstall scripts
  if grep -q "postinstall" package.json; then
    echo "⚠️  Has postinstall script (review carefully):"
    cat package.json | jq '.scripts.postinstall' 2>/dev/null
  fi
  
  # Run npm audit if possible
  echo ""
  echo "Running npm audit..."
  npm audit --audit-level=moderate 2>/dev/null | head -30 || echo "Could not run audit (dependencies not installed)"
  
else
  echo "ℹ️  No package.json (script-based or simple skill)"
fi
echo ""

# 4. Check for executable scripts
echo "🔍 STEP 4: Executable Content"
echo "───────────────────────────────────────────────────"

SCRIPTS=$(find . -type f \( -name "*.sh" -o -name "*.js" -o -name "*.py" -o -name "*.ts" \) 2>/dev/null | head -20)

if [ -n "$SCRIPTS" ]; then
  echo "Executable files found:"
  echo "$SCRIPTS" | while read file; do
    echo "  - $file ($(wc -l < "$file" 2>/dev/null || echo "0") lines)"
  done
  
  echo ""
  echo "Checking for dangerous patterns..."
  
  DANGEROUS=$(grep -r -l "eval\|exec\|child_process\|spawn\|sudo\|rm -rf" . --include="*.js" --include="*.ts" --include="*.py" --include="*.sh" 2>/dev/null | head -10 || true)
  
  if [ -n "$DANGEROUS" ]; then
    echo "⚠️  Files with potentially dangerous patterns:"
    echo "$DANGEROUS" | while read file; do
      echo "  - $file"
    done
    echo ""
    echo "Review these files manually!"
  else
    echo "✅ No obviously dangerous patterns"
  fi
else
  echo "ℹ️  No executable scripts found"
fi
echo ""

# 5. Risk assessment
echo "⚠️  STEP 5: Risk Assessment"
echo "───────────────────────────────────────────────────"

RISK_SCORE=0
RISK_FACTORS=""

# Check various risk factors
if grep -q "sudo" SKILL.md 2>/dev/null; then
  RISK_SCORE=$((RISK_SCORE + 50))
  RISK_FACTORS="${RISK_FACTORS}Uses sudo\n"
fi

if grep -q "docker" SKILL.md 2>/dev/null; then
  RISK_SCORE=$((RISK_SCORE + 40))
  RISK_FACTORS="${RISK_FACTORS}Uses Docker (privileged access)\n"
fi

if grep -q "aws\|gcp\|azure" SKILL.md 2>/dev/null; then
  RISK_SCORE=$((RISK_SCORE + 30))
  RISK_FACTORS="${RISK_FACTORS}Cloud provider access\n"
fi

if [ -f "package.json" ] && [ "$DEPS" -gt 50 ]; then
  RISK_SCORE=$((RISK_SCORE + 20))
  RISK_FACTORS="${RISK_FACTORS}Many dependencies ($DEPS)\n"
fi

if grep -q "curl.*|.*sh\|wget.*|.*sh" SKILL.md 2>/dev/null; then
  RISK_SCORE=$((RISK_SCORE + 100))
  RISK_FACTORS="${RISK_FACTORS}Pipes curl/wget to shell (CRITICAL)\n"
fi

# Display risk score
echo "Risk Score: $RISK_SCORE/100"
echo ""

if [ $RISK_SCORE -ge 80 ]; then
  echo "🔴 CRITICAL RISK - Do not install without thorough review"
  echo "Risk factors:"
  echo -e "$RISK_FACTORS"
elif [ $RISK_SCORE -ge 50 ]; then
  echo "🟠 HIGH RISK - Review carefully before installing"
  echo "Risk factors:"
  echo -e "$RISK_FACTORS"
elif [ $RISK_SCORE -ge 20 ]; then
  echo "🟡 MEDIUM RISK - Standard precautions recommended"
  echo "Risk factors:"
  echo -e "$RISK_FACTORS"
else
  echo "🟢 LOW RISK - Generally safe"
fi
echo ""

# 6. Recommendations
echo "✅ STEP 6: Recommendations"
echo "───────────────────────────────────────────────────"

if [ $RISK_SCORE -ge 50 ]; then
  echo "1. Review SKILL.md thoroughly before enabling"
  echo "2. Check all executable files manually"
  echo "3. Set strict cost limits before use"
  echo "4. Enable exec approvals for this skill"
  echo "5. Monitor first use carefully"
  echo "6. Consider running in isolated environment"
else
  echo "1. Standard security practices apply"
  echo "2. Keep exec approvals enabled"
  echo "3. Monitor cost usage"
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "Audit complete. Review findings before enabling."
echo "═══════════════════════════════════════════════════"
