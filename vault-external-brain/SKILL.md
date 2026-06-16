---
name: vault-external-brain
description: "Multi-agent shared Obsidian vault framework — external brain for cross-agent memory, knowledge distillation, handover protocol, and vault-as-a-service conventions."
platforms: [windows, linux, macos]
---

# Vault External Brain — General Framework

A reusable framework for using an **Obsidian vault as a shared external brain** across multiple AI agents (Hermes, Claude Code, Codex, custom agents, or human collaborators).

## Why Use This Framework

AI agents have limited persistent memory (~2K chars of durable notes). A shared vault solves this by providing:

- **Unlimited context** — the vault scales, your memory doesn't
- **Cross-agent sharing** — multiple agents read/write the same knowledge base
- **Knowledge distillation** — archive what matters, prune what doesn't
- **Idempotent resumption** — any agent can pick up where another left off

## Quick Start (5 minutes)

### 1. Create the vault

Create an Obsidian vault (empty folder works) with this numbered hierarchy:

```
your-vault/
├── 00-收件箱/        ← Inbox: quick capture, process weekly
├── 10-项目/          ← Active projects
├── 20-资源/          ← Reference, knowledge base, permanent resources
├── 30-待办/          ← Task tracking, pending items
├── 40-归档/          ← Completed/paused projects, memory snapshots
├── 50-Agent共享/     ← Cross-agent reusable solutions (skills, workflows)
├── 60-环境配置/      ← Shared paths, toolchain config, credentials (no secrets)
├── 70-跨Agent协作/   ← Handover logs, vault index, agent protocols
└── 99-模板/          ← Note templates (daily, project, meeting)
```

**Why this scheme works:**
- Numbered prefixes keep folders sorted the way you think (inbox first, templates last)
- Each zone has clear boundaries — no ambiguity about where a note lives
- The scheme is language-agnostic; adapt folder names to your locale

### 2. Configure Hermes

```yaml
# Add to hermes config.yaml under mcp_servers:
mcp_servers:
  obsidian:
    command: npx
    args:
      - -y
      - mcp-obsidian
      - /path/to/your-vault    # ← your vault path
    timeout: 60
```

Then enable the skill in your profile or load it on demand with:
```
skill_view(name='vault-external-brain')
```

### 3. Load the skill (prompt instructions)

Add to your agent persona or profile instructions:

> I have an Obsidian vault at `<path>`. Before acting, check the vault for context (especially `70-跨Agent协作/` for handover state). After completing significant work, write back to the vault. See the `vault-external-brain` skill for full protocol.

## Framework Components

### A. Memory vs Vault Boundary

This is the **most important rule** — without it, agents either pollute memory with trivia or ignore the vault entirely.

| Store | What goes here | Why |
|-------|---------------|-----|
| **Agent Memory** (persistent notes) | User preferences, environment facts, tool quirks, project conventions, cross-session context | These need to be loaded *every turn* — keep them lean and quick |
| **Vault** | Daily logs, personal events, reference material, completed task records, raw data, long-term knowledge | Scales infinitely, is searchable, and doesn't bloat your context window |

**Golden rule:** If a fact won't be needed >80% of sessions, put it in the vault. If it's ephemeral (<30 days relevance), put it in the vault. Only keep in memory what you genuinely need every single turn.

### B. Agent Role Assignment

Designate roles to avoid confusion:

- **Primary Writer** — the agent that receives most user interactions, maintains the vault proactively
- **Primary Reader** — the agent that executes tool-heavy work, checks vault before acting
- **Any agent can write**, but must log the write in `70-跨Agent协作/交接日志.md`

**Memory specialization example:**
- Writer agent remembers: user name, preferences, communication style, daily habits
- Reader agent remembers: toolchain paths, API key types, MCP config, environment quirks

### C. When to Read the Vault

| Situation | What to check |
|-----------|--------------|
| New task received | `70-跨Agent协作/交接日志.md` — current state |
| Environment/path/credential question | `60-环境配置/` — never re-discover |
| Troubleshooting / toolchain task | `50-Agent共享/` — reuse existing solutions |
| New session starts | `70-跨Agent协作/交接日志.md` — where things were left |
| Pending items | `30-待办/` — deferred tasks |

### D. When to Write to the Vault

| Situation | Where to write |
|-----------|---------------|
| Solved a new problem | `50-Agent共享/` with standard format |
| Discovered user preference / taboo | Append to `70-跨Agent协作/交接日志.md` |
| Completed a milestone task | Update `70-跨Agent协作/交接日志.md` |
| Memory exceeds 80% capacity | Trigger distillation (see below) |
| Personal / daily / ephemeral info | `20-资源/` or `40-归档/` — never memory |

### E. Memory Distillation Workflow

When agent memory exceeds 80% capacity (or periodically):

1. **Audit** — dump all memory entries
2. **Classify each entry**:
   - Environment config → archive to `60-环境配置/`
   - Troubleshooting/solutions → archive to `50-Agent共享/`
   - User preferences → merge/shorten, keep in memory
   - Ephemeral (>30 days untouched) → delete outright
3. **Clean duplicates first** — keep the most specific version
4. **Archive to vault** — write consolidated notes to the appropriate folder
5. **Compress preferences** — shorten without losing meaning
6. **Log distillation** — write to `70-跨Agent协作/交接日志.md`:
   - Reason (usage %, type of pollution)
   - What was archived and to which file
   - What was cleaned/removed
   - Remaining entry count and new usage %

### F. Writing Conventions

All vault entries should follow these rules:

