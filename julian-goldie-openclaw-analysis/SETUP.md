# Setup Guide (Julian Goldie Method)

Julian Goldie advocates for a **cloud-hosted** or **dedicated hardware** approach to ensure the agent is truly 24/7.

## 1. Hosting Options

### Option A: VPS (Recommended for Reliability)
Julian often suggests using a VPS (Virtual Private Server) so the bot never sleeps, even if your laptop does.
*   **Provider**: AWS EC2 (Free Tier eligible instances like `t2.micro` or `t3.micro`) or DigitalOcean/Hetzner.
*   **OS**: Ubuntu Linux (LTS version).
*   **Cost**: Free to ~$5/month.

### Option B: Local Dedicated Hardware
*   **Hardware**: Raspberry Pi 4/5 or an old Mac Mini.
*   **Benefit**: No monthly cloud bill, complete physical control.
*   **Drawback**: Requires configuring local network / Tailscale for remote access.

## 2. The "Onboarding" Flow

Julian's newer videos likely align with the modern `openclaw` CLI wizard, which simplifies the process significantly compared to earlier manual setups.

### Step-by-Step

1.  **Connect to Server**: SSH into your VPS.
    ```bash
    ssh user@your-vps-ip
    ```

2.  **Install Node.js**: Ensure Node.js (v18+) is installed.
    ```bash
    # Example for Ubuntu
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    ```

3.  **Install OpenClaw**:
    ```bash
    npm install -g openclaw
    ```

4.  **Run the Wizard**:
    This is the "magic" step he emphasizes for ease of use.
    ```bash
    openclaw onboard
    ```
    *   **API Keys**: Have your Anthropic API Key ready.
    *   **Channels**: Select WhatsApp or Telegram (his favorites for mobile access).

## 3. Connectivity (The "Tailscale" Trick)

For local setups (Option B), Julian and the OpenClaw community often recommend **Tailscale**.
*   **Why?** It exposes your local bot to the internet (securely) so you can talk to it from your phone when you're not at home.
*   **Command**: `openclaw gateway --bind tailnet` (or configuring Tailscale separately).

## 4. "Must-Have" Configuration

*   **Model Selection**: He typically recommends **Claude 3.5 Sonnet** for the balance of speed and intelligence, or **Opus** for complex reasoning tasks.
*   **System Prompt**: He often customizes the "Persona" to be more proactive (e.g., "You are my Operations Manager...").
