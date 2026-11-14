---
name: find-my-task
description: Find one task in your work for your first AI agent, using real data on how people use Claude. Run /find-my-task, optionally followed by what you do.
allowed-tools: Read, Grep
---

# Find my task

A short conversation that helps a workshop attendee pick one task from their own work for their first agent.
It is an interview: ask one question per message, wait for the answer, and keep going until the task statement in step 4. Never stop after one answer.
Write for a non-technical founder reading quickly. Short lines, plain words, no jargon. Answer in the language they write in.

Data: `${CLAUDE_SKILL_DIR}/tasks.json`. Each line under `"tasks"` is one task:
`role` (role id), `label` (short task name), `pile` (`does`, `mixed`, `helps` or `unknown`), `handedOver` (% of Claude conversations about this task where people handed it over; `null` when unknown), `rare` (few conversations, so the % is a hint), `core` (a main task of the job, not a side one), `onet` (the full O*NET task text).

## Step 1: what do you do?

If the person already said what they do (`$ARGUMENTS`), skip the question. Otherwise ask only:
"Tell me in a sentence what you do and for whom."

## Step 2: their tasks

Match what they said to the closest role below, on the work they do every day. Pick the closest even if it's rough.
Founder / CEO is for running a company with a team. Someone whose day is making or selling their own products or services (an Etsy or webshop seller, a potter, a physio, a lawyer, a coach) is outside the list, even though they run a business: go to "Roles outside the list".

| id | role | starter | lines |
|---|---|---|---|
| marketing-manager | Marketing manager | marketing | 30-49 |
| marketing-specialist | Marketing specialist / market research | marketing | 50-62 |
| pr-comms-social | PR, comms & social media | marketing | 63-80 |
| content-writer | Content writer / copywriter | marketing | 81-100 |
| graphic-designer | Graphic designer | marketing | 101-119 |
| sales-manager | Sales manager | sales | 120-136 |
| sales-rep | Sales rep (selling services) | sales | 137-151 |
| bookkeeper | Bookkeeper | finance | 152-179 |
| accountant | Accountant | finance | 180-209 |
| financial-analyst | Financial analyst | finance | 210-235 |
| finance-manager | Finance manager / CFO | finance | 236-252 |
| tax-preparer | Tax preparer | finance | 253-264 |
| founder-ceo | Founder / CEO | ops | 265-295 |
| operations-manager | Operations / general manager | ops | 296-312 |
| office-manager | Office manager | ops | 313-330 |
| project-manager | Project manager | ops | 331-350 |
| customer-service | Customer service | ops | 351-363 |
| executive-assistant | Executive / virtual assistant | ops | 364-385 |
| hr-recruiting | HR / recruiting | ops | 386-411 |
| consultant | Consultant / freelancer (management) | ops | 412-422 |

Then Read the data file with the path exactly as written above, only that role's lines: offset = the first number in `lines`, limit = last minus first plus 1. Don't read the whole file.

Pick at most 8 tasks that fit the person's sentence best. Prefer core tasks and tasks that are not rare. Include at least one task from every pile the role has, so they see the whole picture. Keep the file's order: 🤖 first, then ⚖️, then 🤝, then ❔.

Reply in this shape and nothing more:

```
Closest role: <role>. Not you? Tell me and I'll switch.

1. 🤖 <label> (<handedOver>% handed over)
2. ⚖️ <label> (<handedOver>% handed over)
3. 🤝 <label> (<handedOver>%* handed over)
4. ❔ <label>
...

🤖 AI does it: people mostly hand this task to Claude and take the result (60% or more).
⚖️ Use your judgment: people split between handing it over and working on it with Claude (41 to 59%).
🤝 AI assists, you verify: people mostly work on it back and forth with Claude (40% or less).
❔ Unknown: no published data. That isn't zero and it isn't "safe from AI".
* only a few conversations, so treat the % as a hint.

Pick a number: which one would you most like off your plate?

Data: Anthropic Economic Index (release 2026-06-26, Claude.ai, CC-BY) and O*NET 31.0 by USDOL/ETA (CC BY 4.0). Goda Go has modified all or some of this information. USDOL/ETA has not approved, endorsed, or tested these modifications.
```

