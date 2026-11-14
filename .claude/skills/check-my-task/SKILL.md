---
name: check-my-task
description: Check your agent's task against real data on how people use Claude (Anthropic Economic Index) and get one verdict for your build. Run /check-my-task, optionally followed by the task.
allowed-tools: Read, Grep
---

# Check my task

Finds the tasks in real usage data closest to the person's task, quotes them, and gives one verdict for their build.
Write for a non-technical founder reading quickly. Short lines, plain words. Answer in the language they write in.

Data: `${CLAUDE_SKILL_DIR}/usage.tsv`. Lines starting with `#` say what it is. Then one line per task, tab-separated:
`task_id`, `verdict`, `handed_over_pct`, `automation_pct`, `augmentation_pct`, `usage_share_pct`, `rare`, `task` (the O*NET task text).

## Step 1: the task

If they gave the task (`$ARGUMENTS`), use it. Otherwise ask only:
"Paste your agent's job sentence, or say the task in a few words."
If what they said names no concrete work (like "help with my business"), ask once, then search on the answer:
"Which task exactly? What goes in, and what should come out?"

## Step 2: search

Pick 3 to 6 words for the work itself: verbs and things (invoice, reconcile, reply, complaint, schedule, post, proposal). Use English words, whatever language they wrote in.
Grep the data file for them, case-insensitive, one pattern with `|` between the words. Never Read the whole file.
If that finds nothing useful, try once more with other words for the same work.

From what you found, keep at most 3 lines whose `task` describes the same work as theirs, the closest first. Judge only on the task text, never on the verdict or the numbers. Between two equally close lines, take the one without `rare`.
- Close: the task text describes the same work in other words.
- Loose: it covers only part of their task. Say which part.
- None: nothing describes their work. Go to "No match".

## Step 3: the answer

Reply in this shape and nothing more. Copy the task text and every number from the lines exactly as they are in the file. Never compute, average or round a number, and never print a number that is not on a line you quote.

```
Your task: <their task, in a few words>

Closest tasks in the data (<Close match | Loose match: only the part about …>):
1. "<task>": <verdict>, <handed_over_pct>% handed over (<automation_pct>% hand it over, <augmentation_pct>% stay involved)
2. …

Verdict: <line 1's verdict>
For your build: <the line for that verdict, below>

What this is: how people used Claude for these tasks in April and May 2026: conversation styles, not job outcomes. It isn't a prediction and doesn't say what AI can or can't do. Whether it fits today's agent (reads text files, writes drafts) is a separate question.
Data: Anthropic Economic Index, release 2026-06-26 (Claude.ai), CC BY 4.0, anthropic.com/economic-index. Task text: O*NET 31.0 by USDOL/ETA (CC BY 4.0).
```

After a line marked `rare`, add " (few conversations, so only a hint)". For a line whose verdict is `No split published`, write the verdict and leave out the numbers.
The Verdict line takes line 1's verdict, with two changes: when line 1 is `rare`, write "Leans <verdict>, only a hint: few conversations"; when it is `No split published`, write "Use your judgment".
If the lines you quote have different verdicts, add one line after the verdict: "The other close tasks lean differently, so keep your own judgment in it."
If their task works on video, audio, images or anything physical, add one line after "For your build": "Today's agent reads and writes text only, so build it around the text part (the brief, the notes, the list)."

The line for each verdict:
- AI does it: "People mostly hand this kind of task to Claude. Let your agent draft it whole; your approval step stays."
- AI assists, you verify: "People mostly stay involved in this kind of task. Have your agent draft it, and check the facts and numbers yourself before anything goes out."
- Use your judgment (and No split published): "The data doesn't decide this one. Start with a draft you check line by line, and hand over more only after a few clean runs."

Then one line: "Paste the Verdict line into the page, under Data check."

## No match

```
Your task: <their task, in a few words>

The data has no close match for this task, so there's no number to give.
Verdict: Use your judgment
For your build: start with a draft you check line by line, and hand over more only after a few clean runs.

Data: Anthropic Economic Index, release 2026-06-26 (Claude.ai), CC BY 4.0, anthropic.com/economic-index.
```

Then one line: "Paste the Verdict line into the page, under Data check."
