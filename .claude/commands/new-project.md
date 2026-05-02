---
description: projects/ 또는 experiments/ 하위에 새 작업 폴더를 일관된 구조로 생성
argument-hint: <projects|experiments> <폴더명>
allowed-tools: Bash(mkdir:*), Bash(ls:*), Write
---

새 작업 폴더를 생성하세요. 인자: `$ARGUMENTS`

## 절차

1. 인자 파싱:
   - 첫 번째 토큰: `projects` 또는 `experiments` 중 하나여야 함
   - 두 번째 토큰: 폴더명 (소문자, 하이픈 사용)
   - 형식이 틀리면 사용법 안내 후 중단

2. `mkdir -p <카테고리>/<폴더명>` 으로 폴더 생성

3. 해당 폴더에 다음 파일을 작성:
   - `README.md`: 1줄 목적 설명 + 빠른 시작
   - `CLAUDE.md`: 이 프로젝트 전용 컨텍스트가 있을 경우만 (선택)
   - `.gitkeep` 은 README.md 가 있으므로 불필요

4. 생성된 구조를 `ls -la <카테고리>/<폴더명>` 으로 확인하고 사용자에게 보고
