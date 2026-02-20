import json
from pathlib import Path
from scripts.monitor_costs import load_cost_config, CostLimit


def test_load_cost_config(tmp_path: Path) -> None:
    """Verify that the cost config is correctly loaded and parsed using Pydantic."""
    config_file = tmp_path / "cost-limits.json"
    data = {
        "limits": {
            "daily": {
                "amount": 10.0,
                "currency": "USD",
                "action": "warn",
                "notification": "telegram",
            },
            "monthly": {
                "amount": 100.0,
                "currency": "USD",
                "action": "throttle",
                "notification": "telegram",
            },
            "perRequest": {"amount": 2.0, "currency": "USD", "action": "confirm"},
        },
        "notifications": {
            "enabled": True,
            "thresholds": [50, 75, 90, 100],
            "channels": ["telegram"],
        },
        "tracking": {"enabled": True, "logFile": "~/.openclaw/logs/costs.log"},
    }
    config_file.write_text(json.dumps(data))

    config = load_cost_config(str(config_file))

    assert config.limits["daily"].amount == 10.0
    assert config.limits["monthly"].action == "throttle"
    assert config.notifications["enabled"] is True
    assert config.tracking["enabled"] is True


def test_cost_limit_pydantic_validation() -> None:
    """Verify that Pydantic correctly validates a CostLimit object."""
    limit = CostLimit(amount=5.0, currency="USD", action="warn")
    assert limit.amount == 5.0
    assert limit.currency == "USD"
    assert limit.action == "warn"
    assert limit.notification == "none"
