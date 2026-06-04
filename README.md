# agyauth

> **Multi-account manager for Antigravity CLI** — Interactive TUI with isolated accounts, shared history, and instant switching without logout.

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

---

## ✨ What is this?

**agyauth** lets you manage multiple Antigravity (`agy`) accounts on a single machine — switching instantly between them without ever doing `logout` → `login` again.

```
╭─────────────────────────────────────────────────────────╮
│             ⚡ ANTIGRAVITY ACCOUNT MANAGER              │
│     Multi-Account · Symlink Architecture · Isolated IDs │
╰─────────────────────────────────────────────────────────╯

  Account      ···· utama
  Install ID   ···· a1b2c3d4...
  Token Expiry ···· 04 Jun 2026 22:00 WIB  ✓
  Total Accts  ···· 3 account(s)
  Shared Data  ···· ~/.gemini/agy-shared/

  ❯  🔄  Switch Account
     ➕  Create New Account
     📋  List All Accounts
     🗑️   Delete Account
     ❌  Exit
```

---

## 🔒 Safe Multi-Account by Design

Simply swapping the OAuth token between accounts is risky — Google's servers detect the same `installation_id` being used across multiple accounts (same device fingerprint).

**agyauth uses a symlink architecture** that gives each account its own unique `installation_id`, making each account look like a completely separate device:

| Signal | Naive token swap | **agyauth approach** |
|--------|-----------------|---------------------|
| OAuth Token | ✅ Different | ✅ Different |
| `installation_id` | ❌ Same (risky!) | ✅ Unique per account |
| History & Config | ❌ Lost on switch | ✅ Shared via symlink |
| Appearance to Google | Same device | **Different devices** |

### How it works

```
~/.gemini/
├── agy-shared/           ← shared by ALL accounts (history, settings, etc.)
├── agy-utama/            ← Account 1
│   ├── antigravity-oauth-token   ← UNIQUE token
│   ├── installation_id           ← UNIQUE UUID (new device fingerprint)
│   ├── history.jsonl ────────────→ symlink → agy-shared/
│   ├── conversations/ ───────────→ symlink → agy-shared/
│   └── settings.json ────────────→ symlink → agy-shared/
├── agy-akun2/            ← Account 2 (different token + different UUID)
└── antigravity-cli/      ← symlink → currently active account
```

---

## 📦 Installation

### One-line install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/galgunawan/agyauth/main/install.sh | bash
```

### Manual install

```bash
git clone https://github.com/galgunawan/agyauth.git
cd agyauth
sudo cp scripts/agyauth scripts/agy-setup scripts/agy-new /usr/local/bin/
sudo chmod +x /usr/local/bin/agyauth /usr/local/bin/agy-setup /usr/local/bin/agy-new
```

### Requirements

| Tool | Install |
|------|---------|
| `bash` | Pre-installed on Linux |
| `jq` | `apt install jq` / `yum install jq` |
| `agy` | Antigravity CLI |

---

## 🚀 Getting Started

### Step 1 — First-time setup (run once)

```bash
agy-setup
```

This migrates your existing Antigravity account into the multi-account structure. You'll be asked to name your current account (e.g. `utama`). The script will:

- Move shared data to `~/.gemini/agy-shared/`
- Create `~/.gemini/agy-utama/` with your current token + a **new unique** `installation_id`
- Set up all symlinks automatically
- Create a wrapper command `agy-utama`

### Step 2 — Open the manager

```bash
agyauth
```

Navigate with `↑↓` (or `j`/`k`), select with `Enter`, quit with `q`.

### Step 3 — Add a second account

Inside `agyauth`, choose **➕ Create New Account**, or run:

```bash
agy-new akun2
```

This creates:
- `~/.gemini/agy-akun2/` with a brand-new randomly generated `installation_id`
- A wrapper command `agy-akun2`
- All symlinks to shared data already set up

### Step 4 — Login to the new account

```bash
agy-akun2
# Google OAuth login prompt appears for the new account
```

### Step 5 — Switch anytime

```bash
agyauth
# Navigate to: 🔄 Switch Account → select target → Enter
```

> ✅ History and config are always shared. Switching accounts never loses context.

---

## 📖 Commands

| Command | Description |
|---------|-------------|
| `agyauth` | Open interactive account manager |
| `agy-setup` | First-time migration (run once) |
| `agy-new <name>` | Create a new isolated account |
| `agy-<name>` | Switch to and launch a specific account |

---

## ⌨️ Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `↑` / `k` | Move up |
| `↓` / `j` | Move down |
| `Enter` | Select |
| `q` / `Q` | Quit / Cancel |

---

## 📁 Project Structure

```
agyauth/
├── README.md
├── install.sh              ← one-line installer
├── LICENSE
├── scripts/
│   ├── agyauth             ← main interactive TUI manager
│   ├── agy-setup           ← first-time migration script
│   └── agy-new             ← add new account script
└── docs/
    └── architecture.md     ← technical details of symlink design
```

---

## 🛠️ Uninstall

```bash
sudo rm -f /usr/local/bin/agyauth /usr/local/bin/agy-setup /usr/local/bin/agy-new

# To also remove all account data (WARNING: deletes tokens and history):
# rm -rf ~/.gemini/agy-*
```

---

## 📄 License

MIT — free to use, modify, and distribute.
