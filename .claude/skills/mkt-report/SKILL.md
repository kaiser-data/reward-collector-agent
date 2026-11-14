---
description: Turn campaign numbers into a short report: totals, what stood out, and the sums shown. Add a CSV, or it uses data/campaign-numbers.csv.
---
Report on: $ARGUMENTS
(If nothing is given, use data/campaign-numbers.csv.)

## Steps
1. Read memory.md and the numbers file. Note any cell that is empty or not a plain number (like "1.2k"): don't guess it, leave that row out of that sum and say so.
2. Per platform: number of posts, total impressions, likes, comments and link clicks. Write each sum out (for example 4,210 + 2,150 + ... = 10,890), so it can be checked.
3. Find the outliers: posts far above or below the others on the same platform, by impressions or by clicks per 1,000 impressions. Say which number makes each one stand out.
4. Write one new draft in drafts/, named like drafts/2026-11-16-campaign-report.md: 3 lines on what happened, the totals table with the sums, the outliers, what the data can't tell you, and one suggestion for next month based on the best posts.
5. Reply with the 3 lines, the rows you left out and why, and the file name.

## A good result
- Every total can be checked from the sum written next to it.
- A missing or messy cell is named, never filled in.
- The suggestion follows from a number in the report, not from general marketing advice.
