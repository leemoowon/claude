#!/usr/bin/env bash
# Stop hook: 매 턴 종료 시 변경사항을 자동으로 commit + push.
# 변경 없으면 조용히 종료. 실패해도 세션 진행에 영향을 주지 않음.

cd "$CLAUDE_PROJECT_DIR" || exit 0

# 변경사항이 없으면 종료
if [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

git add -A

# add 후에도 staged 변경이 없으면 종료(예: .gitignore 처리된 파일만 변경)
if git diff --cached --quiet; then
  exit 0
fi

git commit -m "auto: claude session changes" --quiet || exit 0
git push -u origin HEAD --quiet 2>/dev/null || true
