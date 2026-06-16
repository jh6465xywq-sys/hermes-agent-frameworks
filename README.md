# Hermes Agent Frameworks

Reusable, production-tested frameworks for [Hermes Agent](https://hermes-agent.nousresearch.com/). No personal info — drop-in ready.

## What's Inside

| Framework | Description |
|-----------|-------------|
| [vault-external-brain](./vault-external-brain/) | Shared Obsidian vault as multi-agent external brain — memory distillation, handover protocol, writing conventions |
| [hermes-agent-onboarding-guide](./hermes-agent-onboarding-guide/) | Systematic onboarding — environment probe, user profile, skill selection, model tiering, memory bootstrap |

Both were extracted from real-world usage to save you the token burn of figuring it out yourself.

## Installation

### Option 1: Install individual skills (recommended)

```bash
# Pick the one you need
SKILL_NAME="vault-external-brain"  # or "hermes-agent-onboarding-guide"
SKILL_URL="https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main"

mkdir -p ~/.hermes/skills/$SKILL_NAME/{references,scripts,assets}

# Download SKILL.md
curl -sSL "$SKILL_URL/$SKILL_NAME/SKILL.md" \
  -o ~/.hermes/skills/$SKILL_NAME/SKILL.md

# Load in Hermes
skill_view(name='$SKILL_NAME')
```

### Option 2: Clone the whole repo

```bash
git clone https://github.com/jh6465xywq-sys/hermes-agent-frameworks.git
# Then symlink or copy the skill directories to your Hermes skills path
```

### Option 3: One-liner (Linux / macOS / Git Bash)

```bash
curl -sSL https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main/install.sh | bash
```

## Usage

After installation, load a framework in any Hermes session:

```bash
# Load the vault external brain framework
skill_view(name='vault-external-brain')

# Or load the onboarding guide
skill_view(name='hermes-agent-onboarding-guide')
```

Each framework has a `README.md` inside its directory for a quick overview plus `SKILL.md` for the full guide.

## Roadmap

More frameworks will be added as they're extracted from real usage:

- [ ] Template extraction workflow
- [ ] Multi-agent handoff protocols
- [ ] Cost-optimized model tiering patterns

## License

MIT
