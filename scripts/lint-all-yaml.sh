#!/usr/bin/env bash
# Lint Ansible YAML across the repository using ansible-lint (production profile).

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANSIBLE_LINT_CONFIG="${REPO_ROOT}/.ansible-lint"

cd "$REPO_ROOT"

if ! command -v ansible-lint >/dev/null 2>&1; then
  echo "error: required command not found: ansible-lint" >&2
  exit 127
fi

# Run ansible-lint without path arguments so it walks the repository tree.
# Passing directory paths only lints a handful of top-level files instead of
# recursing into playbooks/, roles/, inventories/, and examples/.
echo "==> ansible-lint: repository scan"
if ! ansible-lint -c "$ANSIBLE_LINT_CONFIG"; then
  echo "lint-yaml: ansible-lint reported failures" >&2
  exit 1
fi

echo "lint-yaml: all targets passed"
