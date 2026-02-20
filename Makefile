# 💰 Infrastructure Cost Tracker - Operations Console

.PHONY: setup lint test monitor-costs clean

# 🏗️ Setup & Environment
setup:
	@echo "Installing dependencies..."
	pip install -e ".[dev]"
	@echo "Ready."

# 🔍 Quality Assurance (TDD)
lint:
	ruff check .
	ruff format --check .
	mypy .

test:
	@echo "🧪 Running Unit Tests..."
	PYTHONPATH=. pytest tests/ -v --cov=cost_tracker

# 💰 Operational Commands
monitor-costs:
	@echo "📊 Monitoring Infrastructure Costs..."
	PYTHONPATH=. python3 scripts/monitor_costs.py

# 🧹 Cleanup
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage .mypy_cache
