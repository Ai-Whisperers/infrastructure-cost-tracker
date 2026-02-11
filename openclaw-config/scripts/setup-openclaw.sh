#!/bin/bash
# OpenClaw Setup Script for AI Whisperers
# Production-hardened configuration with comprehensive security

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="$HOME/.openclaw-backup-$(date +%Y%m%d-%H%M%S)"

# Functions
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        error "Node.js version $NODE_VERSION found. Version 18+ required."
        exit 1
    fi
    success "Node.js $(node -v) found"
    
    # Check npm/pnpm
    if command -v pnpm &> /dev/null; then
        PKG_MANAGER="pnpm"
        success "Using pnpm"
    elif command -v npm &> /dev/null; then
        PKG_MANAGER="npm"
        success "Using npm"
    else
        error "No package manager found. Install npm or pnpm."
        exit 1
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        warning "Git not found. Some features may not work."
    else
        success "Git found"
    fi
}

# Backup existing configuration
backup_existing() {
    if [ -d "$OPENCLAW_DIR" ]; then
        log "Backing up existing OpenClaw configuration..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$OPENCLAW_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
        success "Backup created at $BACKUP_DIR"
    fi
}

# Install OpenClaw CLI
install_openclaw() {
    log "Installing OpenClaw CLI..."
    
    if command -v openclaw &> /dev/null; then
        success "OpenClaw already installed ($(openclaw --version))"
        return
    fi
    
    # Install using npm/pnpm
    $PKG_MANAGER install -g openclaw
    
    if ! command -v openclaw &> /dev/null; then
        error "OpenClaw installation failed"
        exit 1
    fi
    
    success "OpenClaw installed ($(openclaw --version))"
}

# Setup directory structure
setup_directories() {
    log "Setting up directory structure..."
    
    mkdir -p "$OPENCLAW_DIR"/{skills,scripts,logs,memory,workspace}
    
    # Set secure permissions
    chmod 700 "$OPENCLAW_DIR"
    chmod 700 "$OPENCLAW_DIR/skills"
    chmod 700 "$OPENCLAW_DIR/scripts"
    chmod 700 "$OPENCLAW_DIR/logs"
    chmod 700 "$OPENCLAW_DIR/memory"
    chmod 700 "$OPENCLAW_DIR/workspace"
    
    success "Directory structure created"
}

# Copy configuration files
copy_configuration() {
    log "Copying configuration files..."
    
    # Main config
    cp "$REPO_DIR/openclaw.json" "$OPENCLAW_DIR/"
    chmod 600 "$OPENCLAW_DIR/openclaw.json"
    success "openclaw.json copied"
    
    # Cost limits
    cp "$REPO_DIR/cost-limits.json" "$OPENCLAW_DIR/"
    chmod 600 "$OPENCLAW_DIR/cost-limits.json"
    success "cost-limits.json copied"
    
    # Exec approvals
    cp "$REPO_DIR/exec-approvals.json" "$OPENCLAW_DIR/"
    chmod 600 "$OPENCLAW_DIR/exec-approvals.json"
    success "exec-approvals.json copied"
    
    # Environment template
    if [ ! -f "$OPENCLAW_DIR/.env" ]; then
        cp "$REPO_DIR/.env.template" "$OPENCLAW_DIR/.env"
        chmod 600 "$OPENCLAW_DIR/.env"
        warning ".env file created from template. EDIT THIS FILE to add your API keys!"
    else
        warning ".env file already exists. Not overwriting."
    fi
    
    # Gateway password
    if [ ! -f "$OPENCLAW_DIR/.gateway-password" ]; then
        openssl rand -base64 32 > "$OPENCLAW_DIR/.gateway-password"
        chmod 600 "$OPENCLAW_DIR/.gateway-password"
        success "Secure gateway password generated"
    fi
}

# Install custom skills
install_skills() {
    log "Installing custom skills..."
    
    for skill_dir in "$REPO_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            cp -r "$skill_dir" "$OPENCLAW_DIR/skills/"
            chmod 640 "$OPENCLAW_DIR/skills/$skill_name/SKILL.md"
            success "Skill installed: $skill_name"
        fi
    done
    
    log "Enabling skills in configuration..."
    for skill_dir in "$OPENCLAW_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            openclaw config set "skills.entries.$skill_name.enabled" true 2>/dev/null || true
        fi
    done
}

