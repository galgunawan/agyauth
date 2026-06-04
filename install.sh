#!/bin/bash
# install.sh — One-line installer for agyauth
# Usage: curl -fsSL https://raw.githubusercontent.com/galgunawan/agyauth/main/install.sh | bash

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

REPO="https://raw.githubusercontent.com/galgunawan/agyauth/main"
INSTALL_DIR="/usr/local/bin"

echo ""
echo -e "${CYAN}${BOLD}╭──────────────────────────────────────────╮${NC}"
echo -e "${CYAN}${BOLD}│              agyauth Installer           │${NC}"
echo -e "${CYAN}${BOLD}│  Multi-Account Manager for Antigravity   │${NC}"
echo -e "${CYAN}${BOLD}╰──────────────────────────────────────────╯${NC}"
echo ""

# Cek dependencies
echo -e "${YELLOW}▶ Checking dependencies...${NC}"

MISSING=0

if ! command -v bash &>/dev/null; then
    echo -e "  ${RED}✗ bash not found${NC}"; MISSING=1
else
    echo -e "  ${GREEN}✓ bash${NC}"
fi

if ! command -v jq &>/dev/null; then
    echo -e "  ${YELLOW}⚠ jq not found — installing...${NC}"
    if command -v apt-get &>/dev/null; then
        apt-get install -y jq -qq
    elif command -v yum &>/dev/null; then
        yum install -y jq -q
    else
        echo -e "  ${RED}✗ Cannot auto-install jq. Please install it manually: https://jqlang.github.io/jq/${NC}"
        exit 1
    fi
    echo -e "  ${GREEN}✓ jq installed${NC}"
else
    echo -e "  ${GREEN}✓ jq${NC}"
fi

if ! command -v agy &>/dev/null; then
    echo -e "  ${YELLOW}⚠ 'agy' (Antigravity CLI) not found.${NC}"
    echo -e "    agyauth requires Antigravity CLI to function."
    echo -e "    Install it from: https://github.com/google-gemini/antigravity"
else
    echo -e "  ${GREEN}✓ agy (Antigravity CLI)${NC}"
fi

echo ""
echo -e "${YELLOW}▶ Downloading scripts...${NC}"

SCRIPTS=("agyauth" "agy-setup" "agy-new")

for script in "${SCRIPTS[@]}"; do
    curl -fsSL "$REPO/scripts/$script" -o "$INSTALL_DIR/$script"
    chmod +x "$INSTALL_DIR/$script"
    echo -e "  ${GREEN}✓ $script → $INSTALL_DIR/$script${NC}"
done

echo ""
echo -e "${GREEN}${BOLD}╭──────────────────────────────────────────╮${NC}"
echo -e "${GREEN}${BOLD}│         ✔ Installation Complete!         │${NC}"
echo -e "${GREEN}${BOLD}╰──────────────────────────────────────────╯${NC}"
echo ""
echo -e "${BOLD}Commands installed:${NC}"
echo -e "  ${CYAN}agyauth${NC}    — Interactive TUI account manager"
echo -e "  ${CYAN}agy-setup${NC}  — First-time migration to multi-account structure"
echo -e "  ${CYAN}agy-new${NC}    — Add a new isolated Antigravity account"
echo ""
echo -e "${BOLD}Quick start:${NC}"
echo -e "  ${YELLOW}Step 1:${NC} ${CYAN}agy-setup${NC}   ← Run once to migrate existing account"
echo -e "  ${YELLOW}Step 2:${NC} ${CYAN}agyauth${NC}     ← Open the account manager"
echo ""
