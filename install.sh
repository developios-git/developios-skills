#!/usr/bin/env bash
# Developios Skills installer
# Symlinks every skill folder in this directory into ~/.claude/skills/

set -e

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/skills"

echo "Developios Skills installer"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

mkdir -p "$TARGET_DIR"

linked=0
skipped=0

for skill_dir in "$SOURCE_DIR"/*/; do
  skill_name="$(basename "$skill_dir")"

  # Skip non-skill folders (no SKILL.md inside)
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    continue
  fi

  link_path="$TARGET_DIR/$skill_name"

  if [ -L "$link_path" ] || [ -e "$link_path" ]; then
    # Already linked — refresh it
    rm -rf "$link_path"
  fi

  ln -s "$skill_dir" "$link_path"
  echo "  linked  $skill_name"
  linked=$((linked + 1))
done

echo ""
echo "Done. $linked skill(s) linked into $TARGET_DIR"
echo ""
echo "Next: open Claude Code and try:"
echo "    /developios-onboarding"
echo "    onboard me"
