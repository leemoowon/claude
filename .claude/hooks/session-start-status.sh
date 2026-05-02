#!/usr/bin/env bash
# SessionStart hook: 세션 시작 시 저장소 컨텍스트를 출력해 Claude 가 즉시 상황 파악 가능하도록 한다.
# settings.json 의 hooks.SessionStart 에 등록되어 있다.

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
status="$(git status -sb 2>/dev/null | head -20)"

cat <<EOF
[session-start] branch: ${branch}
${status}
EOF
