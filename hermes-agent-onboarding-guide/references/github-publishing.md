# GitHub Publishing Workflow for Generic Frameworks

A quick reference for pushing extracted frameworks to a public repo — covers auth setup, common failures, and cleanup.

## Prerequisites

- A GitHub repo created (public or private)
- A fine-grained token with **Contents: Write** on that specific repo
- Git installed on the local machine

## Quick Steps

```bash
# 1. Initialize & commit
cd /path/to/frameworks-folder
git init
git add -A
git commit -m "🎉 Initial commit: description"

# 2. Set remote with token
# Format: https://<USERNAME>:<TOKEN>@github.com/<USER>/<REPO>.git
git remote add origin https://YOUR_USERNAME:YOUR_TOKEN@github.com/YOUR_USER/REPO_NAME.git

# 3. Push
git push -u origin main   # or 'master' depending on default branch name
```

## Common Pitfalls

### ❌ "Bad credentials" / 401

**Most likely cause:** Token doesn't have Contents: Write permission.

Fix: Go to [Fine-grained tokens page](https://github.com/settings/tokens?type=beta), delete the token, create a new one with:
- Repository access → Only select repositories → your framework repo
- Permissions → **Contents: Write** (add via "+ Add permissions" button)
- Metadata: Read-only (auto-granted)

### ❌ Git push fails with special characters in token

Fine-grained tokens contain `_` and other characters that can break shell quoting.

**On Windows/MSYS (bash):** Store token via credential helper:
```bash
git config --local credential.helper store
echo "https://USERNAME:TOKEN@github.com" > .git-credentials
git push -u origin main
```

**On Linux/macOS:** Use the URL format in single quotes:
```bash
git remote add origin 'https://USERNAME:TOKEN@github.com/USER/REPO.git'
```

### ❌ "Password authentication is not supported"

Fine-grained tokens don't work with password-based auth. Make sure you're using the token as the password, not your GitHub password.

### ❌ Default branch is 'master' not 'main'

If the repo was created without a README, the first push defaults to `master`. Push to `master` first, then rename if needed:
```bash
git push -u origin master
```

## Verify

```bash
curl -s -H "Authorization: Bearer YOUR_TOKEN" \
  "https://api.github.com/repos/USER/REPO/contents" | head -5
```

Should return 200 with a list of files.

## Cleanup

After pushing successfully:

1. Revoke the token: https://github.com/settings/tokens?type=beta → Delete
2. Optionally remove `.git-credentials` file from the project directory:
   ```bash
   rm .git-credentials
   git config --local --unset credential.helper
   ```
