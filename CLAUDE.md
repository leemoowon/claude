# Workspace Guide for Claude

이 저장소는 여러 프로젝트, 실험, 문서를 한 곳에서 관리하는 **다목적 작업공간**입니다. 아래 규칙을 따르세요.

## 디렉토리 규칙

| 폴더 | 용도 |
|------|------|
| `projects/<name>/` | 지속적으로 발전시킬 코드 (1프로젝트 = 1폴더). 자체 README/CLAUDE.md 가능 |
| `experiments/<name>/` | 일회성 실험, 스파이크, 학습용 코드. 정리 부담 없음 |
| `docs/` | 코드와 무관한 문서, 메모, 회의록 |
| `scripts/` | 작업공간 전체에서 쓰는 유틸 스크립트 |
| `.claude/` | Claude Code 하네스 (settings, agents, commands, hooks, skills) |

새 프로젝트/실험을 시작할 때는 `/new-project projects <name>` 또는 `/new-project experiments <name>` 슬래시 커맨드를 사용하세요.

## 절대 커밋 금지

- `.env`, `.env.*` (예외: `.env.example`)
- `*.pem`, `*.key`, `id_rsa*`
- `.claude/settings.local.json` (자동 gitignore)
- API 토큰, 비밀번호, 자격증명이 포함된 모든 파일

## 커밋 컨벤션

간단한 [Conventional Commits](https://www.conventionalcommits.org/) 사용:

```
<type>: <subject>

<optional body>
```

Type: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `wip`

## Claude Code 사용 시 유의사항

- **읽기는 자유롭게**, 쓰기/실행은 신중하게. 위험한 작업(`git push`, `rm`, 패키지 설치 등)은 settings.json 에서 `ask` 로 설정되어 있어 사용자 확인을 받음
- 프로젝트별 컨텍스트가 필요하면 해당 프로젝트 폴더에 `CLAUDE.md` 추가 (계층적 상속됨)
- 새 에이전트/커맨드/훅이 필요하면 `.claude/` 하위에 추가하고 `docs/claude-code-guide.md` 참고
- MCP 서버는 `.mcp.json` (팀 공유) + 사용자 레벨 설정으로 관리

## 작업 흐름 권장

1. 새 작업 시작 → `/new-project` 로 폴더 생성 또는 기존 폴더로 이동
2. 큰 변경 전 → 플랜 모드 (`shift+tab` 두 번) 로 설계 확인
3. 변경 완료 → `/agents` 의 `code-reviewer` 또는 `/review` 스킬로 셀프 리뷰
4. 커밋 전 → `/security-review` 로 비밀/보안 점검
5. 커밋/푸시 → `claude/explore-features-vCIOT` 같은 작업 브랜치 사용
