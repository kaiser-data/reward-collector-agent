---
name: get-rewards
description: Find leads in the Apify export, draft course recommendations, replies and follow-ups for approval, ranked by expected reward. Run every 2 weeks or month.
---

# Get rewards

Find people who fit a course and draft the messages that earn referral rewards.
The goal is one number: reward earned ÷ (my minutes + token cost + extra costs). My time is the biggest cost, so everything here is built to make my part a quick read and a yes.

## Steps
1. Read from data/: apify-export.csv and every CSV in data/examples/ (contacts, source, classification, interest, notes), email-history.csv (sent and received), courses.csv (courses, referral link, reward_eur), results.csv (past runs). Read each file once. If the same email appears in more than one file, treat it as one person. Without the export or the courses, stop and say what is missing. Without the other two, go on and say so at the end.
2. Put each contact in one state, using email-history.csv:
   - Never: classified do-not-contact, or asked not to be contacted. No message, ever.
   - Reply: they wrote back and nobody answered yet. These are the warmest leads, so they go first.
   - Wait: last message to them was under 14 days ago.
   - Follow-up: one message sent 14 or more days ago, no reply. After 2 follow-ups without a reply, stop writing to them.
   - New: never contacted.
3. Keep only career switchers (classification career-switcher). They have the clearest reason to take a course, so they are the whole target. List everyone else under Skipped. A Reply still gets handled, whoever it is from.
   Match each one to one course by interest. No fitting course, or no real reason for it in their notes: skip and list them. A weak match costs my time and earns nothing.
4. Rank: Reply first, then partner lists (the source column: warm, they know the partner), then my own contacts, then cold sources like Reddit. Inside each group, highest reward_eur first.
5. Skip on cost only when results.csv can prove it: once it holds signups from 3 or more runs, work out the reward per message sent, and skip leads whose course reward times that rate is below the cost of approving one message (about 1 minute at hourly_rate_eur). Before that, rank but don't skip. Never guess a conversion rate.
6. Draft at most 5 messages per run, the top 5 by rank; follow-ups count toward the 5. Five messages written for one person each beat twenty that could go to anyone. List the rest under Skipped as "next run".
   Each text is under 80 words: a first line about this person (how I know them, or what they told me, from their notes), one course and the one fact that makes it fit them, the referral link, one easy question. If a sentence could be sent to someone else unchanged, rewrite it. Don't mention my employer, my science work or my startup: these are private recommendations, sent from my private address. Always say I'm an ambassador and may earn a reward: it is honest and it keeps trust with the partners.
   - Reply: answer only from data/. If the answer isn't there (a price, a date), don't draft; put the question under "Needs you".
   - Follow-up: shorter than the first message, a new angle, an easy way to say no.
   - A contact with no email (a Reddit lead): draft a helpful public comment for me to post, not a direct message. Cold direct messages get accounts banned.
7. Write one new draft in drafts/, named like drafts/2026-11-16-get-rewards.md:
   - Needs you: at most 3 lines, only what blocks a message.
   - Ranked table: name, source, course, reward_eur, state.
   - The texts, in ranked order.
   - Skipped, with the reason per person.
   - Profit: from results.csv, reward_eur − (minutes_spent ÷ 60 × hourly_rate_eur + token_cost_eur + extra_costs_eur), in total and per hour of my time. If a number is missing, name it instead of calculating.
8. End with a 3-line summary and a list of anything you couldn't find.

## What a good result looks like
- Runs in one go with no questions. I read for 5 minutes and approve.
- The best leads are on top, so if I stop reading halfway I still sent the ones that pay most.
- Every message reads like it was written for that one person.
- Nobody is contacted twice in 14 days, and nobody marked Never is contacted at all.
- No number, price or promise that isn't in data/.

## Hand-off
Put each outgoing item in drafts/outbox/ as one file with To, Subject and the exact text. Show them in ranked order and ask "Send this? yes / no / change" for each. Nothing goes out without my yes to that exact text. If I change it, show the new text again. "Yes to all" covers only texts already shown and unchanged. Without a connector I send them myself after the yes.

When I say they are sent, ask once: "Log these in email-history.csv and results.csv? yes / no". On a yes, add one row per sent message to email-history.csv and fill what you know in today's results.csv row (date, messages_sent). The next run depends on this: without it the 14-day rule can't work. Ask me for minutes_spent, token_cost_eur and signups; never fill them in yourself.
