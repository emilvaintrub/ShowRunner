# Test-Driven Development

Use this discipline whenever Arc `run` or Sentry `fix` produces code.

## Iron Law

Production code written before its failing test was observed must be deleted
and re-implemented from the test. No "reference," no "adaptation" exceptions.

## RED - Write A Failing Test

Before writing any implementation:

1. Write one minimal test for the next behavior.
2. Run it.
3. Confirm it fails, and that the failure is for the right reason (the
   behavior is missing, not a typo or setup error).

A test that passes on first write proves nothing. Reject it; fix the test,
not the assertion.

## GREEN - Make It Pass

Write the minimal code needed to pass the failing test. Run the full suite.
All tests pass. Add no behavior beyond what the test requires.

## REFACTOR - Clean Up

With the suite green, simplify the implementation and the test. Re-run after
each change; stay green.

## Interaction With Existing Rules

This discipline governs the *order* work happens in (test first). Fixture,
migration, and timing rules in [method.md](method.md) govern *correctness* of
the tests themselves and still apply. They compose; neither replaces the
other.

For common rationalizations that produce untested production code, see
[testing-anti-patterns.md](testing-anti-patterns.md).
