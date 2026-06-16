#!/usr/bin/env bash
# Hermes Agent Frameworks — One-line installer
# Usage: curl -sSL https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main/install.sh | bash
set -e

REPO="https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main"
HERMES_SKILLS="${HERMES_HOME:-$HOME/.hermes}/skills"

echo "==> Hermes Agent Frameworks Installer"
echo "    Target: $HERMES_SKILLS"
echo ""

install_skill() {
  local name="$1"
  local dest="$HERMES_SKILLS/$name"

  if [ -d "$dest" ]; then
    echo "  ⚠  $name already exists, skipping"
    return
  fi

  echo "  → Installing $name..."

  # Create directory structure
  mkdir -p "$dest"/{references,scripts,assets}

  # Download SKILL.md
  curl -sSL --connect-timeout 10 --max-time 30 \
    "$REPO/$name/SKILL.md" -o "$dest/SKILL.md"

  # Download README.md (if exists)
  curl -sSL --connect-timeout 10 --max-time 15 \
    "$REPO/$name/README.md" -o "$dest/README.md" 2>/dev/null || true

  echo "  ✓ $name installed"
}

# Install all frameworks
install_skill "vault-external-brain"
install_skill "hermes-agent-onboarding-guide"

echo ""
echo "==> Done! Load a framework in Hermes with:"
echo "    skill_view(name='vault-external-brain')"
echo "    skill_view(name='hermes-agent-onboarding-guide')"
