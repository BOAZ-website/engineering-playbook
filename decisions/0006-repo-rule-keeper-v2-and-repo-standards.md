> 담당 역할: PM
> 최종 검토일: 2026-11-29
> 적용 범위: BOAZ-website 조직의 모든 저장소
> 상태: 확정

# 0006 repo-rule-keeper v2 구조와 저장소 공통 표준

## 상태

| 항목 | 값 |
|---|---|
| 상태 | 채택 |
| 결정일 | 2026-11-29 |
| 결정자(역할) | PM |
| 의견을 준 역할 | Product Engineer |

## 배경

- repo-rule-keeper를 단일 호출 방식(`v1`)으로 쓰면 PR 검사에서 어느 규칙을 어겼는지 잡 단위로 보이지 않고, 같은 커밋으로 `main`·`dev` PR을 함께 열면 커밋 상태가 서로 덮어쓰임
- 머지 방식, 룰셋, 저장소 CI 필수 검사, 비밀값, AI 도구 사용 규칙이 저장소마다 달라 기준이 문서에 없었음(`conventions/code-review.md` 미결 행)

## 선택지

| 선택지 | 내용 | 장점 | 단점 | 채택 | 탈락 사유 |
|---|---|---|---|---|---|
| A | 원본을 PR용·이슈용 2개로 나누고 잡을 규칙별로 분리해 `v2` 태그로 호출. 커밋 상태 이름은 대상 브랜치별 | 어느 규칙을 어겼는지 잡 이름으로 보이고, main·dev PR 결과가 섞이지 않음 | `v1`과 인터페이스가 달라 호출 파일을 다시 만들어야 함 | 예 | 해당 없음 |
| B | `v1` 단일 호출 유지 | 변경 없음 | 위 두 문제가 남음 | 아니오 | 규칙 위반 위치가 안 보이고 상태가 섞임 |

- 이전에 시도한 것: `v1` 단일 호출(`decisions/0004-issue-pr-check-automation.md`)

## 결정

### 1. repo-rule-keeper v2 구조

- 원본은 PR용 `.github/workflows/repo-rule-keeper.yml`과 이슈·댓글용 `.github/workflows/repo-rule-keeper-issue.yml` 2개
- PR 검사는 잡을 규칙별로 분리함(PR 정리, 제목, 대상 브랜치, 이슈 연결, 담당자·리뷰어, 체크리스트 사유, 최종 판정). 최종 판정이 커밋 상태를 기록함
- 커밋 상태 이름은 PR 대상이 저장소 기본 브랜치이면 `repo-rule-keeper`, 아니면 `repo-rule-keeper (<대상>)`. 룰셋 필수 검사는 기본 브랜치 룰셋 `repo-rule-keeper`, `dev`가 기본인 저장소의 `main` 룰셋 `repo-rule-keeper (main)`
- `Closes`는 같은 저장소 이슈만 인정함. 다른 저장소 이슈는 재검사가 되지 않아 실패 처리함. 저장소를 넘는 작업은 저장소마다 이슈를 만들고 상위 이슈로 묶음

### 2. 되돌리기

- 오탐이나 장애가 나면 PM이 `v2` 태그를 마지막 정상 커밋으로 옮김. 태그 이동 전후 커밋은 아래 표에 남김
- 긴급 완화가 필요하면 해당 저장소 룰셋의 필수 검사만 잠시 빼고, 승인 규칙은 유지함
- `v1` 태그는 잡 분리 전 단일 호출 방식이라 `v2`를 쓰는 저장소에는 효과가 없음. `v1`로 되돌리려면 호출 파일도 함께 되돌려야 함

마지막 정상 커밋

| 날짜 | 커밋 | 확인한 시험 PR |
|---|---|---|
| 2026-11-29 | `472ea98` | playbook #57, #59 |

### 3. 저장소 공통 표준

