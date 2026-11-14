#!/bin/sh
# Opens dashboard.html filled in with this agent's run logs and test grades. Type it yourself in Claude Code:
#
#   ! bash .claude/dashboard.sh
#
# Claude Code keeps one run log per session in ~/.claude/projects/<this folder's path, every character
# other than a letter or digit turned into ->. This finds that folder, every grades.md under
# drafts/tests and the checklists in drafts/tests/checklists, and writes a copy of dashboard.html with
# them inside to your temp folder, outside this folder, so the logs can never be pushed with it. It
# reads, writes that one file and opens it; nothing leaves your laptop. Windows twin: dashboard.ps1.

cd "$(dirname "$0")/.." || exit 1
here=$(pwd -P)
projects="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"
logs="$projects/$(printf '%s' "$here" | sed 's/[^A-Za-z0-9]/-/g')"
# Not under that name (a very long path is shortened): find the logs that say they ran in this folder.
if [ ! -d "$logs" ]; then
  found=$(grep -l -F "\"cwd\":\"$here\"" "$projects"/*/*.jsonl 2>/dev/null | head -n 1)
  [ -n "$found" ] && logs=$(dirname "$found")
fi
if [ ! -d "$logs" ]; then
  echo "No run logs for $here yet. Run one of your jobs in Claude Code here first, then type this again."
  exit 1
fi
newest=$(find drafts/tests -name grades.md -type f -exec ls -t {} + 2>/dev/null | head -n 1)
out="${TMPDIR:-/tmp}/my-agent-dashboard.html"
marker='<!-- dashboard.sh puts the run logs and grades here -->'

# One file as a block the page reads and never runs. Every "<" becomes the JSON escape u003c (backslash
# first), so nothing in a file can end the block; in a log's JSON that is the same character, and the
# page turns it back for the grades.
block() {
  printf '<script type="text/plain" %s="%s">\n' "$1" "$2"
  LC_ALL=C sed 's/</\\u003c/g' "$3"
  printf '</script>\n'
}

umask 077
{
  sed "/^$marker\$/q" dashboard.html
  for f in "$logs"/*.jsonl "$logs"/*/subagents/*.jsonl; do
    [ -f "$f" ] && block data-log "logs/${f#"$logs"/}" "$f"
  done
  find drafts/tests -name grades.md -type f 2>/dev/null | while IFS= read -r g; do
    block data-grades "$(printf '%s' "$g" | tr -d '"<>&')" "$g"
  done
  for c in drafts/tests/checklists/case-*.md; do
    [ -f "$c" ] && block data-checklist "$(printf '%s' "$c" | tr -d '"<>&')" "$c"
  done
  sed "1,/^$marker\$/d" dashboard.html
} > "$out"

echo "Run logs: $logs"
echo "Newest grades: ${newest:-none yet (step C4 makes them)}"
xdg-open "$out" 2>/dev/null || open "$out" 2>/dev/null || echo "Open this file in your browser: $out"
