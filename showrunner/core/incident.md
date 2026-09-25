# Incident Mode

When production is broken, the priority is to stop the harm, not to follow
the build lifecycle. Incident mode lets ShowRunner act fast on what the owner
already approved, and routes everything else - including the real fix - back
through the normal stages once the product is stable. It is not a waiver and
never becomes a shortcut for ordinary work.

## 1. What Counts

An incident is a live problem hurting users or the business now:

- the product, or a core flow such as sign-in, checkout, or saving data, is
  down or badly broken in production;
- data may be lost, corrupted, or exposed;
- a security breach or active attack is suspected;
- payments, emails, or other external effects are going wrong;
- a release's post-release check failed.

A bug that is annoying but not harming users or data now is not an incident;
it is a new request at `intake`.

When the owner reports something ("the site is down", "customers can't pay"),
or a check ShowRunner runs shows it, ShowRunner states plainly whether it
treats it as an incident and why, and asks the owner to confirm in one line.
When users are being harmed right now and the owner already approved a
rollback, it may start step 3 before the confirmation and say so.

## 2. Open The Incident

Record in the ledger: an incident id (`INC-<n>`), time, the report in the
owner's words, what is affected, and who is involved. Set
`active.status: blocked` on the current initiative with the incident as the
reason; the initiative resumes afterward exactly where it was.

## 3. Stabilize - Only Pre-Approved Or Owner-Approved Actions

In order of preference:

1. **Roll back** using the rollback plan the owner approved at the last
   release ([release.md](release.md)): the exact commands or console steps
   recorded then, to the recorded previous version. ShowRunner runs them only
   when the owner authorized ShowRunner as executor for that release;
   otherwise it gives the owner the checklist.
2. **Switch off** the failing feature through a flag the owner already approved
   as a kill switch.
3. **Anything else** - a hotfix deploy, a data repair, rotating credentials,
   blocking traffic, contacting a provider - needs the owner's explicit words
   for that specific action, given now. Recommend the smallest action that
   stops the harm; state what it risks.

Never edit product code on the primary branch, bypass hooks, delete data, or
improvise a deploy target during an incident. Preserve evidence: logs,
error reports, timestamps, and what was changed when.

Credentials that may be exposed are the owner's to rotate
([ownership.md](ownership.md)); ShowRunner lists which ones and where they are
used.

## 4. Communicate

Draft, for the owner to approve and send, a short status message for affected
users when needed. For suspected personal-data exposure, tell the owner
plainly that data-protection laws in many places set notification duties and
short deadlines, cite the applicable regulator's published guidance under the
evidence standard, and recommend a qualified lawyer immediately. Never notify
users, regulators, or the press on the owner's behalf.

## 5. Stable - Then The Real Fix

When the harm has stopped (rolled back, switched off, or otherwise contained),
record the time and evidence, and close the emergency phase. The actual fix is
opened as a new initiative at `intake`, first in the queue, and runs every
stage. A hotfix deployed under step 3 with the owner's approval is still
followed by that initiative, which reviews it properly and adds the tests that
would have caught it.

## 6. Incident Review

Within a few days, write a short, blameless review with the owner:

- what happened, when, and the impact (users, data, money), evidenced;
- how it was detected and how long each phase took;
- the root cause, found with [debugging.md](debugging.md), not the first
  plausible story;
- what worked and what did not in the response;
- follow-ups: tests, monitoring, a Sentry regression-catalog entry for security
  incidents, rollback or kill-switch gaps, and account or access fixes -
  each opened as an initiative or recorded as an owner decision.

Record the review in the ledger's incident row and link it from the project
state.
