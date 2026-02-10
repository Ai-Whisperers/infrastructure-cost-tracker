# TechWithTim OpenClaw Analysis

TechWithTim (Tim Ruscica) brings a **developer-centric** perspective to OpenClaw.

## Key Insights

### 1. Code > Config
Tim typically emphasizes that while "No-Code" is great, the real power of agents like OpenClaw comes when you can write custom scripts.
*   **Insight:** Use OpenClaw's **MCP (Model Context Protocol)** support to write custom Python tools.
*   **Example:** Don't just ask OpenClaw to "check the stock market". Write a Python script that scrapes a specific API and give OpenClaw that tool.

### 2. Infrastructure as Code
Tim advocates for reproducible setups.
*   **Setup:** Use **Docker** to containerize the OpenClaw instance. This ensures that dependencies (like specific Node versions or Python libraries for tools) don't conflict with the host OS.
*   **Tutorial:** Look for his "Dockerizing AI Agents" content.

### 3. The "Orchestrator" Pattern
Tim views the agent as an orchestrator of smaller, specialized scripts.
*   **Strategy:** Build small, reliable Python functions for specific tasks (e.g., `generate_invoice_pdf()`, `send_slack_alert()`).
*   **Role:** OpenClaw just decides *when* to call these functions, rather than trying to do the math/logic itself (which LLMs are bad at).

## Recommended Stack
*   **Language:** Python (for custom tools) + Node.js (for OpenClaw core).
*   **Hosting:** Linode or DigitalOcean (Tim has sponsorships/tutorials for these).
*   **Database:** SQLite (local) or Supabase (cloud) for agent memory.
