---
description: Run your test set for a job again as a new round, then grade it blind. Type /run-tests and the job's name, like /run-tests ops-actions.
argument-hint: <job name>
disable-model-invocation: true
---
The job to test: $ARGUMENTS

If no job is given, ask which job to test, by its name (the one you type after the slash, like ops-actions), and wait for the answer. Don't guess. Drop a leading "/". If .claude/skills/<job>/SKILL.md doesn't exist, say so and list the jobs in .claude/skills/. If drafts/tests/cases/ doesn't exist yet, say the test set is written first (step C4 of the workshop) and stop.

Below, <job> is that name.

Run my test set for /<job> as a new round: round-1 if drafts/tests/ has no round folder yet, else the next number. Use the <job> skill the way it really runs, one run at a time, with the files in drafts/tests/cases/case-N/ in place of data/ (leave out data/examples/). Run cases 1 to 3 once, cases 4 and 5 three times each (and case 6 three times, if there is one). Save each run's draft, anything it put in drafts/outbox/, and its closing summary as summary.md in drafts/tests/round-R/case-N/run-T/. Send nothing, change no case and no checklist, and don't read drafts/tests/checklists/ yourself. The only shell command you or any subagent may run is `ls -R` on a folder in drafts/tests/, to see its files; tell every subagent the same. Read and write the files with your file tools, which make folders as needed. Subagents can't save summary.md: have each return its closing summary as text, and save it yourself.

Then grade blind: start a subagent that reads only drafts/tests/checklists/, drafts/tests/cases/ and the round folders in drafts/tests/, never CLAUDE.md, memory.md or .claude/. For every run it grades each checklist line PASS or FAIL and quotes the line of the draft or summary.md that proves it; no quote is a FAIL, and a never line passes when nothing does it. It writes drafts/tests/round-R/grades.md, starting exactly like this:

# Grades · round R · /<job>
Result: X of 5 cases pass · normal cases run once, vague and trap 3 times · graded blind

| Case | Kind | Passed | Before | Fails on |
|---|---|---|---|---|
| 1 | normal | 1 of 1 | – | |

One row per case. Kind is normal, yours, vague, trap or stretch. Passed is the runs that passed every line. Before is the same case in the round before, – in round 1. Fails on is the first line that failed. Under the table, per case, every checklist line with PASS or FAIL per run and its quote. Then tell me in one plain line per case what happened.