1. **Pure text, no tables** — text survives any migration; tables don't
2. **Skill entries format** (`50-Agent共享/`):
   ```
   ## Skill Name
   - Use case:
   - Steps:
   - Pitfalls:
   - Last updated: YYYY-MM-DD / Agent
   ```
3. **Handover log format** (`70-跨Agent协作/交接日志.md`):
   ```
   ### YYYY-MM-DD [Agent Name]
   - What was done:
   - Discoveries / preferences:
   - Pending issues:
   ```
4. **One topic per note** — small, focused files are easier to navigate
5. **Frontmatter when useful** — but keep it minimal (`tags:`, `created:`)

### G. Handover Protocol (Multi-Agent)

When multiple agents share the same vault:

- Each agent appends to `70-跨Agent协作/交接日志.md` after every significant action
- Log entries are chronological with date + agent name
- If you find another agent's info outdated → update directly, no approval needed
- Before starting work, always read the log first to see what's happened since your last turn

### H. File Transfer (Optional)

If you use a shared inbox folder (iCloud, Dropbox, watched directory):

- Define a known inbox path
- Standardize the notification format (e.g. "📎 File ready: [filename]")
- Handle race conditions when multiple agents could read the same file (read-then-move or semaphore)
- Document the protocol in `70-跨Agent协作/` as a reference

### I. Cron Automation (Zero-Touch Mode)

For full autonomy, schedule cron jobs to handle memory maintenance and vault check-ins without manual prompting.

#### Distillation Cron (Every 2 Days)

Automatically checks memory usage and distills if >80%:

```bash
hermes cron create \
  --name "memory-distill" \
  --schedule "0 8 */2 * *" \
  --skills memory-maintenance,vault-external-brain \
  --prompt "检查 memory 使用率，超 80% 则蒸馏归档到 vault。分类规则：环境配置→归档，重复/临时→删除，用户偏好→合并压缩。蒸馏后写日志到 70-跨Agent协作/交接日志.md"
```

#### Daily Vault Check-In Cron

Writes a daily health check to the vault handover log:

```bash
hermes cron create \
  --name "vault-daily-checkin" \
  --schedule "0 4 * * *" \
  --skills vault-external-brain \
  --prompt "在 vault 的 70-跨Agent协作/交接日志.md 追加一条日检记录，检查 vault 目录结构完整性。格式：## YYYY-MM-DD 日检\n- 状态：正常运行"
```

#### Cron Setup Notes

- Cron jobs run in isolated sessions with no conversation context — prompts must be self-contained
- Load `memory-maintenance` + `vault-external-brain` skills for distillation cron
- The `deliver: local` option saves results without sending notifications
- To list, pause, or remove: `hermes cron list`, `hermes cron pause <id>`, `hermes cron remove <id>`
- Test a cron immediately: `hermes cron run <id>`

## Integration with Other Hermes Features

This framework pairs well with:
- **`plan` skill** — write plans to `10-项目/` before executing
- **`memory-maintenance` skill** — regular memory audit automation
- **`obsidian` skill** — direct vault access via MCP or file tools
- **`hermes-agent` skill** — configure MCP, profiles, and skills
- **`hermes-agent-skill-authoring` skill** — extracting and publishing generic frameworks

For the full workflow on publishing reusable frameworks to a public GitHub repo (README, install script, LICENSE, version tags, token management), see `references/github-publishing.md`.

## Customization Guide

| Variable | What to change | Example |
|----------|---------------|---------|
| Vault path | Your Obsidian vault location | `/home/user/obsidian-vault` |
| Folder names | Adapt to your language/convention | `01-inbox/`, `02-projects/` |
| Agent roles | Match your agent setup | Writer=Hanako, Reader=Hermes |
| Memory threshold | When to trigger distillation | 75% or 85% depending on context window |
| Distillation frequency | How often to audit | Weekly for heavy users, monthly for light |

## Pitfalls

- ❌ **Do not** put secrets (API keys, passwords) in the vault — use environment variables or Hermes secrets config
- ❌ **Do not** let memory and vault say different things about the same config — update both when something changes
- ❌ **Do not** write huge single files — break into focused notes (<500 lines each recommended)
- ❌ **Do not** use tables in vault notes — they break on export/copy and some text-based tools
- ⚠️ Obsidian MCP can be slow on very large vaults (>1000 files); keep your vault lean
- ⚠️ Multiple agents writing concurrently can race — use the handover log as a lightweight lock
- ⚠️ Memory distillation deletes from agent memory — make sure the vault archive is complete before deleting
- ⚠️ Cron jobs run with no user present — don't include interactive steps in cron prompts
- ⚠️ Test new cron jobs immediately with `hermes cron run <id>` instead of waiting for the schedule

## Verification Checklist

After setup, verify the framework works:

- [ ] Vault folder structure exists with all 9 directories
- [ ] Hermes MCP is configured and the agent can read vault files
- [ ] Skill loaded with `skill_view(name='vault-external-brain')`
- [ ] Agent persona mentions checking vault before acting
- [ ] Handover log exists at `70-跨Agent协作/交接日志.md`
- [ ] `memory-maintenance` skill loaded for distillation
- [ ] Distillation cron created: every 2 days, loads memory-maintenance + vault-external-brain
- [ ] Daily vault check-in cron created: daily, writes to handover log
- [ ] Cron tested with `hermes cron run <id>` (optional but recommended)
- [ ] Test: ask agent "what's in the vault index?" — should read and summarize
- [ ] Test: ask agent to write a note → verify it appears in the correct folder
