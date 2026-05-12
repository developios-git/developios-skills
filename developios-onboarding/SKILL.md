---
name: developios-onboarding
description: Interactive Developios team onboarding for Claude Code. Collects the user's name and role, generates a personalized install checklist, walks through local MCPs, CLIs, skill packs, and tokens one at a time, writes a persistent memory file at ~/.developios/CLAUDE.md, and sets up a daily local git backup of the user's Developios state. Use when the user says "onboard me", "set me up", "I'm new at Developios", "/developios-onboarding", "help me get started", "install everything I need", or asks how to get set up at Developios.
---

# Developios Onboarding

You are guiding a new Developios team member through Claude Code setup. The goal: in under 20 minutes, they have Claude Code, the right local MCPs, the right CLIs, the right skill packs, and any per-user tokens they need.

**This skill targets Claude Code only.** Do not suggest Claude Desktop installs or Claude.ai connector setup — those are managed at the team-account level and shared across the team.

## Behavior rules (read first, follow always)

1. **ONE question at a time.** Never bundle. Wait for the answer before moving on.
2. **Show the full checklist first.** Once you know the role, generate `~/.developios/checklist.md` and display it. Tick items off as you progress.
3. **Confirm before running commands.** Show the exact command and ask "Run it? (y/n)" before any install.
4. **Never echo tokens.** Confirm with "✅ Saved." and nothing else.
5. **Tokens go to `~/.developios/tokens.md`** (chmod 600). Never anywhere else.
6. **If a step fails or is skipped**, note it and continue. Don't block the whole flow.
7. **Resume support.** If `~/.developios/profile.json` already exists, ask "Welcome back — resume where you left off?" before starting fresh.
8. **Keep tone short, friendly, outcome-focused.** No emoji walls. No long preambles.

---

## Step 0 — Resume check

Check if `~/.developios/profile.json` exists. If yes:

- Read it.
- Say: "Welcome back, [name]. You started as a [role] on [started_at]. Want to continue where you left off, or start over? (continue/restart)"
- Continue → jump to the section after the last completed step (`last_step` field).
- Restart → archive the old profile to `~/.developios/profile.archive.<timestamp>.json` and start fresh.

If profile doesn't exist, continue to Step 1.

---

## Step 1 — Identity

Ask, **one at a time**:

1. "Welcome to Developios. What's your full name?"
2. "What email do you use for work?"
3. "What role are you joining as?"
   - Developer
   - UI/UX Designer
   - AI & Automation Intern
   - Marketing / Paid Ads
   - Sales / SDR
   - Operations / Project Manager
   - Other (describe)
4. "What OS are you on? (macOS / Linux / Windows)"
   - If Windows: tell them everything below assumes WSL2. Point to https://learn.microsoft.com/en-us/windows/wsl/install if they don't have it.
5. "Will you be recording, joining, or analyzing recorded meetings? (y/n)" — this gates whether Fathom MCP is on their list.

After collecting, run `mkdir -p ~/.developios && chmod 700 ~/.developios` then write `profile.json`:

```json
{
  "name": "...",
  "email": "...",
  "role": "...",
  "os": "...",
  "meetings": true,
  "started_at": "<ISO-8601>",
  "last_step": "identity",
  "installed": [],
  "skipped": [],
  "failed": []
}
```

---

## Step 2 — Generate and show the checklist

Look up the role in the **Role → Toolkit matrix** below. Build the full ordered list of items: universal foundations + role-specific MCPs + CLIs + skill packs + tokens. Include Fathom MCP only if `meetings: true`.

Write the checklist to `~/.developios/checklist.md` in markdown task-list format. Each item is `- [ ] <category>: <item>`.

Display the checklist to the user. Then ask: "Ready to start? (y/n)"

As you complete each item, update the checklist with `- [x]` (installed), `- [~]` (skipped), or `- [!]` (failed). Always re-display the checklist after every status change so the user sees progress.

---

## Step 3 — Universal foundations

These apply to every role. Walk them one at a time. For each: explain → check if already installed via Bash → show install command → "Install? (y/skip/already)".

After each: append result to `profile.json` and update the checklist marker.

### 3.1 Node.js + npm
- Check first: `node --version && npm --version`. If both exist, mark as already.
- Install (macOS): `brew install node`
- Install (Linux/WSL): `sudo apt update && sudo apt install -y nodejs npm`

### 3.2 Git
- Check first: `git --version`. If exists, mark as already.
- Install (macOS): `brew install git`
- Install (Linux/WSL): `sudo apt install -y git`

