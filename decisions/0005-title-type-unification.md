> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-29
> 적용 범위: BOAZ-website 조직의 모든 저장소
> 상태: 확정

# 0005 PR·이슈 제목 Type 통일과 커밋 형식 저장소별 유지

## 상태

| 항목 | 값 |
|---|---|
| 상태 | 채택 |
| 결정일 | 2026-11-28 |
| 결정자(역할) | PM |
| 의견을 준 역할 | Product Engineer |

## 배경

- 저장소마다 PR·이슈 제목 형식이 다름. frontend 계열 3개(frontend, frontend_admin, frontend_recruiting_admin)는 `type: 설명`이거나 형식이 혼재함
- 이슈·PR 검사와 자동 라벨(`conventions/issue-pr.md`)이 제목의 `[Type]`에 의존해, 제목 형식이 다르면 자동화가 동작하지 않음
- 커밋 형식은 저장소마다 훅과 type 목록이 달라 한 번에 맞추기 어려움

## 선택지

| 선택지 | 내용 | 장점 | 단점 | 채택 | 탈락 사유 |
|---|---|---|---|---|---|
| A | 모든 저장소 PR·이슈 제목을 `[Type] 내용`(Type 9종)으로 통일하고, 커밋 형식은 저장소별로 유지 | 자동화가 한 기준으로 동작하고 저장소별 커밋 훅을 건드리지 않음 | 제목과 커밋 type 목록이 달라 보임 | 예 | 해당 없음 |
| B | 제목과 커밋 형식을 모두 통일 | 한 규칙으로 기억함 | 훅 교체와 기존 규약 변경 범위가 큼 | 아니오 | 저장소 전환 부담이 큼 |
| C | 저장소별 제목 형식 유지 | 변경 없음 | 자동화 검사를 저장소마다 따로 만들어야 함 | 아니오 | 단일 검사로 일괄 반영할 수 없음 |

## 결정

- 모든 저장소의 PR·이슈 제목은 `[Type] 내용`. Type 9종은 Feat, Fix, Hotfix, Docs, Refactor, Style, Test, Release, Chore(작업 종류 라벨 9종과 같음)
- 영역 표기는 Type 뒤에 허용함. 예: `[Feat] [서류 평가] 내용`
- 기존 type 13종은 9종으로 정리함: ci와 build는 Chore, perf는 Refactor, revert는 Chore로 씀
- 제목 검사는 재사용 워크플로 `pr-check`의 검사 항목으로 넣음. 필수 검사는 `repo-rule-keeper`
- 커밋 메시지 형식은 저장소별로 유지함. 공통 원칙(한국어, 이슈 번호 권장)만 `conventions/git.md`에 두고 저장소별 형식은 `conventions/repos.md`에 둠
- 각 저장소의 `AGENTS.md`와 `CONTRIBUTING.md`는 `conventions/repos.md`의 견본으로 playbook을 가리키고, `CLAUDE.md`는 `@AGENTS.md` 한 줄로 둠

## 근거

- 자동화가 제목 `[Type]`에 의존하므로 제목만 통일해도 효과가 큼
- 커밋은 훅·type 목록이 저장소 도구 체인에 묶여 있어 통일 이득보다 전환 비용이 큼
- 규칙을 playbook 한 곳에 두고 저장소는 포인터만 두면 규칙이 저장소마다 어긋나지 않음

## 후속

| 항목 | 담당 | 기한 | 완료 조건 |
|---|---|---|---|
| 각 저장소 PR에서 저장소별 제목 검사 파일(`title-guard.yml` 등) 삭제, `pr-check` 호출 파일 도입 | 저장소별 담당 | [담당 미정] | `conventions/repos.md` 표의 "검사 적용"이 적용으로 바뀜 |
| 각 저장소 `AGENTS.md`·`CONTRIBUTING.md`에 안내 문구 견본 반영, `CLAUDE.md`는 `@AGENTS.md` | 저장소별 담당 | [담당 미정] | 저장소 PR 머지 |

- 되돌림 조건: 제목 검사 오탐이 반복되면 `v1` 태그를 이전 커밋으로 옮김(`decisions/0004-issue-pr-check-automation.md`)

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 없음 | | |

갱신(2026-11-28): issue-check·pr-check와 저장소별 auto-label·auto-assign·pr-base-guard·title-guard를 재사용 워크플로 `repo-rule-keeper.yml`("🛡️ repo-rule-keeper") 하나로 합침. 이유: 모든 저장소 공통 규칙이라 한 파일·한 이름으로 관리

갱신(2026-11-29): 원본을 PR용·이슈용 2개로 나누고 잡을 규칙별로 분리해 `v2` 태그로 호출함(decisions 0006)
