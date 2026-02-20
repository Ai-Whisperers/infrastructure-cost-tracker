# 💰 AI Infrastructure Cost Tracker

Centralized monitoring and management for AI infrastructure spend across the OpenClaw ecosystem.

---

## 🚀 Features
- **Strict Configuration**: Uses Pydantic for validated cost limit definitions (`cost-limits.json`).
- **Automated Monitoring**: Python-based tracker (`scripts/monitor_costs.py`) for daily and monthly budget enforcement.
- **Hub Integration**: Seamlessly plugs into the OpenClaw Operations Hub's quality gates.
- **Production Ready**: Full TDD suite, linting, and type checking.

---

## 🛠️ Quick Start

### 1. Installation
```bash
make setup
```

### 2. Configuration
Edit `openclaw-config/cost-limits.json` to define your budget:
```json
{
  "limits": {
    "daily": { "amount": 10.00, "currency": "USD", "action": "warn" },
    "monthly": { "amount": 100.00, "currency": "USD", "action": "throttle" }
  }
}
```

### 3. Run Monitor
```bash
make monitor-costs
```

---

## 🧪 Quality Assurance
We maintain "Serious Company" standards for infrastructure code:
- **Linting**: `make lint` (Ruff + Mypy)
- **Testing**: `make test` (Pytest)

---

## 🛰️ Ecosystem Integration
This repository is used by the **OpenClaw Operations Hub** to perform cluster-wide cost audits before deployments and during 24/7 agent operations.

---
[Repository Navigation](./README_NAVIGATION.md)
