#!/bin/sh
# Builds this case's fixture repository in the run's workspace (cwd).
# Delegates to the shared fixture library so every case's ledger stays in
# sync with the reference generator style; see ../_fixtures/lib.py.
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec python3 "$here/../_fixtures/build.py" "product-steer-mid-build"
