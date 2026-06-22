# Testing Anti-Patterns

Use this with [tdd.md](tdd.md). Each pattern below is a rationalization that
produces untested production code, with the rebuttal that holds it off.

## "The existing suite still passes"

**Rationalization**: implement the new behavior, run the existing test suite,
see it pass (because it never covered the new behavior), and report the task
complete.

**Why it fails**: a passing suite that does not exercise the new behavior
proves nothing about it. This is silent untested code, not a passed check.

**Rebuttal**: [tdd.md](tdd.md)'s RED step is not optional preamble - no
implementation exists until a test for the new behavior has been written and
observed failing.

## "It's trivial / there's no time"

**Rationalization**: the change is small enough (a "one-liner") and there is
schedule pressure, so writing a test is overkill - implement directly, confirm
the existing suite still passes, ship.

**Why it fails**: size and time pressure do not change whether the behavior is
covered. Small functions are exactly where a missing edge case (empty input,
case sensitivity, punctuation) goes unnoticed without a test.

**Rebuttal**: the Iron Law in [tdd.md](tdd.md) has no size or urgency
exception. Write the one minimal test first; it costs little and the RED step
takes seconds.

## "It's already deployed and working - just add coverage"

**Rationalization**: production code for the new behavior already exists (from
an earlier change) and is reported to work correctly. The task is reframed as
retroactively adding tests to lock in the existing behavior, not as building
the behavior.

**Why it fails**: "working" here means "observed to run," not "verified
against a test written from the requirement." Tests written against existing
code tend to encode whatever the code happens to do, including its bugs, and
a test that passes the moment it is written proves nothing ([tdd.md](tdd.md)).

**Rebuttal**: per the Iron Law, production code written before its failing
test was observed must be deleted and re-implemented from the test - including
code that is already deployed. Delete it, write the test against the
requirement, watch it fail for the right reason, then re-implement.