- 머지 방식: 모든 저장소 merge commit만 허용, squash·rebase는 끔. 이유: 커밋마다 `type: 설명 (#이슈)`가 남고 `dev` → `main` 릴리스·hotfix 역머지에서 이력이 갈라지지 않음. PR을 작게(PR 하나 = 이슈 하나) 유지해 이력을 읽기 쉽게 함(`conventions/code-review.md`)
- 릴리스 PR 승인 수: 일반 PR과 같이 1명
- 룰셋 표준: 대상은 기본 브랜치(`dev`가 기본이면 `main`도). 삭제·강제 push 금지, PR 필수(승인 1, 새 커밋 시 이전 승인 무효화, 리뷰 대화 모두 해결), 필수 검사는 `repo-rule-keeper`(main 룰셋은 `repo-rule-keeper (main)`)와 저장소 CI 검사, 필수 검사 출처는 GitHub Actions로 고정, merge commit만 허용. playbook에는 `v*` 태그 보호 룰셋(관리자만 태그 이동). backend-docs는 비공개라 무료 플랜에서 강제할 수 없어 표시만 함(`conventions/repos.md` "룰셋 표준")
- 저장소 CI 필수 검사: backend `CI`, frontend `CI`, frontend_admin `build`·`format`·`lint`·`typecheck`, product-infra `CI`, design-system `CI`, backend-docs `Generated Files`, engineering-playbook 없음, frontend_recruiting_admin 없음(임시 저장소라 도입하지 않음). 실제 체크 이름은 잡 이름이라 룰셋 설정 시 Actions 화면의 체크 이름으로 확인함. Fix PR에는 재현 테스트나 확인 절차를 PR 본문에 적음
- 비밀값: 공개 저장소 전부 secret scanning과 push protection을 켬. 시크릿은 코드, 문서, PR, 이슈, AI 도구에 넣지 않음
- AI 도구: 책임은 PR 작성자, 직접 확인한 내용만 "확인"에 적음, 시크릿·개인정보·비공개 명세는 외부 AI 도구에 넣지 않음, AI로 이슈를 만들 때는 `tools/new-issue.sh`, 저장소 AI 지침 파일에 playbook 포인터를 둠(`conventions/ai-usage.md`)

- 룰셋 우회(2026-11-29 추가, 이슈 #62): PO 팀(`2nd-po`)만 PR 머지 때 우회 가능. `main` 직접 push는 계속 금지. 우회하면 PR에 사유 댓글을 남기고 리뷰어가 사후 리뷰함. 이유: 리뷰어 3명이 모두 응답하지 못할 때 규칙·자동화 수정이 막히지 않게 하되, 우회 주체를 한 팀으로 좁히고 기록을 남김

## 근거

- 잡을 나누면 PR 검사 목록에서 위반 규칙이 바로 보이고, 대상 브랜치별 상태 이름으로 같은 커밋의 `main`·`dev` PR 결과가 섞이지 않음
- 같은 저장소 `Closes`만 인정하면 PR 재검사가 이슈 변경을 따라갈 수 있음
- 룰셋과 머지 방식을 한 표준으로 두면 저장소마다 기준을 따로 기억하지 않아도 됨
- 필수 검사 출처를 GitHub Actions로 고정하면 임의의 커밋 상태로 검사를 통과시킬 수 없음

## 후속

| 항목 | 담당 | 기한 | 완료 조건 |
|---|---|---|---|
| 저장소별 v2 호출 파일 PR 재작성(열린 PR 7개) | [담당 미정] | [담당 미정] | `conventions/repos.md` 표의 "repo-rule-keeper 적용"이 적용으로 바뀜 |
| 저장소별 룰셋과 머지 방식 설정 | PM | [담당 미정] | `conventions/repos.md` "룰셋 표준"과 같음 |
| 공개 저장소 secret scanning과 push protection 켜기 | PM | [담당 미정] | 모든 공개 저장소에서 켜짐 확인 |
| playbook `v*` 태그 보호 룰셋 | PM | [담당 미정] | 관리자만 태그 이동 가능 |

- 되돌림 조건: 검사 오탐이 반복되거나 룰셋 필수 검사로 머지가 막히는 문제가 생기면 위 "되돌리기"를 따름
- 이 결정은 `decisions/0004-issue-pr-check-automation.md`, `decisions/0005-title-type-unification.md`의 갱신 한 줄로 연결됨

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 없음 | | |
