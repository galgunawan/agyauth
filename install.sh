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

# Cek apakah perlu sudo
if [ "$EUID" -ne 0 ]; then
    if command -v sudo &>/dev/null; then
        SUDO="sudo"
        echo -e "${YELLOW}ℹ Running as non-root, using sudo...${NC}"
        echo ""
    else
        # Fallback ke ~/.local/bin jika tidak ada sudo
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        SUDO=""
        echo -e "${YELLOW}ℹ No sudo found, installing to $INSTALL_DIR${NC}"
        echo -e "${YELLOW}  Make sure $INSTALL_DIR is in your PATH${NC}"
        echo ""
    fi
else
    SUDO=""
fi

# Cek dependencies
echo -e "${YELLOW}▶ Checking dependencies...${NC}"

if ! command -v bash &>/dev/null; then
    echo -e "  ${RED}✗ bash not found${NC}"
else
    echo -e "  ${GREEN}✓ bash${NC}"
fi

if ! command -v jq &>/dev/null; then
    echo -e "  ${YELLOW}⚠ jq not found — installing...${NC}"
    if command -v apt-get &>/dev/null; then
        $SUDO apt-get install -y jq -qq
    elif command -v yum &>/dev/null; then
        $SUDO yum install -y jq -q
    else
        echo -e "  ${RED}✗ Cannot auto-install jq. Please install manually.${NC}"
        exit 1
    fi
    echo -e "  ${GREEN}✓ jq installed${NC}"
else
    echo -e "  ${GREEN}✓ jq${NC}"
fi

if ! command -v agy &>/dev/null; then
    echo -e "  ${YELLOW}⚠ 'agy' (Antigravity CLI) not found.${NC}"
    echo -e "    agyauth will be installed, but you need Antigravity CLI to use it."
    echo -e "    Download from: https://antigravity.dev"
    echo ""
else
    echo -e "  ${GREEN}✓ agy (Antigravity CLI)${NC}"
fi

echo ""
echo -e "${YELLOW}▶ Downloading scripts...${NC}"

SCRIPTS=("agyauth" "agy-setup" "agy-new")

for script in "${SCRIPTS[@]}"; do
    TMP=$(mktemp /tmp/agyauth-XXXXXX)
    curl -fsSL "$REPO/scripts/$script" -o "$TMP"
    $SUDO mv "$TMP" "$INSTALL_DIR/$script"
    $SUDO chmod +x "$INSTALL_DIR/$script"
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
