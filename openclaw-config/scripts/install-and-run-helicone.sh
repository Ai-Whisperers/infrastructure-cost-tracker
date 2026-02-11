#!/bin/bash
# install-and-run-helicone.sh
# Actually install Docker and run Helicone (not just document it)

set -e

echo "=== Installing Docker ==="
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed. Please log out and back in, then re-run this script."
    exit 0
fi

echo "=== Creating Helicone Directory ==="
mkdir -p /opt/helicone
cd /opt/helicone

echo "=== Creating docker-compose.yml ==="
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  helicone:
    image: helicone/gateway:latest
    container_name: helicone-gateway
    ports:
      - "8585:8585"
    environment:
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    volumes:
      - ./config:/app/config
    restart: unless-stopped
    networks:
      - helicone-net

  redis:
    image: redis:7-alpine
    container_name: helicone-redis
    volumes:
      - redis-data:/data
    restart: unless-stopped
    networks:
      - helicone-net

networks:
  helicone-net:
    driver: bridge

volumes:
  redis-data:
EOF

echo "=== Loading environment variables ==="
export $(grep -v '^#' ~/.openclaw/.env | xargs)

echo "=== Starting Helicone ==="
docker compose up -d

echo "=== Waiting for startup ==="
sleep 5

echo "=== Testing Helicone ==="
if curl -s http://localhost:8585/health > /dev/null; then
    echo "✅ Helicone is running on http://localhost:8585"
    echo ""
    echo "Next steps:"
    echo "1. Update OpenClaw config:"
    echo "   openclaw config set agents.defaults.model.api_base 'http://localhost:8585/v1'"
    echo "2. Restart OpenClaw:"
    echo "   openclaw gateway restart"
else
    echo "❌ Helicone failed to start. Check logs:"
    echo "   docker compose logs"
fi