### 3.3 Claude Code CLI
- Check first: `claude --version`. If exists, mark as already.
- Install: `npm install -g @anthropic-ai/claude-code`
- After install: remind them to add the **Claude Code extension** in Cursor / VS Code (search "Claude Code").

Update `profile.json` → `last_step: "foundations"`.

---

## Step 3.5 — Memory file (so future Claude sessions remember the user)

This step gives the user a persistent memory file that every future Claude Code session on their machine will read. It also bakes in the maintenance rules — token appends, preference logging — so Claude keeps the file useful over time.

### 3.5.1 Write the user's memory file

Write `~/.developios/CLAUDE.md` (substitute fields from `profile.json`):

```markdown
# Developios — User profile and ongoing notes

> This file is read automatically by Claude Code on this machine. Keep it up to date.

## Identity
- Name: <name>
- Role: <role>
- Email: <email>
- OS: <os>
- Meetings track: <yes/no>
- Joined Developios setup: <started_at>

## Working preferences
(Claude will append observations here as it learns how the user wants to work.)

## Reference paths
- Profile: `~/.developios/profile.json`
- Token vault: `~/.developios/tokens.md` (chmod 600 — never echo, never commit)
- Checklist: `~/.developios/checklist.md`
- Backup repo: `~/.developios/` is a local git repo. A cron entry commits changes daily at 9 PM. `tokens.md` and `*.log` are gitignored.

## Maintenance rules for Claude (read every session)

1. **Tokens.** Whenever the user pastes a new API token, append to `~/.developios/tokens.md` as:
   ```
   ## <SERVICE>
   <token>
   added: <ISO date>
   ```
   Then run `chmod 600 ~/.developios/tokens.md`. Never echo a token back. Never commit `tokens.md`.

2. **Preferences.** When the user corrects how you work, or confirms a non-obvious approach, append a one-liner to the **Working preferences** section above with the date. Format: `- YYYY-MM-DD — <rule>. Why: <reason>.`

3. **Stay current.** If you notice a fact in this file is no longer true (role change, new OS, etc.), update it inline. Do not keep stale info.

4. **Don't write to backup.** The cron handles commits. You only edit the source files in `~/.developios/`.

## Developios reference docs

- [SOP — MCPs & CLIs by Role](https://www.notion.so/35dc990664318146a7bdd97980f8b47f)
- [AI Adoption Part 1](https://www.notion.so/35dc990664318101a1bcd87cc33a78d3)
- [AI Adoption Part 2](https://www.notion.so/35dc9906643181ef9fa2fea07097b137)
- [AI Adoption Part 3](https://www.notion.so/35dc990664318171b6ddcea4a4721dcb)
- [SOPs Dashboard](https://www.notion.so/297c9906643180e08b62d5b364d72f59)
```

### 3.5.2 Hook it into Claude Code's user-scope memory

Make `~/.claude/CLAUDE.md` reference the file. Logic:

- If `~/.claude/CLAUDE.md` does not exist → create it with a single line:
  ```
  @~/.developios/CLAUDE.md
  ```
- If it exists and does **not** already contain `@~/.developios/CLAUDE.md` → append the import line at the bottom.
- If it already contains the line → leave it alone.

Verify by `grep -F '@~/.developios/CLAUDE.md' ~/.claude/CLAUDE.md` and confirming a match.

Tell the user: "Memory file at `~/.developios/CLAUDE.md`. Future Claude sessions on this machine will read it automatically."

Update `profile.json` → `last_step: "memory"`.

---

## Step 4 — Role-specific toolkit

Walk through the items from the role matrix, in this order:

1. **Local MCPs** (`claude mcp add ...`)
2. **CLIs** (npm / brew / apt)
3. **Skill packs** (`npx skills add ...`)

For each: explain → check if already present → show command → "Run it? (y/skip/already)" → execute → log → tick checklist.

Do **not** prompt for Claude.ai connectors. Those are configured at the team account level.

Update `profile.json` → `last_step: "toolkit"`.

---

## Step 5 — Tokens (per-user only)

Most service tokens are shared via the team Claude account or team password manager. The only per-user tokens that need collection are listed in the **Role → Tokens matrix** below.

For each token, one at a time:

1. State what it's for in one sentence.
2. Show the exact URL.
3. Pause: "Paste the token when ready (or type 'skip')."
4. When they paste:
   - Append to `~/.developios/tokens.md`:
     ```
     ## <SERVICE_NAME>
     <token>
     added: <ISO timestamp>
     scope: <if provided>
     ```
   - Run `chmod 600 ~/.developios/tokens.md`.
   - Reply with "✅ Saved." — nothing else.
