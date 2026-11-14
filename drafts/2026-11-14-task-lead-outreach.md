# Draft: my task (lead outreach). Not final, needs your edit.

## Task sentence
Every month, my agent reads my database of leads and drafts a message for each one, recommending a suitable course, for me to approve.

## Split
- Enrichment agent (separate): adds the fields below to each lead before this agent runs.
- This agent: reads the finished database, drafts messages only. Sends nothing.

## Proposed fields (my suggestion, replace with what your database really has)
- name
- contact (email)
- role
- interest (topic they care about)
- source (where the lead came from)

## Rules for the agent
- If a lead has no interest filled in, say so and skip it. Never guess a course.
- Recommend only courses you list for it. No course list exists in this folder yet.
- Each message goes to drafts/outbox/ as one file (To, Subject, exact text). You say yes / no / change.
- Referral rewards: track them yourself. The agent only drafts.

## Open
- Where is the lead database (file name)? Not in this folder yet.
- Where is the course list?
