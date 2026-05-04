---
name: daily-report
description: Jira / Confluence / MS Teams / Outlook 정보를 모아 일일 업무 보고를 만들고 KakaoTalk(나에게 보내기)으로 송신할 때 사용. 사용자가 "오늘 일일보고", "데일리 리포트", "일일 업무 정리해서 카톡으로 보내줘" 등을 요청하면 트리거.
argument-hint: [날짜 또는 "today"|"yesterday"] [--dry-run] [--no-send]
---

# Daily Report

여러 협업 도구의 오늘자 활동을 한 줄 요약으로 정리해 본인 KakaoTalk(MemoChat, 나에게 보내기)으로 전송한다.

## When to use

- 사용자가 일일보고 / 데일리 리포트 / 업무 일지를 카톡으로 받고 싶다고 할 때
- "오늘 한 일 정리해서 보내줘", "/daily-report" 등으로 직접 호출

## Inputs (선택)

- `$1`: 기준 날짜. `today`(기본), `yesterday`, 혹은 `YYYY-MM-DD`
- `--dry-run` / `--preview`: KakaoTalk으로 보내지 않고 메시지 본문만 출력
- `--no-send`: dry-run과 동일

날짜는 한국 시간(KST) 기준이어야 한다. 도구가 UTC를 요구하면 변환해서 전달.

## Tools 사용 매핑

| 단계 | MCP 도구 (suffix 기준) |
|---|---|
| Jira 검색 | `searchJiraIssuesUsingJql`, 필요 시 `getJiraIssue` |
| Confluence 검색 | `searchConfluenceUsingCql`, 필요 시 `getConfluencePage` |
| Atlassian 사용자/리소스 | `atlassianUserInfo`, `getAccessibleAtlassianResources` |
| Outlook 메일 | `outlook_email_search` |
| Outlook 캘린더 | `outlook_calendar_search` |
| Teams 채팅 | `chat_message_search` |
| KakaoTalk 송신 | `KakaotalkChat-MemoChat` |

서버 prefix(예: `mcp__<uuid>__`)는 세션마다 다를 수 있으므로 **suffix 매칭**으로 도구를 찾아 호출한다. ToolSearch가 필요한 경우 `select:<suffix>` 또는 키워드 검색을 사용한다.

## Steps

### 1. 인자 파싱 & 날짜 범위 결정

- 기준 날짜 = 인자 없으면 오늘. KST 기준 `from = YYYY-MM-DDT00:00:00+09:00`, `to = YYYY-MM-DDT23:59:59+09:00`.
- `dry_run = true` 이면 마지막 송신 단계만 건너뛴다.
- 사용자에게 한 줄로 "오늘(2026-05-04) 기준 데이터를 수집합니다." 정도만 안내.

### 2. 사용자 식별 (한 번만)

- `atlassianUserInfo`로 Atlassian accountId 획득 → JQL의 `currentUser()` 사용 가능 여부 확인.
- `getAccessibleAtlassianResources`로 cloudId 확보.
- 실패해도 치명적이지 않다. 누락된 소스는 "수집 실패: 사유"로 보고 본문에 명시하고 계속 진행.

### 3. 데이터 수집 (병렬)

가능하면 한 메시지에서 여러 tool call을 동시에 보낸다. 각 호출 결과는 다음 형태의 정규화된 항목 리스트로 변환:

```
{ source, title, url|null, status|null, time|null, snippet }
```

#### 3-1. Jira

JQL 두 번:
- 내가 오늘 활동한 이슈: `assignee = currentUser() AND updated >= "{YYYY-MM-DD} 00:00"` (또는 `>= startOfDay()`)
- 내가 오늘 코멘트/상태 변경한 이슈: `(assignee = currentUser() OR worklogAuthor = currentUser()) AND updated >= startOfDay()`

field는 `summary,status,updated,issuetype,priority`만 요청. 결과 상위 20건만 사용.

#### 3-2. Confluence

CQL: `lastModified >= "YYYY-MM-DD" AND contributor = currentUser()` 또는 사용자 이메일/계정 기반.
- 내가 편집한 페이지 / 내가 코멘트 단 페이지 상위 10건.

#### 3-3. Outlook 메일

