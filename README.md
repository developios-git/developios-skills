# Developios Skills

Claude Code skills built for the Developios team. Pull, install, and use them inside Claude Code (Cursor / VS Code / terminal).

This repo is **Claude Code only** — it does not configure Claude Desktop or Claude.ai connectors. Those are managed at the team-account level and shared across the team.

---

## What's inside

| Skill | What it does |
| --- | --- |
| `developios-onboarding` | Interactive onboarding for new teammates. Asks name/role, generates a personalized install checklist, then walks through local MCPs, CLIs, skill packs, and tokens — one step at a time. |

More skills will be added over time. Every skill is its own folder containing a `SKILL.md` that Claude reads when invoked.

---

## Install (one-time, per teammate)

### Option 1 — Clone + installer (recommended)

```bash
git clone https://github.com/developios-git/developios-skills.git
cd developios-skills
bash install.sh
```

### Option 2 — Manual symlink

```bash
mkdir -p ~/.claude/skills
ln -sfn "$(pwd)/developios-onboarding" ~/.claude/skills/developios-onboarding
```

### Verify

```bash
ls ~/.claude/skills/ | grep developios
# Should print: developios-onboarding
```

---

## How to use

1. Open Claude Code (Cursor extension, VS Code extension, or terminal).
2. Type any of these — Claude will pick up the skill automatically:
   - `/developios-onboarding`
   - `onboard me`
   - `I'm new at Developios, set me up`
   - `help me install everything I need`

The skill takes over from there. It asks one question at a time, shows you the full install checklist for your role, runs install commands for you, and collects any per-user tokens safely.

---

## What gets created on your machine

The onboarding skill creates a small profile + token vault under your home directory:

```
~/.developios/
├── profile.json                # Your name, role, OS, install timestamps
├── checklist.md                # Live task list — ticks as items are installed
├── CLAUDE.md                   # Persistent memory file — future Claude sessions read this
├── tokens.md                   # API keys (chmod 600, gitignored, never echoed)
├── onboarding-report-*.md      # Summary of what got installed
├── .git/                       # Local backup repo (no remote)
├── .gitignore                  # Excludes tokens.md and *.log
└── backup.log                  # Output of the daily cron
```

**Memory file.** The onboarding skill creates `~/.developios/CLAUDE.md` and imports it from `~/.claude/CLAUDE.md` so every future Claude Code session on this machine reads it. The file holds your identity, working preferences (Claude appends here when it learns how you like to work), and maintenance rules for handling tokens and preferences.

**Daily local backup.** During onboarding, the skill offers to init `~/.developios/` as a local git repo and install a cron entry that commits the state every day at 9 PM. No remote — your snapshots stay on your machine. `tokens.md` is gitignored.

**Tokens never leave your laptop.** They are not echoed back, not committed to git, not sent anywhere.

---

## For maintainers

### Adding a new skill

1. Create a folder under the repo root named after the skill.
2. Add a `SKILL.md` with this frontmatter:

   ```markdown
   ---
   name: skill-name
   description: One line on when Claude should invoke this — be specific about trigger phrases.
   ---

   # Skill body
   Step-by-step instructions Claude follows when invoked.
   ```

3. Re-run `bash install.sh` (or ask the team to re-run) — the new skill auto-links.

### Updating an existing skill

Edit the `SKILL.md`. Symlinks point at the source, so changes are live the next time the user opens Claude Code.

### Pushing updates to the team

```bash
git add .
git commit -m "feat: ..."
git push
```

Teammates run `git pull && bash install.sh` to get the update.

---

## Troubleshooting

- **"Claude doesn't pick up the skill"** — restart Claude Code. Then run `ls ~/.claude/skills/` to confirm the symlink exists.
- **"install.sh permission denied"** — `chmod +x install.sh` first.
- **"On Windows"** — use WSL2. Run install commands inside your WSL shell.
- **"Skill triggers when I don't want it to"** — tighten the `description` field in `SKILL.md`.

---

## Owner

Faraz · Developios · #ai-adoption on Slack
