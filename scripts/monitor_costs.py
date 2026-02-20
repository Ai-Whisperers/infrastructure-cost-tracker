#!/usr/bin/env python3
import json
import os
import os
import sys
from typing import Dict, Any
from pydantic import BaseModel


class CostLimit(BaseModel):
    amount: float
    currency: str
    action: str
    notification: str = "none"


class CostConfig(BaseModel):
    limits: Dict[str, CostLimit]
    notifications: Dict[str, Any]
    tracking: Dict[str, Any]


def load_cost_config(path: str) -> CostConfig:
    with open(path, "r") as f:
        data = json.load(f)
        return CostConfig(**data)


def fetch_actual_costs() -> Dict[str, float]:
    """
    Fetch actual costs from Helicone or OpenRouter API.
    In production, this would use actual API keys.
    """
    # Placeholder for actual API call
    # e.g., curl https://api.helicone.ai/v1/costs -H "Authorization: Bearer $HELICONE_API_KEY"
    return {"daily": 3.42, "monthly": 24.18}


def monitor_costs() -> None:
    print("📊 [INFRA-COST-TRACKER] Monitoring Infrastructure Costs...")

    config_path = "openclaw-config/cost-limits.json"
    if not os.path.exists(config_path):
        print(f"❌ Error: Config not found at {config_path}")
        sys.exit(1)

    config = load_cost_config(config_path)
    actuals = fetch_actual_costs()

    over_limit = False

    # Check Daily
    if "daily" in config.limits:
        limit = config.limits["daily"]
        actual = actuals["daily"]
        print(f"📅 Daily:  ${actual:.2f} / ${limit.amount:.2f}")
        if actual > limit.amount:
            print(f"🚨 ALERT: Daily limit exceeded! Action: {limit.action}")
            over_limit = True

    # Check Monthly
    if "monthly" in config.limits:
        limit = config.limits["monthly"]
        actual = actuals["monthly"]
        print(f"🗓️  Monthly: ${actual:.2f} / ${limit.amount:.2f}")
        if actual > limit.amount:
            print(f"🚨 ALERT: Monthly limit exceeded! Action: {limit.action}")
            over_limit = True

    if not over_limit:
        print("✅ Costs are within defined limits.")
    else:
        sys.exit(1)


if __name__ == "__main__":
    monitor_costs()
