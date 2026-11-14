# Made by Anthropic, included as published

Two skills in `.claude/skills/` are Anthropic's own, copied unchanged. Both are under the Apache License 2.0; the
licence is in each skill's folder.

- `skill-creator/`: Anthropic's skill for making skills, from https://github.com/anthropics/skills (folder
  `skills/skill-creator`, commit `2c5958ecac7cee2b583967a2c4981d0f4a75c579`). Copyright 2026 Anthropic, PBC; licence
  in `skill-creator/LICENSE.txt`. Its test, benchmark and packaging parts run scripts, which ask you first in this
  kit; the workshop uses it to interview you, write the skill and try it once.
- `claude-md-improver/`: Anthropic's skill for grading and improving a CLAUDE.md, from
  https://github.com/anthropics/claude-plugins-official (plugin `claude-md-management`, folder
  `skills/claude-md-improver`, commit `099387b7a2ea02022bb850becca750246ae12562`). Its `LICENSE` is the plugin's
  licence file, copied into the folder.

No file in either was changed.

The whole kit also has `take-home/mcp-builder/`, Anthropic's skill for building MCP servers, unchanged from the same
anthropics/skills commit; see `take-home/README.md`.
