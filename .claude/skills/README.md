# Skills

이 디렉토리에 프로젝트 전용 스킬을 추가합니다. 각 스킬은 별도 하위 디렉토리에 `SKILL.md` 파일을 두는 형태입니다.

## 구조

```
.claude/skills/
└── <skill-name>/
    └── SKILL.md
```

## SKILL.md 템플릿

```markdown
---
name: skill-name
description: 이 스킬이 언제 트리거되어야 하는지 명확히 기술. 예) "PR 본문 자동 생성을 요청할 때 사용".
allowed-tools: Read, Bash, Grep
---

# Skill Name

스킬이 수행할 작업을 단계별로 기술하세요.

## When to use

- 트리거 조건 1
- 트리거 조건 2

## Steps

1. ...
2. ...
```

## 호출 방법

사용자가 `/<skill-name>` 으로 직접 호출하거나, Claude 가 description 을 보고 자동 트리거합니다.

## 참고

- 스킬은 에이전트와 달리 **현재 컨텍스트에서 실행**됩니다 (별도 컨텍스트 X)
- 컨텍스트를 분리해야 한다면 `.claude/agents/` 에 서브에이전트로 작성하세요