5. Move to next.

If skipped → log in `profile.json.skipped` and note in `tokens.md` as `## <SERVICE> — skipped on <date>`.

Update `profile.json` → `last_step: "tokens"`.

---

## Step 6 — Verification

Run a quick sanity check for each integration the user installed. Report green/yellow/red per item in a compact list.

| Check | How |
| --- | --- |
| Claude Code | `claude --version` |
| Fathom MCP (if installed) | `mcp__fathom__list_meetings` with `max_pages: 1` |
| Playwright MCP (if installed) | check it appears in `claude mcp list` |
| GitHub CLI (if installed) | `gh auth status` |
| Supabase CLI (if installed) | `supabase --version` |
| Vercel CLI (if installed) | `vercel --version` |
| Higgsfield CLI (if installed) | `higgsfield --version` |
| Context7 (if installed) | `ls ~/.claude/skills/find-docs/` |

Skip checks for skipped tools. Don't fail loudly — log and continue.

Update `profile.json` → `last_step: "verification"`.

---

## Step 6.5 — Local backup (daily git commits)

Set up `~/.developios/` itself as a local git repo, with a cron entry that commits the state daily. Local-only — no remote push. Tokens excluded.

### 6.5.1 Initialize the repo

Ask: "Set up daily local backups of your Developios state (profile, memory, checklist, reports)? Tokens are excluded. (y/n)"

If y:

1. **gitignore first** — write `~/.developios/.gitignore`:
   ```
   tokens.md
   *.log
   .DS_Store
   ```

2. **Init + first commit:**
   ```bash
   cd ~/.developios
   git init -q -b main
   git config user.name "<name from profile>"
   git config user.email "<email from profile>"
   git add -A
   git commit -q -m "initial onboarding snapshot $(date -u +%FT%TZ)"
   ```

3. Confirm: `git -C ~/.developios log --oneline | head -3`.

### 6.5.2 Install the daily cron

Check if cron is available: `command -v crontab`.

- **If available** (Linux / WSL / most macOS):

  Build the cron line:
  ```
  0 21 * * * cd ~/.developios && /usr/bin/git add -A && /usr/bin/git commit -m "daily snapshot $(date -u +\%FT\%TZ)" --allow-empty >> ~/.developios/backup.log 2>&1
  ```

  Append it idempotently:
  ```bash
  (crontab -l 2>/dev/null | grep -v 'developios/backup.log'; \
   echo '0 21 * * * cd ~/.developios && git add -A && git commit -m "daily snapshot $(date -u +\%FT\%TZ)" --allow-empty >> ~/.developios/backup.log 2>&1') | crontab -
  ```

  Verify: `crontab -l | grep developios`.

- **If cron is missing** (rare — some minimal macOS / WSL setups): tell the user and print this manual command they can run anytime, plus suggest enabling cron in their environment.
  ```bash
  cd ~/.developios && git add -A && git commit -m "snapshot" --allow-empty
  ```

If user says n: skip — note in `profile.skipped`.

Update `profile.json` → `last_step: "backup"`.

---

## Step 7 — Wrap up

Trigger a final backup commit if the backup repo was set up (Step 6.5):
```bash
cd ~/.developios && git add -A && git commit -m "onboarding complete $(date -u +%FT%TZ)" --allow-empty
```

Generate `~/.developios/onboarding-report-<YYYY-MM-DD>.md`:

```markdown
# Onboarding Report — <name>

- Role: <role>
- OS: <os>
- Meetings: <yes/no>
- Date: <ISO date>
- Duration: <minutes>

## ✅ Installed
- <each item>

## ⏸ Skipped
- <each item with reason>

## ❌ Failed
- <each item with error excerpt>

## 🧪 Verification
- <each check + status>

## 📋 Next steps
- Read [SOP — MCPs & CLIs by Role](https://www.notion.so/35dc990664318146a7bdd97980f8b47f)
- Read [AI Adoption Part 1](https://www.notion.so/35dc990664318101a1bcd87cc33a78d3)
- Read [AI Adoption Part 2](https://www.notion.so/35dc9906643181ef9fa2fea07097b137)
- Read [AI Adoption Part 3](https://www.notion.so/35dc990664318171b6ddcea4a4721dcb)
- Read [SOPs Dashboard](https://www.notion.so/297c9906643180e08b62d5b364d72f59)
- Join #ai-adoption on Slack
- Ping Faraz on Slack when ready for your first task
```

