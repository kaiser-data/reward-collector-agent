#!/bin/sh
# Workshop step C1: copies your starter to a new folder, my-agent, in Downloads.
#
#   sh copy-my-agent.sh finance          (or marketing, sales, ops, dev)
#
# Type it in your starter folder, or in the whole kit's top folder: it finds the starter from where this file is,
# so it works wherever you unzipped the kit. An earlier my-agent is kept as my-agent-old-<time>, never deleted.
# When it can't make the right copy it changes nothing and says what to do.

track=$1
here=$(cd "$(dirname "$0")" && pwd -P)
to="$HOME/Downloads/my-agent"

if [ -z "$track" ]; then
  echo "Add your track after it, like: sh copy-my-agent.sh finance"
  exit 1
fi
if [ -d "$here/agents" ]; then
  from="$here/agents/$track"
else
  from="$here"
fi
if [ "$from" = "$(cd "$to" 2>/dev/null && pwd -P)" ]; then
  echo "This is already your my-agent folder. Type: claude"
  exit 1
fi
if [ ! -d "$from/.claude/skills" ]; then
  echo "There's no $track starter in $here/agents. Check the spelling: finance, marketing, sales, ops or dev."
  exit 1
fi
case $(basename "$from") in
  "$track"*) ;;
  *)
    echo "This folder is the $(basename "$from") starter, not $track. Type the command with $(basename "$from"), or cd into your own starter first."
    exit 1
    ;;
esac
if [ -e "$to" ]; then
  old="$to-old-$(date +%H%M%S)"
  mv "$to" "$old"
  echo "Your earlier my-agent is kept as $old"
fi
cp -R "$from" "$to"
echo "Copied your $track starter to $to"
