# Architecture — agyauth Symlink Design

## Overview

agyauth uses a **symlink-based isolation architecture** to achieve two goals:

1. **Security isolation** — each account has a unique `installation_id` and OAuth token, appearing as a separate device to Google's servers.
2. **Shared context** — history, conversations, settings, and knowledge base are shared via filesystem symlinks.

## Directory Structure

```
~/.gemini/
│
├── agy-shared/                    ← Central shared data (all accounts read from here)
│   ├── history.jsonl
│   ├── conversations/
│   ├── settings.json
│   ├── knowledge/
│   ├── brain/
│   ├── keybindings.json
│   ├── implicit/
│   ├── cache/
│   ├── bin/
│   ├── updater/
│   └── packages/
│
├── agy-utama/                     ← Account 1 (isolated)
│   ├── antigravity-oauth-token    ← UNIQUE OAuth token
│   ├── installation_id            ← UNIQUE UUID
│   ├── log/                       ← per-account logs
│   ├── history.jsonl ─────────────→ symlink → agy-shared/
│   ├── conversations/ ────────────→ symlink → agy-shared/
│   ├── settings.json ─────────────→ symlink → agy-shared/
│   └── ...
│
├── agy-akun2/                     ← Account 2 (isolated)
│   ├── antigravity-oauth-token    ← UNIQUE (different Google account)
│   ├── installation_id            ← UNIQUE (different UUID = different device)
│   └── ... (same symlink structure)
│
└── antigravity-cli/               ← SYMLINK → currently active account directory
```

## Switching Mechanism

```bash
# Switch is just a symlink redirect — instant and atomic
rm ~/.gemini/antigravity-cli
ln -sf ~/.gemini/agy-akun2 ~/.gemini/antigravity-cli
```

The `agy` binary always reads from `~/.gemini/antigravity-cli/` — completely unaware of the underlying structure.

## Shared vs Isolated

### Shared (symlinks → agy-shared/)
- `history.jsonl` — conversation history
- `conversations/` — saved sessions
- `settings.json` — preferences
- `knowledge/` — knowledge base
- `brain/` — agent memory
- `cache/` — model cache

### Isolated (per account directory)
- `antigravity-oauth-token` — Google OAuth credentials
- `installation_id` — unique device UUID
- `log/` — per-session logs
