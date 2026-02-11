#!/bin/bash
# Docker Installation Script for AI Whisperers
# Run this with: sudo bash install-docker.sh

set -e

echo "=========================================="
echo "  Docker Installation Script"
echo "  AI Whisperers Infrastructure"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Step 1: Removing old Docker versions..."
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

echo ""
echo "Step 2: Updating package index..."
apt-get update

echo ""
echo "Step 3: Installing prerequisites..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo ""
echo "Step 4: Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo ""
echo "Step 5: Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ""
echo "Step 6: Updating package index..."
apt-get update

echo ""
echo "Step 7: Installing Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo ""
echo "Step 8: Verifying installation..."
if docker --version; then
    echo -e "${GREEN}✓ Docker installed successfully!${NC}"
else
    echo -e "${RED}✗ Docker installation failed${NC}"
    exit 1
fi

echo ""
echo "Step 9: Enabling Docker service..."
systemctl enable docker
systemctl start docker

echo ""
echo "Step 10: Adding current user to docker group..."
usermod -aG docker $SUDO_USER

echo ""
echo "=========================================="
echo -e "${GREEN}✓ Docker Installation Complete!${NC}"
echo "=========================================="
echo ""
echo "Docker version:"
docker --version
echo ""
echo "Docker Compose version:"
docker compose version
echo ""
echo "IMPORTANT: Log out and log back in for"
echo "group changes to take effect."
echo ""
echo "Or run: newgrp docker"
echo ""
