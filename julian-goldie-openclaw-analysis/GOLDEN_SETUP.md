# The Golden Setup: Best & Cheapest OpenClaw Infrastructure

This guide synthesizes insights from multiple experts (Julian Goldie, Wes Roth, TechWithTim, David Ondrej) to provide the **optimal balance of performance and cost**.

## The "90% Cheaper" Strategy

To achieve the "90%" efficiency often cited in clickbait titles, you must optimize three layers: **Compute**, **Connectivity**, and **Intelligence**.

### 1. Compute Layer (The Host)

**Winner: Oracle Cloud Free Tier OR Hetzner Cloud**

*   **Oracle Cloud (ARM Ampere):**
    *   **Cost:** $0.00/month (Always Free).
    *   **Specs:** Up to 4 OCPUs and 24GB RAM (ARM-based).
    *   **Pros:** Absolutely free, powerful enough for Node.js + Browser automation.
    *   **Cons:** Hard to get an account (region availability).
    *   **Note:** OpenClaw runs fine on ARM64 (Raspberry Pi compatible), so it works here.

*   **Hetzner (CPX11):**
    *   **Cost:** ~€4/month.
    *   **Specs:** 2 vCPU, 4GB RAM (x86).
    *   **Pros:** extremely reliable, cheap, fast networking in Europe/US.
    *   **Cons:** Not free.

*   **Avoid:** AWS EC2 (t2.micro/t3.micro) *after* the 12-month free tier expires, as it becomes expensive for what it is.

### 2. Connectivity Layer (Access)

**Winner: Tailscale (Free)**

Do not pay for static IPs or complex VPNs.
1.  Install **Tailscale** on the VPS.
2.  Install **Tailscale** on your Phone/Laptop.
3.  Bind OpenClaw: `openclaw gateway --bind tailnet`.
4.  **Result:** Secure, encrypted, free access from anywhere.

### 3. Intelligence Layer (Models)

**Winner: Anthropic Haiku + Sonnet (Tiered)**

Don't use Opus for everything.
*   **Claude 3 Haiku:** Use for summarizing emails, reading web pages, formatting text. (Cost: negligible).
*   **Claude 3.5 Sonnet:** Use for coding, complex reasoning, and planning.
*   **Config:** Set up your default model to Haiku, and specific "Smart" skills to use Sonnet.

## The Complete Setup Script

```bash
# 1. Provision Ubuntu 22.04 on Oracle/Hetzner
# 2. Secure the server
ufw allow ssh
ufw enable

# 3. Install Node.js 20 (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential

# 4. Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# 5. Install OpenClaw
npm install -g openclaw

# 6. Run as Service (PM2)
sudo npm install -g pm2
pm2 start openclaw --name "agent" -- gateway --bind tailnet
pm2 save
pm2 startup
```

## "Cheapest" vs "Best" Tradeoffs

| Feature | Cheapest (Free) | Best (Reliable) |
|---------|-----------------|-----------------|
| **Host** | Oracle Free Tier | Hetzner CPX21 (€8/mo) |
| **Model** | Haiku Only | Sonnet 3.5 |
| **Backup**| None | Daily Snapshots (€1/mo) |
| **TOTAL** | **$0/mo + API** | **~$10/mo + API** |
