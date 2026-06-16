---
name: hermes-agent-onboarding-guide
description: "Systematic agent onboarding framework — initial environment probe, user profile setup, workspace conventions, skill selection, model tiering, and memory bootstrapping guidelines."
platforms: [windows, linux, macos]
---

# Hermes Agent Onboarding Guide

A reusable framework for efficiently onboarding a new Hermes agent — covering environment discovery, user profiling, workspace layout, skill selection, model tiering, and persistent memory setup.

## Why This Matters

The first few sessions with a new agent are the most token-heavy. Every missing config, wrong assumption, or re-discovered path burns tokens that could have been saved by a structured onboarding. This framework captures the **proven sequence** to get from zero to productive in minimal turns.

## Quick Start

```bash
# Load this skill first
skill_view(name='hermes-agent-onboarding-guide')

# Then proceed through the phases below sequentially
```

## Onboarding Phases

### Phase 1: Environment Probe

Discover the host environment without assumptions:

```yaml
# Checklist:
- [ ] OS & version (uname -a / winver / sw_vers)
- [ ] Shell type (bash/zsh/powershell/fish)
- [ ] User home directory ($HOME / %USERPROFILE%)
- [ ] Working directory conventions
- [ ] Installed toolchain (python/node/git/uv/npm/etc.)
- [ ] Package managers available (apt/brew/choco/pip/uv)
- [ ] Network connectivity (can reach GitHub/pypi/npm)
- [ ] Hardware specs (RAM/CPU/GPU if relevant)
```

**Output:** Save environment facts to persistent memory (e.g. `memory(action='add', target='memory', content='Host: Windows 10, Shell: git-bash, Home: C:\\Users\\<user>')`)

**Cost-saving tip:** Always use `read_file` / `search_files` / `terminal` for discovery instead of asking the user. Most environment facts can be probed autonomously in one or two terminal calls.

### Phase 2: User Profile Bootstrap

Learn who the user is and what they need:

| Category | Questions to answer |
|----------|-------------------|
| Identity | Name, role, technical level, primary language |
| Work scope | What they build/maintain (web dev, data science, MLOps, research, creative, etc.) |
| Tools | What they already use (VS Code, Obsidian, Docker, specific frameworks) |
| Preferences | Language for communication, tone (concise/verbose/formatted), formatting style |
| Constraints | Budget limits (free-tier preference vs paid API), timezones, work patterns |

**Approach:** Don't ask everything at once. Probe naturally over the first few interactions:
1. First session → identity + work scope + communication language
2. After first task → toolchain + preferences
3. After a few tasks → constraints + advanced preferences

**Output:** Save to user profile memory (`memory(action='add', target='user', content='...')`)

### Phase 3: Workspace Conventions

Establish where code, data, and config live:

```yaml
- [ ] Main workspace directory (where projects live)
- [ ] Project naming convention (kebab-case / snake_case / etc.)
- [ ] Git conventions (branch naming, commit message style)
- [ ] Config and data directories (separate from code)
- [ ] Temp / output directories (where builds, logs, assets go)
- [ ] Shared paths (teams, network drives, cloud sync folders)
```

**Discovery:** Use one terminal call to list the workspace top-level, then probe conventions from file names and structures.

**Output:** Save to persistent memory — this prevents re-probing on every session.

### Phase 4: Skill Discovery & Selection

Map available skills to the user's workflow:

```yaml
1. List all skills: skills_list()
2. Filter by relevance to user's work:
   - Development → software-development/ category
   - Research → research/ category
   - Note-taking → note-taking/ category
   - Data → data-science/ category
3. Test-load relevant ones: skill_view(name='xxx')
4. Finalize skill toolkit (3-8 skills ideally; too many → context bloat)
5. Pin frequently-used skills so they auto-load
```

**Heuristics for skill selection:**
- **Must-have** (load every session): `hermes-agent` (self-config), `github-pr-workflow` (if they use GitHub), the workspace's primary dev skill
- **Common** (load on demand): search, git, project-specific skills
- **Niche** (load only when needed): creative, media, red-teaming, specific tool skills

**Output:** Save which skills are preferred to memory.

### Phase 5: Model & Provider Tiering

Set up the right model for the right job:

```yaml
- [ ] Primary model for daily work
- [ ] Flash/light model for quick queries (QQ, chat, fast lookups)
- [ ] Pro/heavy model for complex reasoning tasks
- [ ] Vision model (if needed) — configure under auxiliary.vision
- [ ] Fallback provider (when primary is rate-limited or down)
- [ ] Cost awareness: which models are free vs paid tiers
```

