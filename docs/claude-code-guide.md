# Claude Code 하네스 사용 가이드

이 문서는 `.claude/` 디렉토리의 각 요소를 어떻게 추가/수정/디버깅하는지 설명합니다.

## 1. 설정 (settings)

| 파일 | 용도 | git |
|------|------|-----|
| `.claude/settings.json` | 팀 공유 설정 | 커밋 O |
| `.claude/settings.local.json` | 개인 설정 (덮어쓰기) | 커밋 X |
| `~/.claude/settings.json` | 사용자 전역 | 별도 |

병합 우선순위: enterprise > 사용자 > 프로젝트(.claude/settings.json) > 로컬(.claude/settings.local.json) > 더 깊은 경로.

### 권한 규칙

```json
"permissions": {
  "allow": ["Bash(git status:*)"],   // 자동 허용
  "ask":   ["Bash(git push:*)"],     // 사용자 확인
  "deny":  ["Read(./.env)"]           // 항상 차단
}
```

도구별 매처는 `Tool(pattern)` 형태. Bash 는 명령어 prefix 매칭.

## 2. 서브에이전트 (`agents/`)

별도 컨텍스트에서 실행되는 전문화된 Claude 인스턴스. 큰 탐색이나 격리된 작업에 유용.

```markdown
---
name: my-agent
description: 언제 사용해야 하는지 명확히
tools: Read, Bash, Grep   # 생략 시 모든 도구
---

시스템 프롬프트 본문...
```

- 호출: 메인 Claude 가 description 보고 자동 위임, 또는 명시적으로 "use the my-agent agent" 요청
- 디버깅: `/agents` 로 목록 확인

## 3. 슬래시 커맨드 (`commands/`)

재사용 가능한 프롬프트 템플릿. 사용자가 `/command-name` 으로 호출.

```markdown
---
description: 한 줄 설명
argument-hint: <expected args>
allowed-tools: Bash(ls:*), Write
---

프롬프트 본문. $ARGUMENTS 로 인자 접근.
```

- 파일명이 곧 명령 이름 (`new-project.md` → `/new-project`)
- 디버깅: `/` 입력 시 자동완성에 노출되는지 확인

## 4. 훅 (`hooks/` + settings.json)

특정 이벤트에 자동 실행되는 셸 명령. Claude 가 아니라 **하네스가 실행**합니다.

이벤트: `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`, `Notification` 등.

settings.json 등록:
```json
"hooks": {
  "SessionStart": [
    {
      "matcher": "*",
      "hooks": [{ "type": "command", "command": ".claude/hooks/my-hook.sh" }]
    }
  ]
}
```

스크립트 요건:
- 실행 권한 필요 (`chmod +x`)
- stdout 은 Claude 컨텍스트로 주입됨 (SessionStart, UserPromptSubmit)
- 종료 코드 ≠ 0 → 에러로 표시 (PreToolUse 의 경우 도구 실행 차단)

디버깅: `claude --debug hooks` 또는 훅 안에서 `>> /tmp/hook.log` 로 로깅.

## 5. 스킬 (`skills/`)

현재 컨텍스트에서 실행되는 절차형 가이드. 에이전트와 달리 컨텍스트 분리 X.

`.claude/skills/<name>/SKILL.md` 형태로 작성. 자세한 내용은 `.claude/skills/README.md` 참고.

## 6. MCP 서버

| 위치 | 범위 | git |
|------|------|-----|
| `.mcp.json` | 프로젝트 (팀 공유) | 커밋 O |
| `~/.claude.json` 의 mcpServers | 사용자 전역 | X |

`enableAllProjectMcpServers: true` 면 `.mcp.json` 의 모든 서버 자동 활성. 자격증명은 `${ENV_VAR}` 로 환경변수 참조.

추가 예시:
```json
{
  "mcpServers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/some/path"]
    }
  }
}
```

## 7. 문제 해결

| 증상 | 확인 |
|------|------|
| 슬래시 커맨드가 안 보임 | 파일이 `.claude/commands/` 에 있는지, frontmatter 파싱되는지 |
| 에이전트 자동 호출 안 됨 | description 이 트리거 조건을 명확히 기술하는지 |
| 훅이 실행 안 됨 | `chmod +x` 했는지, settings.json 의 경로가 정확한지, `claude --debug` 로 확인 |
| 권한이 자꾸 물어봄 | settings.local.json 에 자주 쓰는 패턴 추가 (또는 `/permissions`) |
| MCP 서버 연결 실패 | 환경변수 설정 확인, `claude mcp list` 로 상태 점검 |

## 8. 참고

- 공식 문서: https://docs.claude.com/en/docs/claude-code
- 설정 스키마: `https://json.schemastore.org/claude-code-settings.json`