Tell them:
- "You're set. Report saved to `~/.developios/onboarding-report-<date>.md`."
- "Next: skim the SOPs in Notion, then ping Faraz on Slack."

Mark every remaining checklist item appropriately and display the final state.

Update `profile.json` → `last_step: "complete"`, `completed_at: <ISO>`.

---

## Role → Toolkit matrix

> **No Claude.ai connectors here.** Notion / Slack / Gmail / Calendar / Supabase / Vercel / Stripe / Smartlead / Clay / Ahrefs / Webflow / Indeed / Figma / Stitch etc. are configured at the team-account level. Users don't install them.

### Developer

**Local MCPs:**
- Fathom (if meetings) — `claude mcp add fathom -s user -- npx mcp-remote@latest https://api.fathom.ai/mcp`
- Playwright (optional, for E2E testing) — `claude mcp add playwright -- npx @playwright/mcp@latest`

**CLIs:**
- GitHub CLI — macOS `brew install gh` · Linux: see https://cli.github.com/manual/installation
- Supabase CLI — `npm install -g supabase`
- Vercel CLI — `npm install -g vercel`
- Context7 — `npx ctx7@latest setup --claude --cli -y` (installs `find-docs` skill)

**Skill packs:** none beyond `find-docs` (auto-installed by Context7).

### UI/UX Designer

**Local MCPs:**
- Fathom (if meetings) — same command as above

**CLIs:**
- Higgsfield — `npm install -g @higgsfield/cli && higgsfield auth login`

**Skill packs:**
- `npx skills add coreyhaines31/marketingskills --yes --global`
- `npx skills add higgsfield-ai/skills -y -g`

### AI & Automation Intern

**Local MCPs:**
- Fathom (if meetings) — same command as above

**CLIs:**
- Context7 — `npx ctx7@latest setup --claude --cli -y`

**Skill packs:**
- `npx skills add coreyhaines31/marketingskills --yes --global`

### Marketing / Paid Ads

**Local MCPs:**
- Fathom (if meetings) — same command as above

**CLIs:**
- Higgsfield — `npm install -g @higgsfield/cli && higgsfield auth login`
- Context7 — `npx ctx7@latest setup --claude --cli -y`

**Skill packs:**
- `npx skills add coreyhaines31/marketingskills --yes --global`
- `npx skills add higgsfield-ai/skills -y -g`

### Sales / SDR

**Local MCPs:**
- Fathom (if meetings) — same command as above

**CLIs:** none beyond foundations.

**Skill packs:**
- `npx skills add coreyhaines31/marketingskills --yes --global`

### Operations / Project Manager

**Local MCPs:**
- Fathom (if meetings) — same command as above

**CLIs:** none beyond foundations.

**Skill packs:** none required.

### Other / Founder

Walk every section above. Install the full set.

---

## Role → Tokens matrix

Most service API keys are shared via the team password manager. Ask Faraz on Slack for a shared key before generating your own. The following are typically per-user:

### Developer
- **GitHub PAT** (for git push/pull if using HTTPS) → https://github.com/settings/tokens?type=beta — scopes: `repo`, `read:org`. After saving, run `gh auth login` if you installed the GitHub CLI.

### UI/UX Designer
- **Higgsfield API key** → runs via `higgsfield auth login` in browser. No manual paste.

### AI & Automation Intern
- None per-user by default. Ask Faraz for shared keys (Make / Clay / Smartlead) if needed.

### Marketing / Paid Ads
- **Higgsfield API key** → `higgsfield auth login`
- Smartlead / Clay / Ahrefs: ask Faraz for shared keys.

### Sales / SDR
- None per-user by default. Ask Faraz for shared Smartlead / Clay keys.

### Operations / PM
- None per-user by default.

### Founder
- All of the above + any service-specific keys you generate.

---

## Reference docs (for the wrap-up step)

Always link these in the final report:

1. **SOP — MCPs & CLIs by Role** — https://www.notion.so/35dc990664318146a7bdd97980f8b47f
2. **AI Adoption Part 1 — Foundations & End-to-End Workflow** — https://www.notion.so/35dc990664318101a1bcd87cc33a78d3
3. **AI Adoption Part 2 — Design–Dev Workflow** — https://www.notion.so/35dc9906643181ef9fa2fea07097b137
4. **AI Adoption Part 3 — Planning to Go Live** — https://www.notion.so/35dc990664318171b6ddcea4a4721dcb
5. **SOPs Dashboard** — https://www.notion.so/297c9906643180e08b62d5b364d72f59
