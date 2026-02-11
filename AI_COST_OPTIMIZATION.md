# AI Cost Optimization Guide

> **Purpose:** Comprehensive strategies for minimizing AI API costs while maintaining productivity

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Cost Analysis](#cost-analysis)
3. [Model Routing Strategy](#model-routing-strategy)
4. [Caching Strategies](#caching-strategies)
5. [Prompt Optimization](#prompt-optimization)
6. [Implementation](#implementation)
7. [Monitoring & Alerts](#monitoring--alerts)
8. [Tools & Scripts](#tools--scripts)
9. [Best Practices](#best-practices)

---

## 1. Executive Summary

### Key Strategies

| Strategy | Savings | Effort | Implementation |
|----------|---------|--------|----------------|
| **Model Routing** | 60-80% | Medium | Route by task complexity |
| **Prompt Caching** | 50-90% | Low | Cache frequently-used prompts |
| **Batch Processing** | 50% | Low | Use Batch API for non-urgent |
| **Token Optimization** | 20-40% | Medium | Compress inputs/outputs |
| **Context Management** | 30-50% | Medium | Limit context window |

### Target Monthly Costs

| Team Size | Before Optimization | After Optimization | Savings |
|-----------|---------------------|--------------------|---------|
| **Solo** | $300 | $100-150 | 50-67% |
| **3 People** | $1,000 | $300-500 | 50-70% |
| **10 People** | $3,500 | $1,000-1,500 | 57-71% |

---

## 2. Cost Analysis

### API Pricing Comparison

| Provider | Model | Input/MTok | Output/MTok | Notes |
|----------|-------|------------|-------------|-------|
| **Anthropic** | Opus 4.6 | $5.00 | $25.00 | Best quality |
| **Anthropic** | Sonnet 4.5 | $3.00 | $15.00 | Best value |
| **Anthropic** | Haiku 3.5 | $0.80 | $4.00 | 95% cheaper |
| **Anthropic** | Haiku 3 | $0.25 | $1.25 | Cheapest |
| **OpenRouter** | GPT-4o mini | $0.15 | $0.60 | Cheap fallback |
| **OpenRouter** | Kimi K2.5 | ~$0.20 | ~$0.80 | Budget option |
| **Google** | Gemini 2.5 Flash | $0.075 | $0.30 | Free tier available |
| **DeepSeek** | DeepSeek V3 | $0.27 | $1.10 | Good value |

### Cost Breakdown by Task Type

| Task Type | Recommended Model | Cost/Request | % of Tasks |
|-----------|-------------------|--------------|------------|
| **Simple Q&A** | Haiku 3 | $0.001 | 40% |
| **Code Completion** | Haiku 3.5 | $0.005 | 25% |
| **Documentation** | Sonnet 4.5 | $0.02 | 15% |
| **Complex Logic** | Sonnet 4.5 | $0.10 | 15% |
| **Critical Decisions** | Opus 4.6 | $0.50 | 5% |

### Token Estimation

| Task | Input Tokens | Output Tokens | Total |
|------|--------------|---------------|-------|
| **Simple message** | 100 | 200 | 300 |
| **Code review** | 2,000 | 500 | 2,500 |
| **User story** | 500 | 1,000 | 1,500 |
| **Complex analysis** | 5,000 | 3,000 | 8,000 |
| **Full project spec** | 10,000 | 5,000 | 15,000 |

---

## 3. Model Routing Strategy

### Routing Decision Tree

```
                    ┌─────────────────────┐
                    │  User Request       │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Classify Task      │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
     ┌────────▼────────┐ ┌────▼────┐ ┌────────▼────────┐
     │  Simple Query   │ │General  │ │  Complex Task   │
     │  (Q&A, Summarize)│ │Coding   │ │  (Architecture)│
     └────────┬────────┘ └────┬────┘ └────────┬────────┘
              │               │               │
     ┌────────▼────────┐ ┌────▼────┐ ┌────────▼────────┐
     │    Haiku 3      │ │ Haiku   │ │    Sonnet 4.5   │
     │   $0.25/MTok    │ │  3.5    │ │    $3.00/MTok   │
     └─────────────────┘ └────┬────┘ └────────┬────────┘
                              │               │
                              │      ┌───────▼───────┐
                              │      │   Critical?   │
                              │      └───────┬───────┘
                              │              │
                              │     ┌───────▼───────┐
                              │     │   Opus 4.6    │
                              │     │   $5.00/MTok  │
                              │     └───────────────┘
```

### Implementation: Model Router

```python
# model_router.py

from enum import Enum
from typing import Optional
import anthropic

class TaskComplexity(Enum):
    SIMPLE = "simple"
    GENERAL = "general"
    COMPLEX = "complex"
    CRITICAL = "critical"

class ModelRouter:
    MODELS = {
        TaskComplexity.SIMPLE: {
            "name": "claude-haiku-3-20250514",
            "provider": "anthropic",
            "input_cost": 0.25,  # per 1M tokens
            "output_cost": 1.25,
            "max_tokens": 4096,
        },
        TaskComplexity.GENERAL: {
            "name": "claude-haiku-3-5-20250514",
            "provider": "anthropic",
            "input_cost": 0.80,
            "output_cost": 4.00,
            "max_tokens": 8192,
        },
        TaskComplexity.COMPLEX: {
            "name": "claude-sonnet-4-20250514",
            "provider": "anthropic",
            "input_cost": 3.00,
            "output_cost": 15.00,
            "max_tokens": 32000,
        },
        TaskComplexity.CRITICAL: {
            "name": "claude-opus-4-20250514",
            "provider": "anthropic",
            "input_cost": 5.00,
            "output_cost": 25.00,
            "max_tokens": 64000,
        },
    }
    
    def __init__(self, api_key: str):
        self.client = anthropic.Anthropic(api_key=api_key)
    
    def classify_task(self, prompt: str) -> TaskComplexity:
        """Classify task complexity based on prompt analysis."""
        
        # Simple keywords
        simple_keywords = [
            "what is", "define", "explain", "summarize",
            "list", "count", "find", "search"
        ]
        
        # Complex keywords
        complex_keywords = [
            "design", "architecture", "plan", "analyze",
            "compare", "evaluate", "optimize", "create"
        ]
        
        # Critical keywords
        critical_keywords = [
            "critical", "important", "decide", "recommend",
            "security", "production", "migration"
        ]
        
        prompt_lower = prompt.lower()
        
        # Check critical first
        if any(kw in prompt_lower for kw in critical_keywords):
            return TaskComplexity.CRITICAL
        
        # Check complex
        if any(kw in prompt_lower for kw in complex_keywords):
            return TaskComplexity.COMPLEX
        
        # Check simple
        if any(kw in prompt_lower for kw in simple_keywords):
            return TaskComplexity.SIMPLE
        
        return TaskComplexity.GENERAL
    
    async def route_request(
        self,
        prompt: str,
        max_output_tokens: int = 1000,
        use_cache: bool = True,
    ) -> dict:
        """Route request to appropriate model."""
        
        complexity = self.classify_task(prompt)
        model_info = self.MODELS[complexity]
        
        # Check cache if enabled
        if use_cache:
            cached = await self.check_cache(prompt, complexity)
            if cached:
                return {
                    "response": cached,
                    "model": model_info["name"],
                    "cached": True,
                    "estimated_cost": 0,
                }
        
        # Make API call
        response = self.client.messages.create(
            model=model_info["name"],
            max_tokens=max_output_tokens,
            messages=[{"role": "user", "content": prompt}],
        )
        
        # Calculate cost
        input_tokens = response.usage.input_tokens
        output_tokens = response.usage.output_tokens
        cost = (
            (input_tokens / 1_000_000) * model_info["input_cost"] +
            (output_tokens / 1_000_000) * model_info["output_cost"]
        )
        
        # Cache response
        if use_cache:
            await self.cache_response(prompt, complexity, response.content[0].text)
        
        return {
            "response": response.content[0].text,
            "model": model_info["name"],
            "complexity": complexity.value,
            "input_tokens": input_tokens,
            "output_tokens": output_tokens,
            "estimated_cost": cost,
            "cached": False,
        }
```

### Configuration

```yaml
# model-routing.yaml
routing:
  enabled: true
  default_model: "claude-haiku-3-20250514"
  fallback_chain:
    - "claude-haiku-3-20250514"
    - "claude-haiku-3-5-20250514"
    - "claude-sonnet-4-20250514"
    - "claude-opus-4-20250514"

cost_limits:
  daily: 10.00
  monthly: 100.00
  per_request: 2.00

caching:
  enabled: true
  ttl_hours: 24
  max_entries: 10000

complexity_detection:
  keywords:
    simple:
      - "what is"
      - "define"
      - "explain"
      - "summarize"
    complex:
      - "design"
      - "architecture"
      - "analyze"
      - "compare"
    critical:
      - "critical"
      - "security"
      - "production"
```

---

## 4. Caching Strategies

### Prompt Caching (Anthropic)

```python
# prompt_caching.py

class PromptCache:
    def __init__(self, api_key: str):
        self.client = anthropic.Anthropic(api_key=api_key)
        self.cache = {}
        self.cache_ttl = 3600 * 24  # 24 hours
    
    async def get_cached_prompt(
        self,
        system_prompt: str,
        context: str,
    ) -> Optional[str]:
        """Get cached response for system prompt + context."""
        
        cache_key = self._make_cache_key(system_prompt, context)
        
        if cache_key in self.cache:
            entry = self.cache[cache_key]
            if entry["expires"] > time.time():
                return entry["response"]
        
        return None
    
    async def cache_prompt(
        self,
        system_prompt: str,
        context: str,
        response: str,
    ) -> None:
        """Cache response for system prompt + context."""
        
        cache_key = self._make_cache_key(system_prompt, context)
        
        self.cache[cache_key] = {
            "response": response,
            "expires": time.time() + self.cache_ttl,
        }
    
    def _make_cache_key(self, system_prompt: str, context: str) -> str:
        """Create cache key from prompt components."""
        return hashlib.sha256(
            (system_prompt + context).encode()
        ).hexdigest()
```

### Semantic Caching

```python
# semantic_cache.py

import numpy as np
from qdrant_client import QdrantClient
from sentence_transformers import SentenceTransformer

class SemanticCache:
    def __init__(self, qdrant_url: str, api_key: str):
        self.client = QdrantClient(url=qdrant_url, api_key=api_key)
        self.encoder = SentenceTransformer('all-MiniLM-L6-v2')
        self.collection_name = "prompt_cache"
        self.similarity_threshold = 0.95  # 95% similar
    
    async def find_similar(
        self,
        prompt: str,
    ) -> Optional[str]:
        """Find cached response for similar prompt."""
        
        # Encode prompt
        vector = self.encoder.encode(prompt).tolist()
        
        # Search in Qdrant
        results = self.client.search(
            collection_name=self.collection_name,
            query_vector=vector,
            limit=1,
        )
        
        # Check similarity
        if results and results[0].score >= self.similarity_threshold:
            return results[0].payload["response"]
        
        return None
    
    async def cache_response(
        self,
        prompt: str,
        response: str,
    ) -> None:
        """Store prompt and response in semantic cache."""
        
        vector = self.encoder.encode(prompt).tolist()
        
        self.client.upsert(
            collection_name=self.collection_name,
            points=[{
                "id": hash(prompt),
                "vector": vector,
                "payload": {
                    "prompt": prompt,
                    "response": response,
                    "timestamp": time.time(),
                }
            }]
        )
```

---

## 5. Prompt Optimization

### Prompt Compression

```python
# prompt_compression.py

class PromptCompressor:
    def compress(self, prompt: str) -> str:
        """Remove unnecessary elements from prompt."""
        
        # Remove excessive whitespace
        compressed = " ".join(prompt.split())
        
        # Remove redundant phrases
        redundant = [
            "please ",
            "could you ",
            "I need you to ",
            "it would be great if ",
        ]
        
        for phrase in redundant:
            compressed = compressed.replace(phrase, "")
        
        return compressed
    
    def extract_essentials(self, prompt: str) -> str:
        """Extract only essential parts of prompt."""
        
        # Split into sentences
        sentences = prompt.split(".")
        
        # Keep sentences with key information
        important_patterns = [
            r"\b(should|must|need|require)\b",
            r"\b(create|build|write|implement)\b",
            r"\b(include|contain|feature)\b",
        ]
        
        essential = []
        for sentence in sentences:
            for pattern in important_patterns:
                if re.search(pattern, sentence):
                    essential.append(sentence)
                    break
        
        return ".".join(essential)
```

### Context Window Management

```python
# context_manager.py

class ContextManager:
    def __init__(self, max_tokens: int = 32000):
        self.max_tokens = max_tokens
        self.system_prompt_tokens = 2000  # Estimated
    
    def truncate_context(
        self,
        messages: list,
        max_tokens: int = None,
    ) -> list:
        """Truncate messages to fit within context limit."""
        
        max_tokens = max_tokens or self.max_tokens
        available = max_tokens - self.system_prompt_tokens
        
        # Calculate current token count
        total = sum(self._count_tokens(m) for m in messages)
        
        if total <= available:
            return messages
        
        # Truncate from oldest messages
        while total > available and messages:
            removed = messages.pop(0)
            total -= self._count_tokens(removed)
        
        return messages
    
    def summarize_context(
        self,
        messages: list,
        max_tokens: int = 4000,
    ) -> str:
        """Summarize older messages to fit in context."""
        
        # Use AI to summarize
        prompt = f"""
        Summarize the following conversation in {max_tokens} tokens.
        Include key decisions, context, and requirements.
        
        Conversation:
        {messages}
        
        Summary:
        """
        
        # Call AI to summarize (use smallest model)
        response = self.client.messages.create(
            model="claude-haiku-3-20250514",
            max_tokens=1000,
            messages=[{"role": "user", "content": prompt}],
        )
        
        return response.content[0].text
    
    def _count_tokens(self, message: dict) -> int:
        """Count tokens in message (rough estimate)."""
        return len(message.get("content", "")) // 4
```

---

## 6. Implementation

### Docker Compose for Cost Optimization Services

```yaml
# docker-compose.cost-optimization.yml

version: '3.8'

services:
  model-router:
    build: ./services/model-router
    ports:
      - "3001:3001"
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
      - QDRANT_URL=http://qdrant:6333
      - REDIS_URL=redis://redis:6379
    depends_on:
      - qdrant
      - redis
    volumes:
      - ./config/model-routing.yaml:/app/config.yaml
    restart: unless-stopped

  prompt-cache:
    build: ./services/prompt-cache
    ports:
      - "3002:3002"
    environment:
      - QDRANT_URL=http://qdrant:6333
      - REDIS_URL=redis://redis:6379
    depends_on:
      - qdrant
      - redis
    restart: unless-stopped

  cost-monitor:
    build: ./services/cost-monitor
    ports:
      - "3003:3003"
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
      - SLACK_WEBHOOK_URL=${SLACK_WEBHOOK_URL}
      - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
      - TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
    volumes:
      - ./config/cost-limits.yaml:/app/config.yaml
    restart: unless-stopped

  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_data:/qdrant/storage
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

volumes:
  qdrant_data:
  redis_data:

networks:
  default:
    name: ai-startup-network
```

### Cost Monitoring Dashboard

```yaml
# grafana/dashboards/cost-dashboard.yml

apiVersion: 1

providers:
  - name: 'Cost Dashboard'
    orgId: 1
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /grafana/dashboards

dashboards:
  - folder: ''
    name: AI Cost Monitoring
    url: https://grafana.com/grafana/dashboards/12345
```

---

## 7. Monitoring & Alerts

### Cost Alert Configuration

```yaml
# cost-alerts.yaml

alerts:
  - name: Daily Cost Warning
    condition: daily_cost > 5.00
    severity: warning
    channels:
      - slack
      - telegram
    message: |
      🚨 Daily AI cost warning: ${{ daily_cost }}
      Limit: $5.00
      Current: ${{ daily_cost }}

  - name: Daily Cost Critical
    condition: daily_cost > 10.00
    severity: critical
    channels:
      - slack
      - telegram
      - email
    message: |
      🔥 CRITICAL: Daily AI cost exceeded $10!
      Current: ${{ daily_cost }}
      Immediate action required.

  - name: Monthly Cost Warning
    condition: monthly_cost > 50.00
    severity: warning
    channels:
      - slack
      - telegram
    message: |
      📊 Monthly AI cost warning: ${{ monthly_cost }}
      Budget: $100.00
      50% of budget used.

  - name: Unusual Spike
    condition: hour_cost > average_hour_cost * 3
    severity: warning
    channels:
      - slack
      - telegram
    message: |
      📈 Unusual AI cost spike detected!
      This hour: ${{ hour_cost }}
      Average: ${{ average_hour_cost }}
```

### Alert Script

```bash
#!/bin/bash
# alert-on-cost.sh

DAILY_LIMIT=10.00
MONTHLY_LIMIT=100.00

# Get current costs from OpenRouter API
DAILY_COST=$(curl -s \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  https://openrouter.ai/api/costs | jq '.daily_cost')

if (( $(echo "$DAILY_COST > $DAILY_LIMIT" | bc -l) )); then
    # Send Telegram alert
    curl -s -X POST \
      "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
      -d chat_id="$TELEGRAM_CHAT_ID" \
      -d text="🚨 AI Cost Alert: Daily cost $${DAILY_COST} exceeds $${DAILY_LIMIT}"
    
    # Send Slack alert
    curl -s -X POST \
      -H "Content-type: application/json" \
      --data "{\"text\":\"🚨 AI Cost Alert: Daily cost $${DAILY_COST} exceeds $${DAILY_LIMIT}\"}" \
      "$SLACK_WEBHOOK_URL"
fi
```

---

## 8. Tools & Scripts

### Daily Cost Report Script

```bash
#!/bin/bash
# daily-cost-report.sh

echo "========================================"
echo "AI Cost Report - $(date +%Y-%m-%d)"
echo "========================================"
echo ""

# Anthropic costs
echo "Anthropic API Usage:"
ANTHROPIC_COST=$(curl -s \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  "https://api.anthropic.com/v1/costs" | jq '.total_cost')

echo "  Anthropic: $${ANTHROPIC_COST}"
echo ""

# OpenRouter costs
echo "OpenRouter API Usage:"
OPENROUTER_COST=$(curl -s \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  "https://openrouter.ai/api/costs" | jq '.total_cost')

echo "  OpenRouter: $${OPENROUTER_COST}"
echo ""

# Total
TOTAL=$(echo "$ANTHROPIC_COST + $OPENROUTER_COST" | bc)
echo "========================================"
echo "TOTAL DAILY COST: $${TOTAL}"
echo "========================================"

# Budget check
BUDGET=10.00
if (( $(echo "$TOTAL > $BUDGET" | bc -l) )); then
    echo ""
    echo "⚠️  WARNING: Daily cost exceeds budget of $${BUDGET}!"
fi
```

### Cost Optimization Report Generator

```python
# generate-cost-report.py

import json
from datetime import datetime, timedelta

class CostReportGenerator:
    def __init__(self, anthropic_key: str, openrouter_key: str):
        self.anthropic_key = anthropic_key
        self.openrouter_key = openrouter_key
    
    async def generate_report(self, days: int = 30) -> dict:
        """Generate comprehensive cost report."""
        
        report = {
            "period": {
                "start": (datetime.now() - timedelta(days=days)).isoformat(),
                "end": datetime.now().isoformat(),
            },
            "total_cost": 0,
            "by_provider": {},
            "by_model": {},
            "optimization_opportunities": [],
        }
        
        # Collect Anthropic costs
        anthropic_costs = await self.get_anthropic_costs(days)
        report["by_provider"]["anthropic"] = anthropic_costs
        report["total_cost"] += anthropic_costs["total"]
        
        # Collect OpenRouter costs
        openrouter_costs = await self.get_openrouter_costs(days)
        report["by_provider"]["openrouter"] = openrouter_costs
        report["total_cost"] += openrouter_costs["total"]
        
        # Analyze optimization opportunities
        report["optimization_opportunities"] = self.analyze_opportunities(
            anthropic_costs,
            openrouter_costs,
        )
        
        return report
    
    async def get_anthropic_costs(self, days: int) -> dict:
        """Get costs from Anthropic API."""
        # Implementation here
        return {
            "total": 0,
            "by_model": {},
            "daily_breakdown": [],
        }
    
    async def get_openrouter_costs(self, days: int) -> dict:
        """Get costs from OpenRouter API."""
        # Implementation here
        return {
            "total": 0,
            "by_model": {},
            "daily_breakdown": [],
        }
    
    def analyze_opportunities(
        self,
        anthropic_costs: dict,
        openrouter_costs: dict,
    ) -> list:
        """Analyze costs for optimization opportunities."""
        
        opportunities = []
        
        # Check if Haiku is being used enough
        if anthropic_costs.get("by_model", {}).get("opus", 0) > 50:
            opportunities.append({
                "type": "model_routing",
                "description": "Consider routing more simple tasks to Haiku to save up to 90%",
                "potential_savings": "Up to $50/month",
                "action": "Review task classification logic",
            })
        
        # Check cache hit rate
        opportunities.append({
            "type": "caching",
            "description": "Enable prompt caching for frequently used system prompts",
            "potential_savings": "50-90% on repeated contexts",
            "action": "Implement PromptCache class",
        })
        
        return opportunities
```

---

## 9. Best Practices

### Daily Operations

1. **Morning Cost Check**
   ```bash
   ./daily-cost-report.sh
   ```

2. **Review High-Cost Requests**
   - Identify most expensive API calls
   - Look for optimization opportunities

3. **Monitor Cache Performance**
   - Track cache hit rate (target: 30%+)
   - Adjust TTL based on usage patterns

### Weekly Operations

1. **Generate Cost Report**
   ```bash
   python generate-cost-report.py --days 7
   ```

2. **Review Model Usage**
   - Check if routing is working effectively
   - Adjust routing rules as needed

3. **Optimize Prompts**
   - Review prompts for efficiency
   - Remove unnecessary tokens

### Monthly Operations

1. **Comprehensive Cost Review**
   - Analyze trends
   - Adjust budgets
   - Plan optimizations

2. **Model Pricing Updates**
   - Check for API pricing changes
   - Update routing accordingly

3. **Capacity Planning**
   - Estimate future costs
   - Adjust team size or usage

---

## Quick Reference

### Cost Optimization Checklist

- [ ] Implement model routing (60-80% savings)
- [ ] Enable prompt caching (50-90% savings)
- [ ] Use Batch API for non-urgent tasks (50% savings)
- [ ] Optimize prompts (20-40% savings)
- [ ] Set up cost alerts
- [ ] Monitor cache performance
- [ ] Review daily/weekly/monthly
- [ ] Adjust budgets quarterly

### Key Metrics to Track

| Metric | Target | Alert If |
|--------|--------|----------|
| **Daily Cost** | < $10 | > $10 |
| **Cache Hit Rate** | > 30% | < 10% |
| **Haiku Usage %** | > 50% | < 30% |
| **Average Cost/Request** | < $0.05 | > $0.10 |
| **Total Tokens/Day** | < 100K | > 500K |

---

**Document Information**
- Created: February 2026
- Version: 1.0
- Status: Production Ready