`outlook_email_search`:
- 받은 메일: 오늘 수신, 미읽음 우선, 상위 15건
- 보낸 메일: 오늘 발신, 상위 10건 (요약은 제목만)

#### 3-4. Outlook 캘린더

`outlook_calendar_search`로 오늘 일정 → 과거(완료된 미팅)와 미래(남은 미팅) 분리.

#### 3-5. Teams 채팅

`chat_message_search`:
- 내가 오늘 보낸 메시지가 있는 채팅(주요 스레드 추출)
- 나를 멘션하거나 DM 으로 받은 메시지

상위 10건. 메시지 본문은 80자 내로 잘라서 보관.

### 4. 요약 작성

- LLM(=현재 컨텍스트의 Claude)이 각 섹션을 **bullet 3~7개**로 요약. 새 정보를 만들지 말고 수집된 항목만 사용.
- 헤더는 한국어 이모지 없이 텍스트로. KakaoTalk은 마크다운을 렌더링하지 않으므로 plain text.
- 길이 가이드: 전체 1500자 이내. 초과하면 각 섹션을 5건 이하로 컷.

#### 출력 포맷 (KakaoTalk 본문)

```
[일일보고] 2026-05-04 (월)

■ Jira (총 N건)
- [PROJ-123] 요약 — 상태 (https://...)
- ...

■ Confluence (총 N건)
- 페이지 제목 — 활동 (https://...)
- ...

■ 메일 (받은 N건 / 보낸 M건)
- 보낸이 / 제목 (미읽음)
- ...

■ 캘린더
- 09:30-10:00 스탠드업 (완료)
- 14:00-15:00 1:1 with X (예정)

■ Teams
- #채널 / 상대 — 메시지 발췌
- ...

■ 메모
- 수집 실패한 소스가 있으면 여기 기재
```

### 5. 미리보기 & 확인

- 본문을 사용자에게 코드블록 없이 그대로 보여주고 "이대로 카톡으로 보낼까요?" 라고 묻는다.
- `--dry-run`이면 여기서 종료.
- 사용자가 명시적으로 자동 송신을 원했거나 (`/daily-report send`, "바로 보내줘"), 명령 인자에 `--auto-send`가 있으면 확인 없이 6단계로.

### 6. KakaoTalk 송신

- `KakaotalkChat-MemoChat` 도구를 호출해 본문을 "나에게 보내기"로 전송.
- 메시지 길이가 너무 길면(>1900자) 섹션 단위로 분할 전송하되, 첫 메시지에 `(1/N)` 헤더 추가.
- 송신 결과(성공/실패)를 사용자에게 한 줄로 보고.

### 7. 종료

- 송신했다면 메시지 ID/타임스탬프(반환된 값)와 길이를 한 줄로 보고.
- 실패했다면 본문은 화면에 남겨 두고, 사용자가 수동 송신할 수 있게 한다.

## 원칙

- **수집 실패 ≠ 전체 실패**: 일부 MCP 도구가 인증 만료 등으로 실패해도 다른 소스는 그대로 진행. 실패 사유는 "■ 메모" 섹션에 한 줄.
- **개인정보 최소화**: 본문은 자기 자신에게 보내는 메모지만, 메일/Teams 본문 전체를 그대로 옮기지 말고 제목·발신자·1줄 발췌만 포함.
- **시간대**: 모든 표시 시각은 KST. ISO8601로 받았으면 KST로 변환.
- **링크**: Jira/Confluence는 가능한 한 원본 URL을 본문에 포함(클릭 추적 가능).
- **재현성**: 동일 인자로 다시 호출하면 같은 데이터 셋이 나오도록, JQL/CQL 쿼리와 시간 범위를 명시적으로 설정한다.

## 트러블슈팅

- `KakaotalkChat-MemoChat` 도구를 못 찾으면 ToolSearch로 `select:KakaotalkChat-MemoChat`을 시도. 그래도 없으면 playmcp(58ae...) 서버 미연결 → 사용자에게 알림.
- Atlassian 도구가 cloudId를 요구하는데 비어 있으면 `getAccessibleAtlassianResources` 결과의 첫 cloudId 사용.
- JQL `currentUser()`가 동작하지 않는 변형이면 `assignee = "<accountId>"` 로 폴백.
