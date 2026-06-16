#!/usr/bin/env bash
# Hermes Agent Frameworks — One-line installer
# Usage:
#   Install all:     curl -sSL https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main/install.sh | bash
#   Install one:     SKILL=vault-external-brain curl -sSL ... | bash
#   Install custom:  SKILLS="vault-external-brain,onboarding-guide" curl -sSL ... | bash
set -e

REPO="https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main"
HERMES_SKILLS="${HERMES_HOME:-$HOME/.hermes}/skills"

# Parse which skills to install
if [ -n "$SKILLS" ]; then
  IFS=',' read -ra SKILL_LIST <<< "$SKILLS"
elif [ -n "$SKILL" ]; then
  SKILL_LIST=("$SKILL")
else
  # Install all by default
  SKILL_LIST=("vault-external-brain" "hermes-agent-onboarding-guide")
fi

echo "==> Hermes Agent Frameworks Installer"
echo "    Target: $HERMES_SKILLS"
echo "    Skills: ${SKILL_LIST[*]}"
echo ""

install_skill() {
  local name="$1"
  local dest="$HERMES_SKILLS/$name"

  if [ -d "$dest" ]; then
    echo "  ⚠  $name already exists, skipping"
    return
  fi

  echo "  → Installing $name..."

  mkdir -p "$dest"/{references,scripts,assets}

  curl -sSL --connect-timeout 10 --max-time 30 \
    "$REPO/$name/SKILL.md" -o "$dest/SKILL.md"

  curl -sSL --connect-timeout 10 --max-time 15 \
    "$REPO/$name/README.md" -o "$dest/README.md" 2>/dev/null || true

  echo "  ✓ $name installed"
}

for skill in "${SKILL_LIST[@]}"; do
  install_skill "$skill"
done

echo ""
echo "==> Done!"
for skill in "${SKILL_LIST[@]}"; do
  echo "    skill_view(name='$skill')"
done
