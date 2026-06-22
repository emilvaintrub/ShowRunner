# Systematic Debugging

Use this discipline whenever Arc `run` or Sentry `fix` hits a failure instead
of guessing at a change.

## Iron Law

A fix is not applied until the failure has been reproduced and traced to its
root cause. Changing the line where the failure surfaces is not a fix unless
that line is also the root cause.

## 1. Reproduce

Run the failing case and observe the actual failure: the exact error,
assertion, or output, not a paraphrase. A failure that cannot be reproduced is
not yet understood.

## 2. Trace To Root Cause

Follow the failure backward through the call chain to where the incorrect
value or behavior originates. Do not stop at the first file that contains the
failing assertion - the defect may be in code that file calls.

## 3. Fix At The Root

Fix the code at the point the defect originates. Do not change a test's
expectation to match incorrect output, and do not work around a downstream
symptom while leaving the originating code unchanged. If the same defect
pattern exists elsewhere - a sibling function, an untested duplicate - fix it
there too, even if no test currently exercises it.

## 4. Verify

Re-run the reproduction and the full suite. A fix is verified by an observed
rerun, not by inspection or by an expectation that it "should" work now. For
async or timing-dependent code, wait on the actual completion signal (a
promise, callback, or event), not a fixed delay - a delay that happens to be
long enough today is not a fix and will be flaky under different timing.

## Interaction With Existing Rules

A first flaky failure is investigated under this discipline, never silently
relabeled a product decision (see [dispatch.md](dispatch.md)'s failure
handling). This discipline governs how a failure is fixed; [tdd.md](tdd.md)
governs how new behavior is added. A fix that requires new behavior follows
both: reproduce and trace under this discipline, then add the test and
implementation per [tdd.md](tdd.md).