**Example tiering strategy:**
| Tier | Use case | Model profile |
|------|----------|--------------|
| Flash | Chat, search, fast lookups, simple edits | Cheap/free provider, fast inference |
| Pro | Debugging, code review, complex analysis | Premium model, slower but smarter |
| Vision | Image analysis, screenshots, diagrams | Separate vision provider (Gemini, GPT-4o) |

**Output:** Save tier rules to memory (e.g. `User on Flash tier by default. Switch to Pro only on explicit request.`)

### Phase 6: Communication Contract

Establish how the agent should interact with the user:

```yaml
- [ ] Primary language (Chinese, English, Japanese, etc.)
- [ ] Tone preference (concise / detailed / enthusiastic / formal)
- [ ] Verbosity preference (just results vs explain reasoning)
- [ ] What triggers clarification vs making a default choice
- [ ] Error handling: report blockers directly vs try alternatives
- [ ] Progress style: silent execution vs status updates per step
- [ ] File/code format: inline diffs, full files, or summaries
```

**Output:** Save to memory (e.g. `User prefers concise Chinese responses. Ask before blind-installing packages.`)

### Phase 7: Persistent Memory Bootstrapping

Set up the memory system for lasting productivity:

```yaml
1. Audit current memory: memory() calls show usage percentage
2. Save structured entries:
   - Environment facts (OS, home, workspace, tools)
   - User profile (name, role, preferences, constraints)
   - Project conventions (naming, git style, workflow)
   - Tool quirks discovered during setup
3. If using vault external brain:
   - Configure Obsidian MCP in config.yaml
   - Set up vault folder structure (see vault-external-brain skill)
   - Save vault path and structure to memory
   - **Set up cron automation** for zero-touch maintenance:
     - Distillation cron: every 2 days (`memory-maintenance` + `vault-external-brain` skills)
     - Daily vault check-in: daily at 4 AM (`vault-external-brain` skill)
     - See `vault-external-brain` skill section I for exact commands
```

**Memory discipline rules:**
- ✓ **Save:** Environment facts, user preferences, project conventions, tool quirks, API endpoints
- ✗ **Don't save:** Task progress, temporary state, session outcomes, completed work logs
- Use `memory(target='memory')` for environment/tool facts
- Use `memory(target='user')` for identity/preferences

### Phase 8: Skill Authoring Discipline

When a task pattern repeats or a setup is complex, create a skill:

```yaml
You've just solved something that took 5+ tool calls,
involved tricky error handling, or the user corrected your approach.
→ Create a skill with skill_manage(action='create', ...)

You've discovered a workflow that's project-specific, non-obvious,
or would waste tokens to rediscover next session.
→ Create a skill.

The skill should include:
- Trigger conditions (when to load this skill)
- Numbered steps with exact commands
- Pitfalls / gotchas section
- Verification step at the end
```

#### Distribution: Making Frameworks Consumable

After extracting a framework, **don't just leave it as files** — your users (or future-you on a new machine) will find it and have no clue how to use it. A "published" framework has:

**Repo-level files** (in the framework repo root):

| File | Purpose | Required? |
|------|---------|-----------|
| `README.md` | Project homepage: What's inside, Why use this, Installation methods, Usage examples | ✅ Yes |
| `CATALOG.md` | Index table: every framework in the repo + one-liner description + load command | ✅ Yes |
| `LICENSE` | Open-source license (MIT recommended for Hermes skills) | ✅ If public |
| `install.sh` | One-liner install script (see pattern below) | Recommended |
| `.gitignore` | Prevent credential files, temp files from leaking | ✅ Yes |

**Install script pattern** (`install.sh`):

```bash
#!/usr/bin/env bash
# Target: $HERMES_HOME/skills/<skill-name>/
REPO="https://raw.githubusercontent.com/<owner>/<repo>/main"

install_skill() {
  local name="$1"
  local dest="${HERMES_HOME:-$HOME/.hermes}/skills/$name"

  if [ -d "$dest" ]; then
    echo "  ⚠  $name already exists, skipping"; return
  fi

  mkdir -p "$dest"/{references,scripts,assets}
  curl -sSL --connect-timeout 10 --max-time 30 \
    "$REPO/$name/SKILL.md" -o "$dest/SKILL.md"
  echo "  ✓ $name installed"
}

install_skill "vault-external-brain"
install_skill "hermes-agent-onboarding-guide"
```

Users then run:
```bash
curl -sSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash
```

**Versioning:** Tag with semver:
```bash
git tag v1.0.0
git push origin main --tags
```

**README structure:**
1. Project name + one-liner description
2. Table of contents / What's Inside (table of frameworks)
3. Installation section with multiple options (curl one-liner, git clone, manual download)
4. Per-framework usage examples
5. Roadmap (optional — shows project is alive)
6. License badge

