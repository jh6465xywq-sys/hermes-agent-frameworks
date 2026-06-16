# Publishing Generic Frameworks to GitHub

## When to Publish

When you've extracted a reusable pattern from personalized setup (see SKILL.md → "Extracting Generic Frameworks" in `hermes-agent-skill-authoring`), and it's ready for others to use.

Requirements:
- No personal info (paths, usernames, API keys)
- Has Quick Start (≤5 min to be productive)
- Has Pitfalls section
- Has Verification Checklist
- Cross-platform compatible (or clearly marked limitations)

## One-Time Repo Setup

1. Create repo on GitHub (Public, optional MIT license, no .gitignore)
2. Clone it locally

### Fine-Grained Token

Use fine-grained tokens (not Classic tokens), scoped to this repo only:

1. `github.com/settings/tokens?type=beta` → Generate new token
2. Repository access: "Only select repositories" → pick this repo
3. Permission: **Contents: Write** (Metadata: Read-only is auto)
4. Generate, copy the token

### Persistent Credential

```bash
cd /path/to/repo
git config credential.helper store
echo "https://<user>:<TOKEN>@github.com" > .git-credentials
```

The token can only push to this single public repo. Revoke anytime from Settings.

## Per-Framework Workflow

### 1. Skill exists in generic-frameworks/ category

After `skill_manage(action='create', category='generic-frameworks', name='<name>')`, the files are at:

```
~/.hermes/skills/generic-frameworks/<name>/
├── SKILL.md      ← Hermes entry point
└── README.md     ← human-readable alias (load command, purpose, related skills)
```

### 2. Add root-level repo files

For a repo containing multiple frameworks:

```
repo-root/
├── README.md          ← project homepage with install instructions
├── CATALOG.md         ← index of all frameworks
├── LICENSE            ← MIT (or your choice)
├── install.sh         ← one-line install script
├── framework-a/
│   ├── SKILL.md
│   └── README.md
└── framework-b/
    ├── SKILL.md
    └── README.md
```

**README.md conventions:**
- Short description + one-line install command
- Table of frameworks (name | description)
- Three install options: one-liner, individual, clone

**install.sh conventions:**
- Support `SKILL=name` (single) and `SKILLS=a,b,c` (multiple) env vars
- Default: install all frameworks
- Download via raw.githubusercontent.com with timeouts
- Creates skill directory structure (references/, scripts/, assets/)

### 3. Commit, tag, push

```bash
cd /path/to/repo
git add -A
git commit -m "➕ Add <framework-name>: one-line description"
git tag v1.x.x
git push origin main --tags
```

Force push only on first push (fresh repo, no other contributors).

## Common Pitfalls

- **Default branch is main, not master.** Check with `git remote show origin`.
- **Token needs Contents: Write.** Default fine-grained token only has Metadata. Click "+ Add permissions" and add Contents.
- **repo vs install.sh URLs.** install.sh must use `raw.githubusercontent.com/<user>/<repo>/main/` URLs, not the normal github.com page URLs.
- **Skill not visible in current session.** The loader caches at session start. Verify in a fresh session.
- **README.md alongside SKILL.md.** Hermes loads SKILL.md as the entry point. README.md is for human browsing only.
- **🚨 .git-credentials must NOT be committed.** Credential helper stores the token in plain text. Add `.git-credentials` to `.gitignore` immediately after setup:
  ```bash
  echo ".git-credentials" >> .gitignore
  git rm --cached .git-credentials  # remove from tracking if accidentally committed
  ```
  Use `git diff --cached` before every commit to catch sensitive files. The token can push to your repo — if it leaks someone else can too.
- **Remove token from remote URL.** After setting up credential helper, run:
  ```bash
  git remote set-url origin https://github.com/<user>/<repo>.git
  ```
  Otherwise the token is visible in `git remote -v` output.
