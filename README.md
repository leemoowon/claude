# claude workspace

Claude Code 와 함께 사용하는 다목적 작업공간. 여러 프로젝트, 실험, 문서를 한 저장소에서 일관되게 관리합니다.

## 구조

```
.
├── .claude/              # Claude Code 하네스
│   ├── settings.json     # 팀 공유 설정 (커밋됨)
│   ├── agents/           # 서브에이전트
│   ├── commands/         # 슬래시 커맨드
│   ├── hooks/            # 훅 스크립트
│   ├── skills/           # 커스텀 스킬
│   └── output-styles/    # 출력 스타일
├── .mcp.json             # 팀 공유 MCP 서버 템플릿
├── CLAUDE.md             # 작업공간 컨텍스트 (Claude 가 자동 로드)
├── projects/             # 지속 발전할 프로젝트 (1프로젝트 = 1폴더)
├── experiments/          # 일회성 실험, 스파이크
├── docs/                 # 문서 / 메모
└── scripts/              # 작업공간 차원 유틸
```

## 빠른 시작

1. **개인 설정 만들기** (선택):
   ```bash
   cp .claude/settings.local.json.example .claude/settings.local.json
   ```

2. **MCP 자격증명** (사용 시):
   ```bash
   export GITHUB_PAT=<your_token>
   ```

3. **새 프로젝트 시작**: Claude Code 안에서
   ```
   /new-project projects my-app
   ```

4. **실험 시작**:
   ```
   /new-project experiments quick-spike
   ```

## 더 알아보기

- `CLAUDE.md` - 작업공간 규칙과 컨벤션
- `docs/claude-code-guide.md` - 하네스 사용/확장 가이드
- `docs/android-claude-code-guide.md` - 안드로이드 모바일에서 Claude Code 사용 입문자 가이드
- `docs/anthropic-harness-engineering.md` - Anthropic 하네스 엔지니어링 핵심 요약
