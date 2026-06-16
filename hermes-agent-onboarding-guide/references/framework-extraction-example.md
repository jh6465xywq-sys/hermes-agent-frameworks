# Framework Extraction Example — Session 2026-06-16

A concrete walkthrough of how two generic frameworks were extracted from personalized work in a single session.

## Source Material

Two personalized skills existed for user Deriver:
- `shared-knowledge-base` (productivity/) — Obsidian vault protocol, heavily personalized with local paths, agent names, iCloud paths
- Ongoing agent onboarding work scattered across memory and multiple skill updates

## Extraction Steps Taken

### 1. Audit existing work

Read both the personalized skill and the actual vault/config structure to understand what was universal vs specific.

**Personalized → Strip:**
- `D:\Ai ObsidianVault` → `/path/to/your-vault`
- Agent names "Hermes", "hanako" → "Primary Writer", "Primary Reader"
- QQ/iCloud integration → Optional "File Transfer" module
- Job search details, 张瑞 resume → removed entirely

**Universal → Keep:**
- Numbered folder hierarchy with zone boundaries
- Memory vs vault boundary rules
- Distillation workflow (audit → classify → archive → compress → log)
- Handover protocol
- Writing conventions (no tables, structured formats)

### 2. Create two frameworks instead of one

The original `shared-knowledge-base` mixed two concerns:
- How to set up a vault external brain (structural)
- How to onboard a new agent (procedural)

Split into:
- `vault-external-brain` — the WHAT: vault structure, memory boundaries, distillation
- `hermes-agent-onboarding-guide` — the HOW: environment probe, user profile, skill selection, model tiers, authoring discipline

### 3. Keep the original, link to generic

The personalized `shared-knowledge-base` was not deleted. Instead:
- Added a banner: "This is a personalized instance of vault-external-brain"
- Added a link: "Load skill_view(name='vault-external-brain') for the generic version"
- Same treatment for `operating-protocol-v1.md` reference file

### 4. Create organizational structure

- Both new skills went into `generic-frameworks/` (dedicated category)
- CATALOG.md created as an index
- README.md alias files added so skills are recognizable in file browser

### 5. Push to separate public repo

The generic frameworks went to their own public repo (`hermes-agent-frameworks`), separate from the private backup repo (`Hermes-backup`) that holds personalized skills.

## Lessons Learned

- **Split first, then isolate.** Don't try to extract one monolithic framework — identify the natural seams.
- **A personalized skill that embeds a generic approach is two skills waiting to happen.** The personal config IS the concrete example; the generic version IS the spec.
- **Keep the original and link.** Deleting the personal version breaks the user's workflow. Adding a banner preserves discoverability while pointing to the canonical version.
- **Name carefully.** `shared-knowledge-base` vs `vault-external-brain` — the generic name should describe the class of problem, not the instance.
- **Separate repos for separate audiences.** Private backup repo ≠ public framework repo.
