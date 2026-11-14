# Where my agent's information comes from

Job: Every 2 weeks or month, find leads in my contacts, draft messages and follow-ups that recommend suitable courses, and earn referral rewards when they sign up.

| What the job needs | Where it lives | How the agent gets it | Group |
|---|---|---|---|
| Apify export (scraped contacts, with emails and classification column) | Apify account, downloaded as CSV | Save it as a CSV in data/ (e.g. data/apify-export.csv) | Works today |
| Email messages and history | Local CSV, one row per message | Save it as a CSV in data/ (e.g. data/email-history.csv) | Works today |

## Why
- Apify export: a CSV I download myself. Contact emails and the classification are columns in the same file, so no separate input.
- Email messages and history: a local CSV, so the agent can see who was already contacted and what was said.
- Later, if the data gets bigger, a database could replace the CSVs. Not needed now.

## What this agent should NOT have access to
- My email inbox or Apify login. It reads only the CSVs I put in data/.
- Anything it sends without my yes to the exact text. Messages go to drafts/outbox/ first.
- Everything in these CSVs is private, for me only. Contact details stay in data/: never in memory.md, never in anything shared, never published.

## Do next: 1 thing
Put the Apify export CSV and the email history CSV in data/.
