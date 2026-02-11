---
name: docker-workflows
Description: "Docker containerization best practices. Use when containerizing applications, creating Dockerfiles, docker-compose configs, or deploying containers."
metadata:
  {
    "openclaw":
      {
        "emoji": "🐳",
        "requires": { "bins": ["docker"] },
        "install": [],
      },
  }
---

# Docker Workflows Skill

Docker containerization best practices for developing, shipping, and running applications.

## When to Use

- Containerizing applications
- Creating Dockerfiles
- Setting up docker-compose
- Managing container deployments
- Building CI/CD pipelines with Docker

## Dockerfile Best Practices

### Multi-Stage Builds

```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json .
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Python Application

```dockerfile
FROM python:3.11-slim

# Security: Run as non-root
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Change ownership
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8000
CMD ["python", "app.py"]
```

### Security Hardening

```dockerfile
FROM python:3.11-slim

# Don't run as root
RUN useradd -m -u 1000 appuser

# Update packages
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Use specific versions
RUN pip install flask==2.3.0

# Copy with correct permissions
COPY --chown=appuser:appuser . /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8000/health || exit 1
```

## Docker Compose

### Web Application Stack

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
      - redis
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
    
  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    restart: unless-stopped
    
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
```

### Development Environment

```yaml
version: '3.8'

services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    command: npm run dev
    
  test:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    command: npm test
    depends_on:
      - dev
```

## Common Commands

### Building

```bash
# Build image
docker build -t myapp:latest .

# Build with specific Dockerfile
docker build -f Dockerfile.prod -t myapp:prod .

# Build without cache
docker build --no-cache -t myapp:latest .

# Build multi-platform
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

### Running

```bash
# Run container
docker run -p 3000:3000 myapp:latest

# Run with environment variables
docker run -e NODE_ENV=production -p 3000:3000 myapp:latest

# Run with volume
docker run -v $(pwd)/data:/app/data myapp:latest

# Run interactively
docker run -it myapp:latest /bin/sh

# Run detached
docker run -d --name myapp myapp:latest
```

### Management

```bash
# List containers
docker ps -a

# Stop container
docker stop myapp

# Remove container
docker rm myapp

# View logs
docker logs -f myapp

# Execute command
docker exec -it myapp /bin/sh

# Copy files
docker cp myapp:/app/logs ./logs
```

### Compose Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild
docker-compose up -d --build

# Run command in service
docker-compose exec app python manage.py migrate

# Scale service
docker-compose up -d --scale app=3
```

## Optimization

### Image Size

```dockerfile
# Use smaller base images
FROM python:3.11-alpine

# Clean up in same layer
RUN apt-get update && apt-get install -y \
    build-essential \
    && pip install package \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Use .dockerignore
```

### .dockerignore

```
node_modules
npm-debug.log
.git
.env
.env.local
coverage
.nyc_output
*.md
.vscode
.idea
dist
build
```

### Layer Caching

```dockerfile
# Copy dependencies first (cached layer)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy code (changes often)
COPY . .
```

## Security

1. **Don't run as root**
2. **Use specific image tags** (not `latest`)
3. **Scan images for vulnerabilities**
4. **Keep images updated**
5. **Use read-only filesystems**
6. **Limit container resources**

```bash
# Scan image
docker scan myapp:latest

# Run with security options
docker run --read-only --security-opt=no-new-privileges myapp:latest

# Limit resources
docker run --memory=512m --cpus=1.0 myapp:latest
```
