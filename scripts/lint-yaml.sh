#!/usr/bin/env bash
# Lint Ansible YAML from files or stdin using ansible-lint (production profile).

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANSIBLE_LINT_CONFIG="${REPO_ROOT}/.ansible-lint"
TARGETS=()
FAILED=0

usage() {
  cat <<'EOF'
Lint Ansible YAML from files or stdin using ansible-lint (production profile).

Usage:
  scripts/lint-yaml.sh [FILE ...]
  scripts/lint-yaml.sh -

When no FILE arguments are given, lint the full repository.
EOF
}

lint_target() {
  local label="$1"
  local path="$2"
  local cleanup_path=""

  if [[ "$path" == "-" ]]; then
    cleanup_path="$(mktemp "${TMPDIR:-/tmp}/lint-yaml.XXXXXX")"
    cat >"$cleanup_path"
    path="$cleanup_path"
    label="stdin"
  fi

  echo "==> ansible-lint: ${label}"
  if ! ansible-lint -c "$ANSIBLE_LINT_CONFIG" "$path"; then
    if [[ -n "$cleanup_path" ]]; then
      rm -f "$cleanup_path"
    fi
    return 1
  fi

  if [[ -n "$cleanup_path" ]]; then
    rm -f "$cleanup_path"
  fi
  return 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        TARGETS+=("$1")
        shift
      done
      break
      ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      TARGETS+=("$1")
      ;;
  esac
  shift
done

if ! command -v ansible-lint >/dev/null 2>&1; then
  echo "error: required command not found: ansible-lint" >&2
  exit 127
fi

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  exec "${REPO_ROOT}/scripts/lint-all-yaml.sh"
fi

for target in "${TARGETS[@]}"; do
  if [[ "$target" == "-" ]]; then
    if ! lint_target "stdin" "-"; then
      FAILED=1
    fi
    continue
  fi

  if [[ ! -e "$target" ]]; then
    echo "error: file not found: $target" >&2
    exit 2
  fi

  if ! lint_target "$target" "$target"; then
    FAILED=1
  fi
done

if [[ "$FAILED" -eq 1 ]]; then
  echo "lint-yaml: one or more targets failed" >&2
  exit 1
fi

echo "lint-yaml: all targets passed"
