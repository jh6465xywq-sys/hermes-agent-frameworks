# GitHub Publishing Guide for Hermes Skills

Complete step-by-step for pushing a Hermes skill or framework collection to a public GitHub repo.

## Prerequisites

- git installed and configured
- A GitHub account
- A Hermes skill/skill collection ready to publish (no personal info)

## Step 1: Create a Public Repo (via browser)

1. Go to https://github.com/new
2. **Owner:** your username
3. **Repository name:** short, descriptive (e.g. `hermes-agent-frameworks`)
4. **Description:** one-liner explaining what's in the repo
5. **Visibility:** Public (for reusable frameworks)
6. **Add a README:** No (we'll write our own)
7. **License:** MIT (recommended for Hermes skills)
8. Click **Create repository**

## Step 2: Init Local Git & Add Content

```bash
cd /path/to/your-framework-collection
git init
git add -A
git commit -m "🎉 Initial commit: Hermes Agent reusable frameworks"
```

If the repo already exists with README from step 1, the branch is `main`:
```bash
git branch -m main
git remote add origin https://github.com/<owner>/<repo>.git
```

## Step 3: Generate a Fine-Grained Token

⚠️ **Use a Fine-grained token, NOT a Classic token.** Classic tokens grant access to ALL your repos and cannot be restricted.

1. Go to https://github.com/settings/tokens?type=beta
2. Click **Generate new token → Fine-grained token**
3. **Token name:** `hermes-push`
4. **Expiration:** 7 days
5. **Repository access:** **Only select repositories** → choose your framework repo
6. **Permissions → Repository permissions:**
   - **Contents:** `Access: Write` (required for pushing)
   - **Metadata:** `Access: Read-only` (auto-added)
7. Click **Generate token** — **copy it immediately**

**Token format:** `github_pat_xxxx...`

## Step 4: Push

```bash
git config --local credential.helper "store --file .git-credentials"
echo "https://<username>:<token>@github.com" > .git-credentials
git push -u origin main
rm -f .git-credentials
git config --local --unset credential.helper
git remote set-url origin https://github.com/<owner>/<repo>.git
```

## Step 5: Tag a Version

```bash
git tag v1.0.0
git push origin main --tags
```

## Step 6: Revoke the Token

1. Go to https://github.com/settings/tokens?type=beta
2. Delete the token immediately after push

## Common Failure Modes

### "Password authentication is not supported for Git operations"

Fine-grained tokens can't be embedded in the remote URL directly. Use credential store:
```bash
git config --local credential.helper "store --file .git-credentials"
echo "https://<username>:<token>@github.com" > .git-credentials
```

### "Invalid username or token"

Causes:
- Token was expired before push
- Missing Contents: Write permission
- Classic token used instead of Fine-grained

### "Updates were rejected" (non-fast-forward)

The GitHub repo has initial commits (README, LICENSE). Force push is acceptable for a fresh repo:
```bash
git push -u origin main --force
```

### Token works for `/user` API but fails for git push

The token lacks repo-scope permissions. Check that Contents: Write is set.

## Security Rules

- ✅ Fine-grained token limited to ONE repo with ONLY Contents: Write
- ✅ Revoke immediately after use
- ✅ Never hardcode tokens in SKILL.md
- ❌ Never use Classic tokens with `repo` scope
- ❌ Never commit `.git-credentials`
- ❌ Don't leave token embedded in `git remote URL`
