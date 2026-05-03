# 안드로이드 모바일에서 Claude Code 사용하기 — 입문자 완전 가이드

> 이 문서는 **안드로이드 스마트폰/태블릿** 사용자가 Anthropic의 **Claude Code**를 처음부터 끝까지 활용할 수 있도록 안내합니다. 모든 절차는 **Anthropic 공식 문서**(https://code.claude.com, https://support.claude.com)에 근거하며, 비공식 우회 방법(Termux, SSH 등)은 다루지 않습니다.

---

## 목차

0. [들어가며 — 꼭 알아야 할 핵심 사실](#0-들어가며--꼭-알아야-할-핵심-사실)
1. [사전 준비 (모든 방법 공통)](#1-사전-준비-모든-방법-공통)
2. [방법 A — Claude Code on the web (가장 권장)](#2-방법-a--claude-code-on-the-web-가장-권장)
3. [방법 B — Claude 안드로이드 앱으로 세션 모니터링](#3-방법-b--claude-안드로이드-앱으로-세션-모니터링)
4. [방법 C — GitHub Actions의 `@claude` 멘션](#4-방법-c--github-actions의-claude-멘션)
5. [세 가지 방법 비교](#5-세-가지-방법-비교)
6. [자주 묻는 질문 (FAQ)](#6-자주-묻는-질문-faq)
7. [공식 참고 문서](#7-공식-참고-문서)

---

## 0. 들어가며 — 꼭 알아야 할 핵심 사실

**Claude Code는 안드로이드에서 "네이티브 앱"으로 직접 실행되지 않습니다.**

Anthropic이 공식적으로 지원하는 Claude Code 실행 환경은 다음과 같습니다 (출처: [Claude Code Setup 문서](https://code.claude.com/docs/en/setup)):

| 구분 | 공식 지원 OS/플랫폼 |
|---|---|
| 터미널/CLI | macOS 13+, Windows 10+, Ubuntu 20.04+, Debian 10+, Alpine 3.19+ |
| 데스크톱 앱 | macOS, Windows |
| IDE 확장 | VS Code, JetBrains 계열 |
| 웹 | https://claude.ai/code |

안드로이드는 이 목록에 **없습니다.** 그러나 Anthropic은 모바일 사용자를 위해 **세 가지 공식 경로**를 제공합니다:

1. **Claude Code on the web** — 안드로이드 브라우저(크롬, 삼성 인터넷 등)로 `claude.ai/code`에 접속해 클라우드에서 작업 실행
2. **Claude 안드로이드 앱** — Google Play의 공식 Claude 앱으로 데스크톱에서 실행 중인 Claude Code 세션을 모니터링 (`/mobile` QR 코드 사용)
3. **GitHub Actions `@claude` 멘션** — 안드로이드 GitHub 모바일 앱에서 이슈/PR에 `@claude` 멘션으로 작업 트리거

> Anthropic 공식 문서 인용:
> *"Run Claude Code in the cloud from your browser or phone. Connect a GitHub repository, submit a task, and review the PR without local setup."*
> — [Claude Code on the web Quickstart](https://code.claude.com/docs/en/web-quickstart)

이 가이드는 위 세 가지 방법을 **단계별로** 설명합니다. **방법 A가 가장 권장됩니다** (별도 PC 없이 폰만으로 작업 가능).

---

## 1. 사전 준비 (모든 방법 공통)

### 1-1. Claude 계정 만들기

1. 안드로이드 크롬에서 https://claude.ai 접속
2. **Sign up** 또는 **Continue with Google** 탭
3. 이메일 인증 완료

> Claude는 한국에서도 정식 서비스됩니다 (지원 국가 목록: https://www.anthropic.com/supported-countries).

### 1-2. 요금제 안내

Claude Code 사용은 **유료 요금제**가 필요합니다.

| 요금제 | Claude Code 사용 | 권장 대상 |
|---|---|---|
| Free | ❌ | Claude 채팅 체험용 |
| **Pro** | ✅ (제한적 사용량) | 입문자/개인 개발자 |
| **Max** | ✅ (대규모 사용량) | 본격 사용자 |
| Team / Enterprise | ✅ | 팀/회사 |

요금제 가입은 https://claude.ai 의 **Settings → Billing** 메뉴에서 진행합니다. (안드로이드 앱에서도 동일한 메뉴 제공)

### 1-3. GitHub 계정 (방법 A, C에서 필요)

방법 A(웹) 와 방법 C(GitHub Actions)는 **GitHub 저장소**(repository, 코드 보관소)와 연결되어야 작동합니다.

1. 안드로이드 크롬에서 https://github.com 접속
2. **Sign up** 으로 무료 계정 생성
3. (선택) Google Play에서 **GitHub 모바일 앱** 설치 — 방법 C에서 사용

> Claude Code on the web은 "GitHub 저장소를 연결한 뒤 작업을 제출"하는 구조입니다. 즉, 작업하려는 코드가 GitHub에 올라가 있어야 합니다.

---

## 2. 방법 A — Claude Code on the web (가장 권장)

### 2-1. 작동 원리

Claude Code on the web은 **Anthropic이 관리하는 클라우드 서버**에서 Claude Code를 실행합니다. 사용자의 폰에는 아무것도 설치되지 않으며, 모든 작업이 Anthropic의 가상 머신(VM)에서 진행됩니다.

> Anthropic 공식 문서 인용:
> *"Claude Code on the web runs on Anthropic-managed cloud infrastructure instead of your machine. Submit tasks from claude.ai/code in your browser or the Claude mobile app."*
> — [Claude Code on the web Quickstart](https://code.claude.com/docs/en/web-quickstart)

흐름은 다음과 같습니다:

```
[안드로이드 브라우저] → claude.ai/code 접속
        ↓
[GitHub 저장소 연결] → 작업 지시문 입력 ("로그인 버튼 색을 빨강으로 바꿔줘")
        ↓
[Anthropic 클라우드 VM] → Claude Code가 코드 수정 + 테스트 실행
        ↓
[GitHub PR 자동 생성] → 안드로이드에서 PR 검토 후 머지
```

### 2-2. 안드로이드 브라우저로 접속

1. 크롬(또는 삼성 인터넷, 엣지 등)을 엽니다
2. 주소창에 **`claude.ai/code`** 입력
3. 1단계에서 만든 Claude 계정으로 로그인
4. 화면에 Claude Code 대시보드가 표시됩니다

> 모바일 화면에 맞게 자동으로 레이아웃이 조정되지만, 코드 diff(변경 사항 비교) 같은 화면은 가로 모드가 더 편합니다.

### 2-3. GitHub 저장소 연결

1. 대시보드에서 **Connect GitHub** 또는 **Add repository** 버튼을 탭
2. GitHub 로그인 화면에서 Anthropic 앱 권한 승인
3. Claude Code가 접근할 저장소를 선택 (전체 또는 특정 저장소만 가능)
4. 연결 완료 후 대시보드로 돌아오면 저장소 목록이 보입니다

> GitHub 권한은 언제든 https://github.com/settings/installations 에서 회수할 수 있습니다.

### 2-4. 첫 번째 작업 제출하기

1. 연결된 저장소 중 작업할 저장소를 탭
2. **New task** 또는 **+** 버튼 탭
3. **자연어로 작업 지시문 입력** — 예시:
   - `README.md 파일에 한국어 번역을 추가해줘`
   - `로그인 페이지의 폰트 크기를 16px로 키워줘`
   - `사용자 입력값을 검증하는 테스트를 작성해줘`
4. **베이스 브랜치**(기본 작업 시작점)를 선택 (보통 `main`)
5. **Submit** 탭 → 작업이 클라우드에서 실행됩니다

### 2-5. 진행 상황 모니터링 및 PR 검토

1. 작업 카드를 탭하면 Claude Code의 실시간 진행 상황이 보입니다
   - 어떤 파일을 읽고 있는지
   - 어떤 명령어를 실행했는지
   - 어떤 변경을 가했는지
2. 작업이 끝나면 자동으로 **GitHub Pull Request**(PR, 코드 변경 요청)가 생성됩니다
3. PR 링크를 탭하면 GitHub 모바일 화면에서 변경 사항(diff)을 확인할 수 있습니다
4. 문제가 없으면 **Merge pull request** 버튼으로 본 코드에 반영

### 2-6. 한계

- 코드를 **로컬 폰에서 직접 실행하는 기능은 없습니다.** 항상 GitHub 저장소를 거쳐야 합니다.
- 화면이 작아서 큰 diff 검토는 불편할 수 있습니다 — 가로 모드 또는 태블릿 권장.
- 인터넷 연결이 필요합니다 (오프라인 작업 불가).

---

## 3. 방법 B — Claude 안드로이드 앱으로 세션 모니터링

이 방법은 **이미 PC/노트북이 있고**, 그 PC에서 Claude Code를 실행 중인 사람에게 유용합니다. 안드로이드 앱은 PC에서 돌아가는 작업을 외출 중에 **확인하고 답하는 용도**입니다.

### 3-1. Google Play에서 공식 Claude 앱 설치

1. Google Play Store 열기
2. 검색창에 **`Claude`** 입력
3. 개발자가 **Anthropic, PBC** 인 공식 앱 설치
4. 직접 링크: https://play.google.com/store/apps/details?id=com.anthropic.claude

> 공식 설치 가이드: https://support.claude.com/en/articles/9612887-how-do-i-install-claude-for-android

### 3-2. 데스크톱에서 Claude Code 실행

데스크톱(macOS/Windows/Linux)에서 Claude Code가 이미 설치되어 있다고 가정합니다. 터미널에서:

```bash
claude
```

세션이 시작되면 다음 명령어를 입력합니다:

```
/mobile
```

화면에 **QR 코드**가 표시됩니다.

> Anthropic 공식 문서 인용:
> *"From the Claude Code CLI, `/mobile` shows a QR code."*
> — [Claude Code on the web Quickstart](https://code.claude.com/docs/en/web-quickstart)

### 3-3. 안드로이드 Claude 앱으로 QR 스캔

1. 안드로이드에서 Claude 앱 실행
2. 메뉴(보통 좌측 상단 햄버거 아이콘 또는 우측 상단 프로필)에서 **Scan code** 또는 카메라 아이콘 탭
3. PC 화면의 QR 코드를 스캔
4. 모바일에서 해당 세션의 메시지/진행 상황을 확인하고 응답 가능

### 3-4. 한계

- **Claude 안드로이드 앱 자체로는 Claude Code가 실행되지 않습니다.** PC에서 돌아가는 세션을 보는 용도입니다.
- PC가 켜져 있고 Claude Code 세션이 살아있어야 합니다.
- Claude 앱의 일반 채팅 기능은 안드로이드에서도 정상 동작하지만, 그것은 Claude Code가 아닌 **일반 Claude 대화**입니다.

---

## 4. 방법 C — GitHub Actions의 `@claude` 멘션

GitHub 저장소에 **Claude Code GitHub Action**을 설치하면, 이슈나 PR 코멘트에 `@claude` 라고 멘션하는 것만으로 Claude Code가 자동으로 작업을 수행합니다. 이때 코드는 **GitHub의 서버**에서 실행됩니다 — 폰에는 아무것도 설치하지 않습니다.

> Anthropic 공식 문서 인용:
> *"With a simple `@claude` mention in any PR or issue, Claude can analyze your code, create pull requests, implement features, and fix bugs."*
> — [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions)

### 4-1. 저장소에 GitHub Action 설치 (한 번만)

이 단계는 **PC에서 한 번만** 진행하면 됩니다 (안드로이드 GitHub 앱에서도 가능하지만 PC가 편합니다).

1. PC에서 https://github.com/apps/claude 접속 또는 데스크톱 Claude Code에서 `/install-github-app` 명령 실행
2. 설치할 저장소 선택
3. **Anthropic API 키** 또는 **OAuth 토큰**을 저장소 Secrets에 등록 (GitHub → Settings → Secrets and variables → Actions)
4. `.github/workflows/claude.yml` 워크플로 파일이 자동 생성됩니다

상세 절차는 https://code.claude.com/docs/en/github-actions 를 참고하세요.

### 4-2. 안드로이드 GitHub 앱에서 작업 트리거

1. Google Play에서 **GitHub** 모바일 앱 설치 (개발자: GitHub, Inc.)
2. 앱에서 작업할 저장소로 이동
3. **Issues** 탭에서 새 이슈 작성, 또는 기존 이슈/PR 열기
4. 코멘트에 다음과 같이 작성:
   ```
   @claude README의 한국어 번역 섹션을 추가해줘
   ```
5. **Comment** 버튼 탭 → GitHub Actions가 자동 실행되며 Claude가 작업 시작

### 4-3. 결과 확인

- 몇 분 후 Claude가 코멘트로 진행 상황을 알리거나, 변경 사항이 담긴 새 PR을 생성합니다
- 안드로이드 GitHub 앱에서 Pull requests 탭으로 이동해 변경 사항(diff)을 검토
- 문제가 없으면 **Merge** 버튼 탭

### 4-4. 한계

- 초기 GitHub Action 설치는 PC가 있는 것이 편합니다
- API 키 발급/관리(과금 포함)가 필요합니다 (Anthropic Console: https://console.anthropic.com)
- 무료 티어 GitHub Actions 사용 시간 제한이 있습니다 (개인 저장소 기준)

---

## 5. 세 가지 방법 비교

| 항목 | 방법 A (웹) | 방법 B (앱 모니터링) | 방법 C (GitHub Actions) |
|---|---|---|---|
| 폰만으로 작업 가능 | ✅ | ❌ (PC 필요) | ✅ (초기 설치 후) |
| GitHub 계정 필요 | ✅ | ❌ | ✅ |
| 별도 결제 | Pro/Max 요금제 | Pro/Max 요금제 | Anthropic API 사용량 + GitHub Actions |
| 즉시 시작 가능 | ✅ | PC 세션이 켜져 있어야 함 | 초기 GitHub App 설치 필요 |
| 자연어로 지시 | ✅ | PC 세션에 메시지로 응답 | ✅ (`@claude ...`) |
| **추천 사용자** | **모든 입문자** | PC가 늘 켜져 있는 사용자 | 팀 협업/PR 자동화 |

---

## 6. 자주 묻는 질문 (FAQ)

### Q1. Termux나 Linux Deploy 같은 앱으로 Claude Code CLI를 안드로이드에 직접 설치할 수 없나요?

Anthropic이 **공식적으로 지원하지 않으며**, 본 가이드에서도 다루지 않습니다. 공식 지원 OS는 macOS, Windows, Linux 데스크톱 배포판입니다 ([Setup 문서](https://code.claude.com/docs/en/setup)). 공식 경로인 **방법 A (Claude Code on the web)** 를 사용하세요.

### Q2. Google Play의 Claude 안드로이드 앱에서 직접 코드를 작성할 수 있나요?

Claude 안드로이드 앱은 **일반 Claude 대화**(질문/이미지 분석/번역 등)를 위한 앱입니다. 코드 자동 편집, 파일 수정, 명령어 실행 같은 **Claude Code 기능은 앱 자체로 실행되지 않습니다.** 다만 PC에서 실행 중인 Claude Code 세션을 `/mobile` QR로 연결하면 모니터링과 응답이 가능합니다 (방법 B).

### Q3. 무료로 사용할 수 있나요?

- **Claude 일반 채팅**: 무료 플랜으로 사용 가능
- **Claude Code (방법 A, B)**: **Pro 또는 Max 요금제** 필요
- **GitHub Actions (방법 C)**: Anthropic API 키와 GitHub Actions 사용량(개인 저장소는 일정량 무료)이 필요

### Q4. 인터넷 연결이 필수인가요?

세 가지 방법 모두 **인터넷 연결이 필수**입니다. 모든 작업이 Anthropic 또는 GitHub 클라우드에서 실행되기 때문입니다.

### Q5. 한국어 지시문이 작동하나요?

네. Claude는 한국어를 지원하므로 작업 지시문을 한국어로 자유롭게 작성할 수 있습니다 (예: `회원가입 폼에 이메일 형식 검증을 추가해줘`).

### Q6. iPad/iPhone에서도 같은 방법이 가능한가요?

네. **방법 A**(웹)와 **방법 B**(앱)는 iOS에서도 동일하게 작동합니다. iOS Claude 앱: https://apps.apple.com/us/app/claude-by-anthropic/id6473753684

---

## 7. 공식 참고 문서

본 가이드는 다음 Anthropic 공식 문서를 근거로 작성되었습니다:

| 주제 | 공식 URL |
|---|---|
| Claude Code 개요 | https://code.claude.com/docs/en/overview |
| 시스템 요구사항 / 설치 | https://code.claude.com/docs/en/setup |
| Claude Code on the web 빠른 시작 | https://code.claude.com/docs/en/web-quickstart |
| GitHub Actions 통합 | https://code.claude.com/docs/en/github-actions |
| Claude 안드로이드 앱 (Google Play) | https://play.google.com/store/apps/details?id=com.anthropic.claude |
| Claude 안드로이드 앱 설치 도움말 | https://support.claude.com/en/articles/9612887-how-do-i-install-claude-for-android |
| 지원 국가 목록 | https://www.anthropic.com/supported-countries |
| 요금제 안내 | https://www.anthropic.com/pricing |
| Anthropic Console (API 키 발급) | https://console.anthropic.com |

문서 내용이 변경될 수 있으므로, 실제 사용 시 위 공식 페이지를 함께 확인하는 것을 권장합니다.

---

*마지막 업데이트: 2026-05-03 · 안드로이드 모바일 사용자 대상 입문자 가이드*