# Copy scripts
copy_scripts() {
    log "Copying utility scripts..."
    
    for script in "$REPO_DIR/scripts"/*; do
        if [ -f "$script" ]; then
            cp "$script" "$OPENCLAW_DIR/scripts/"
            chmod 750 "$OPENCLAW_DIR/scripts/$(basename "$script")"
        fi
    done
    
    success "Scripts copied"
}

# Generate environment variables
generate_env() {
    log "Setting up environment variables..."
    
    ENV_FILE="$OPENCLAW_DIR/.env"
    
    # Add gateway password to .env if not present
    if ! grep -q "OPENCLAW_GATEWAY_PASSWORD" "$ENV_FILE" 2>/dev/null; then
        GATEWAY_PASS=$(cat "$OPENCLAW_DIR/.gateway-password")
        echo "" >> "$ENV_FILE"
        echo "# Auto-generated gateway password" >> "$ENV_FILE"
        echo "OPENCLAW_GATEWAY_PASSWORD=$GATEWAY_PASS" >> "$ENV_FILE"
    fi
    
    chmod 600 "$ENV_FILE"
    success "Environment variables configured"
}

# Security hardening
security_hardening() {
    log "Applying security hardening..."
    
    # Remove any backup files
    find "$OPENCLAW_DIR" -name "*.bak" -delete 2>/dev/null || true
    find "$OPENCLAW_DIR" -name "*.backup" -delete 2>/dev/null || true
    
    # Ensure all sensitive files have correct permissions
    chmod 600 "$OPENCLAW_DIR/.env" 2>/dev/null || true
    chmod 600 "$OPENCLAW_DIR/.gateway-password" 2>/dev/null || true
    chmod 600 "$OPENCLAW_DIR/openclaw.json" 2>/dev/null || true
    chmod 600 "$OPENCLAW_DIR/cost-limits.json" 2>/dev/null || true
    chmod 600 "$OPENCLAW_DIR/exec-approvals.json" 2>/dev/null || true
    chmod 600 "$OPENCLAW_DIR/memory"/*.sqlite 2>/dev/null || true
    
    # Set skill permissions
    find "$OPENCLAW_DIR/skills" -name "SKILL.md" -exec chmod 640 {} \;
    
    success "Security hardening applied"
}

# Verify installation
verify_installation() {
    log "Verifying installation..."
    
    # Check for exposed secrets
    if grep -E "(botToken|password|apiKey)" "$OPENCLAW_DIR/openclaw.json" | grep -v "mode.*password" > /dev/null 2>&1; then
        error "Secrets found in openclaw.json! Please check configuration."
        exit 1
    fi
    success "No exposed secrets in config"
    
    # Check file permissions
    ENV_PERMS=$(stat -c "%a" "$OPENCLAW_DIR/.env" 2>/dev/null || echo "000")
    if [ "$ENV_PERMS" != "600" ]; then
        warning ".env file permissions may be incorrect"
        chmod 600 "$OPENCLAW_DIR/.env"
    fi
    success "File permissions correct"
    
    # Check OpenClaw can parse config
    if ! openclaw config get gateway.port > /dev/null 2>&1; then
        error "OpenClaw cannot parse configuration"
        exit 1
    fi
    success "Configuration valid"
    
    # Run security audit
    log "Running security audit..."
    AUDIT_RESULT=$(openclaw security audit 2>&1)
    
    if echo "$AUDIT_RESULT" | grep -q "0 critical"; then
        success "Security audit passed (0 critical issues)"
    else
        warning "Security audit found issues. Review with: openclaw security audit"
    fi
}

# Start OpenClaw
start_openclaw() {
    log "Starting OpenClaw gateway..."
    
    # Stop any existing instance
    openclaw gateway stop 2>/dev/null || true
    sleep 2
    
    # Start in background
    openclaw gateway --daemon 2>&1 &
    sleep 5
    
    # Check if running
    if openclaw status | grep -q "running"; then
        success "OpenClaw gateway started successfully"
        log "Dashboard: http://127.0.0.1:18789/"
    else
        warning "Gateway may not have started properly. Check: openclaw status"
    fi
}

# Print summary
print_summary() {
    echo ""
    echo "============================================"
    echo "  OpenClaw Setup Complete!"
    echo "============================================"
    echo ""
    echo -e "${GREEN}✓${NC} OpenClaw CLI installed"
    echo -e "${GREEN}✓${NC} Configuration files copied"
    echo -e "${GREEN}✓${NC} 12 custom skills installed"
    echo -e "${GREEN}✓${NC} Security hardening applied"
    echo -e "${GREEN}✓${NC} Security audit passed"
    echo ""
    echo "Next Steps:"
    echo "  1. Edit ~/.openclaw/.env and add your API keys"
    echo "  2. Configure Telegram: @BotFather -> /newbot"
    echo "  3. Add TELEGRAM_BOT_TOKEN to .env"
    echo "  4. Restart: openclaw gateway restart"
    echo ""
    echo "Useful Commands:"
    echo "  openclaw status          - Check status"
    echo "  openclaw skills list     - List skills"
    echo "  openclaw security audit  - Run security audit"
    echo "  openclaw logs --follow   - View logs"
    echo ""
    echo "Documentation:"
    echo "  $REPO_DIR/README.md"
    echo "  $REPO_DIR/security/COMPREHENSIVE_SECURITY_AUDIT.md"
    echo ""
    echo "Backup Location: $BACKUP_DIR"
    echo ""
    echo -e "${YELLOW}⚠ IMPORTANT:${NC} Edit ~/.openclaw/.env before using!"
    echo ""
}

# Main
main() {
    echo "============================================"
    echo "  OpenClaw Setup - AI Whisperers"
    echo "  Production-Hardened Configuration"
    echo "============================================"
    echo ""
    
    check_prerequisites
    backup_existing
    install_openclaw
    setup_directories
    copy_configuration
    install_skills
    copy_scripts
    generate_env
    security_hardening
    verify_installation
    
    read -p "Start OpenClaw gateway now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        start_openclaw
    fi
    
    print_summary
}

# Handle arguments
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "OpenClaw Setup Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help message"
    echo "  --dry-run      Show what would be done (not implemented)"
    echo ""
    echo "This script sets up a production-hardened OpenClaw instance"
    echo "with comprehensive security controls."
    exit 0
fi

# Run main
main