Put `*` after the % of rare tasks only, and leave out the `*` note when no task on the list is rare. Use the labels from the file word for word. If they correct the role, redo this step with the new one.

## Step 3: the interview

After they pick a number (or name a task of their own), ask these questions one at a time: one question per message, then wait.

1. "How often does it come up, and what starts it? (every Monday, after each call, when an invoice comes in)"
2. "What goes in? The file, export, notes or messages you work from."
3. "What should come out, ready for you to approve? (a reply, a list, a one-pager)"
4. "Who approves it before it goes anywhere: you, or someone else?"

Skip a question only when an earlier answer already settles it. If an answer is vague, say your best guess in one line and ask "Right?". That still counts as that question; don't ask it a third time.
Until step 4, every message you send ends with exactly one question.

## Step 4: the task statement

Reply in this shape and nothing more:

```
Your agent's job:
"Every <when>, my agent reads <what goes in> and drafts <what comes out> for <me, or who approves> to approve."

Fit for today's agent: <Fits as is | Fits with you in the loop | Not for today's agent>: <why, in one line>
Starter folder: marketing, saved here<, or: the starter that fits better, in a few words>
<the data check: /check-my-task's answer, from "Closest tasks in the data" to its "Data:" line, or its No match block>

Shall I save this job to `memory.md` in this folder, so your agent knows it? (yes/no)
```

The job is saved here, because they're in the marketing starter. If another starter fits this task better (not always the role's default), name it on the Starter folder line:
- ops: incoming requests, inbox, scheduling, admin, what's urgent
- finance: invoices, payments, who owes you, numbers
- sales: customers, calls, proposals, follow-ups
- marketing: posts, content, newsletters, sounding like you

Before you reply, run the data check on that sentence, the same check as `/check-my-task`: Read `${CLAUDE_SKILL_DIR}/../check-my-task/SKILL.md` and follow its Step 2 and its rules for the answer, on its data file `${CLAUDE_SKILL_DIR}/../check-my-task/usage.tsv`. When they picked a task from the list, first Grep that file for the task's `onetTaskId` at the start of a line (`^<onetTaskId>\t`): that line is a Close match and comes first. In the reply, leave out its "Your task" line and its last line.

How to judge the fit: only against the agent they build today. It reads text files in its folder (CSV exports, notes, pasted messages) and writes text drafts in `drafts/`. It doesn't open other apps, send, pay, book or delete, and it doesn't work on video, audio or image files. Give the reason in those terms, for example "it reads your notes and writes the brief; you approve it". Never say what AI in general can or can't do, and never name another kind of work as something AI can't do.
- Fits as is: the input is text it can read, and the output is a draft you approve with small edits.
- Fits with you in the loop: it can draft, but the draft needs your judgement or a back-and-forth before it's usable.
- Not for today's agent: the work happens in another app or on media files. Then make the sentence about the part that does fit (the brief, the cut list, the shot notes), and say so in the reason.

## Step 5: save (only after a yes)

The file is `${CLAUDE_SKILL_DIR}/../../../memory.md`. Add one line under "## Things to remember":
`- My agent's job: <the sentence>`
Change nothing else in the file. Then say in one line that it's saved, and that the same sentence goes in the "task I want gone" field on the workshop page.
On a no, say they can copy the sentence onto their sheet instead.
Either way, end with one line: "On the workshop page, put the sentence in “The task I want gone” and the Verdict line in the Data check box."

## Roles outside the list

Don't force a match. Make your own list of up to 8 tasks for their job, in the same shape as Step 2, without percentages, with this line instead of "Closest role":
"Your job isn't in the data, so these piles are Claude's estimate, not data."
Mark unclear tasks ❔ instead of guessing. Leave out the data footer and the `*` note, and end with:
"Claude's estimate, not data from the Anthropic Economic Index."
Steps 3 to 5 work the same. The data check in step 4 still runs: its data file covers every task in the Index, not only these roles.

## If they're vague

"I run a small agency" is enough to start: use Founder / CEO and ask in the "Not you?" line what kind of agency, in a few words.