**Final check before publishing:**
- [ ] All personal info stripped (paths, usernames, real names, project names)
- [ ] README.md written with install instructions
- [ ] install.sh tested end-to-end
- [ ] LICENSE file added
- [ ] CATALOG.md updated
- [ ] Git tag applied (e.g. v1.0.0)
- [ ] Fine-grained token used, not classic token
- [ ] Token revoked after push

#### Framework Extraction Workflow

When you've built something personal (custom memory, personalized protocols, project-specific rules) that could benefit others, extract a **generic framework** to a dedicated frameworks category:

```
skills/
├── generic-frameworks/              ← All reusable frameworks here
│   ├── CATALOG.md                   ← Index (short description per skill)
│   ├── your-framework-1/
│   │   ├── SKILL.md                 ← System entry point
│   │   └── README.md                ← Human-readable alias (what is this?)
│   └── your-framework-2/
│       ├── SKILL.md
│       └── README.md
└── other-categories/                ← Personalized skills stay here
```

**Step-by-step:**
1. Strip all personal info (paths, usernames, real names, project names, API keys)
2. Replace hardcoded paths with placeholder templates (e.g. `/path/to/your-vault`)
3. Add a Customization Guide table showing what variables the user needs to change
4. The skill must be self-contained — someone should be able to load it and follow it immediately
5. Add a README.md alias file (2-5 lines: purpose, load command, one-liner summary) alongside SKILL.md so it's recognizable in file browsers
6. Update CATALOG.md in the frameworks category
7. Keep the original personalized skill (if any) in its original category — have it reference the generic framework in a banner at the top

**Why separate:**
- Personalized skills go in their natural category (productivity/, note-taking/)
- Generic frameworks go in generic-frameworks/ — they're for public or cross-user use
- The separation makes it obvious what's ready to share vs what's tuned to one setup
- Future extraction candidates are easy to find: look for skills that reference generic-frameworks/ skills

**🔒 Security: Publishing to GitHub**

See `references/github-publishing.md` for a step-by-step guide with common failure fixes.

When pushing frameworks to a public repo:

1. **Create a separate public repo** — don't mix generic frameworks with your private backup repo
2. **Use a Fine-grained token** (not Classic token):
   - Repository access: **Only select repositories** → choose the framework repo
   - Permissions: **Contents: Write** is the minimum (Metadata: Read-only is auto)
   - This limits blast radius to exactly one public repo — no access to private repos
3. **Set an expiration** — 7 days is plenty; you can always regenerate
4. **Revoke the token after pushing** — go to Settings → Developer settings → Tokens and delete it
5. **Never hardcode tokens** in SKILL.md or reference files — use placeholders like `<your-token>`

### Phase 9: Onboarding Completion Checklist

Before declaring onboarding done, verify:

- [ ] Phase 1: Environment probed and saved to memory
- [ ] Phase 2: User profile has identity, work scope, language preference
- [ ] Phase 3: Workspace conventions known (main project directory, structure)
- [ ] Phase 4: Core skills identified and test-loaded
- [ ] Phase 5: Model tiers clear (default vs pro vs vision)
- [ ] Phase 6: Communication contract established (language, tone, verbosity)
- [ ] Phase 7: Persistent memory populated, vault configured (if using)
- [ ] Phase 8: Skill authoring discipline understood
- [ ] Agent can complete a real task without re-discovering basic facts
- [ ] Memory is at <40% capacity after bootstrapping (leaves room for session facts)

## Pitfalls

- ❌ **Don't ask every question at once** — probe naturally over first few interactions. A wall of questions annoys users.
- ❌ **Don't assume you know the OS** — always probe. MSYS2 on Windows reports differently than Linux.
- ❌ **Don't save everything to memory** — memory has a ~2K char limit. Be selective.
- ❌ **Don't skip environment probe** — assuming paths or tools wastes way more tokens than probing.
- ❌ **Don't over-select skills** — 8+ skills in context bloat your window. Pick ruthlessly.
- ⚠️ **First session is always the longest** — accept this. The ROI is lower token burn in every subsequent session.
- ⚠️ **User preferences change** — revisit Phase 6 after 5-10 sessions and save corrections.
- ⚠️ **Cost tiers may need adjustment** — if user mentions "this session was expensive", review Phase 5.

## Related Skills

- `vault-external-brain` — shared vault framework (pair with this guide if using Obsidian)
- `hermes-agent` — Hermes self-config, CLI commands, setup
- `memory-maintenance` — periodic memory audit and cleanup
- `hermes-mcp-setup` — MCP server configuration
- `github-auth` — GitHub auth setup for new users
