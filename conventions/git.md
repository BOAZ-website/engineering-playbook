> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-28
> 적용 범위: backend, frontend, frontend_admin, product-infra, design-system
> 상태: 확정

# Git 규칙

근거: `decisions/0001-convention-unification.md`

## 통일 기준

### 브랜치

| 항목 | 규칙 |
|---|---|
| 형식 | `type/이슈번호-짧은-설명` |
| 예 | `feat/12-login-api` |
| `#` | 쓰지 않음 |
| 설명 | 영어 소문자와 하이픈만 사용 |
| 보호 브랜치 | `main`, `dev`. 직접 커밋·push 금지 |
| 삭제 | PR을 머지하거나 머지 없이 닫으면 그 작업 브랜치를 즉시 삭제. 저장소 설정 "Automatically delete head branches"를 켜서 원격 브랜치는 자동 삭제함. 로컬 브랜치는 작업자가 `git fetch --prune` 뒤 `git branch -d`로 지움. `main`, `dev`는 삭제하지 않음 |

- 왜: 브랜치 이름에 이슈 번호가 있으면 브랜치만 보고 어떤 작업인지 이슈에서 바로 찾을 수 있음
- 방법: 이슈를 만든 뒤 최신 `dev`에서 `feat/12-login-api`처럼 이슈 번호와 영어 소문자 설명으로 브랜치를 만들고, 머지하면 바로 삭제함

### 브랜치 흐름

| 작업 | 분기 | PR 대상 | 머지 후 |
|---|---|---|---|
| 일반 작업 | `dev` | `dev` | 브랜치 삭제 |
| 릴리스 | `dev` | `main` | 없음. PR 제목은 `[Release] 내용`(현황: 저장소마다 다름, 아래 표) |
| hotfix | `main`에서 `hotfix/*` | `main` | `dev`에 역머지 |

- `main`에 변경이 들어가는 경로는 두 가지뿐임(2026-11-24 PM 확정)
  - 릴리스: `dev` → `main` PR
  - hotfix: `hotfix/*` → `main` PR
- 그 밖의 브랜치(`feat/*`, `fix/*` 등)에서 `main`으로 PR을 올리지 않음. 운영에 바로 반영해야 하는 변경은 반드시 `main`에서 `hotfix/*` 브랜치를 만들어 올림
- 예외: 배포하는 코드가 없는 문서 저장소(engineering-playbook, backend-docs)는 `dev` 없이 `main`만 쓰고 모든 PR을 `main` 대상으로 올림. 위 두 경로 규칙은 적용하지 않음
- `main` 직접 push 금지. 관리자도 예외 없음
- `release/*` 브랜치는 쓰지 않음(현황: 3개 저장소의 main 대상 PR 검사가 `release/*`를 허용하고 있음. 통일할 때 제거)
- 강제 방법: 저장소별 룰셋으로 `main` 직접 push를 막고, main 대상 PR 검사를 필수 검사로 지정해 `dev`와 `hotfix/*`가 아닌 PR을 차단함. 현황은 경고 댓글만 남기며 frontend, frontend_admin에는 검사가 없음. 적용은 아래 적용 일정의 단계 2~4
- hotfix 역머지 방법: 같은 `hotfix/*` 브랜치로 `dev` 대상 PR을 하나 더 올림(backend 선례: `main` 대상 PR과 `dev` 대상 PR을 한 쌍으로 올림)
- 다른 작업 브랜치 위에 작업 브랜치를 만들지 않음
- PR 1건에는 이슈 1건의 변경만 포함
- `dev`에는 완성된 변경만 올림. 미완성 작업은 자기 브랜치에 유지
- 충돌 시 최신 `dev`를 작업 브랜치에 머지. 강제 push 금지

왜 이렇게 하는지

- 운영에 들어가는 경로를 두 가지로 제한하면 리뷰를 거치지 않은 변경이 `main`에 들어가지 않음
- PR 1건에 이슈 1건만 담으면 리뷰 범위가 분명해지고 문제가 생겼을 때 어떤 변경 때문인지 찾기 쉬움

구체적으로 어떻게 하는지

- 긴급 수정이 필요해도 `feat/*` 같은 브랜치로 `main`에 PR을 올리지 않고 `main`에서 `hotfix/*` 브랜치를 만듦
- hotfix를 머지한 뒤에는 같은 브랜치로 `dev` 대상 PR을 올려 수정이 `dev`에도 들어가게 함

### 커밋

| 항목 | 규칙 |
|---|---|
| 형식 | `type: 설명 (#이슈번호)` |
| 예 | `feat: 로그인 API 구현 (#12)` |
| 언어 | 설명은 한국어 |
| 단위 | 커밋 1건에 변경 1가지 |

- 왜: 커밋 메시지에 type과 이슈 번호가 있으면 기록만 보고 변경 종류와 관련 이슈를 알 수 있음
- 방법: `feat: 로그인 API 구현 (#12)`처럼 type, 한국어 설명, 이슈 번호 순서로 씀. 한 커밋에 서로 다른 변경을 섞지 않음

허용 type

| type | 용도 |
|---|---|
| feat | 새 기능 |
| fix | 버그 수정 |
| docs | 문서 |
| style | 코드 포맷(화면 디자인 변경 아님) |
| refactor | 동작 변경 없는 구조 개선 |
| test | 테스트 |
| chore | 설정, 의존성 등 기타 |
| ci | CI 설정 |
| build | 빌드 설정 |
| perf | 성능 개선 |
| revert | 되돌리기 |

### PR 제목

| 항목 | 규칙 |
|---|---|
| 형식 | `[Type] 내용` |
| Type | 위 type의 첫 글자 대문자(`[Feat]`, `[Fix]`, `[Docs]`). PR 제목에만 `[Hotfix]`, `[Release]`를 추가로 허용 |
| 예 | `[Feat] 로그인 API 구현` |
| 본문 | 저장소 PR 템플릿의 섹션 이름과 순서 유지 |
| 이슈 연결 | PR 하나 = 이슈 하나. 항상 `Closes #번호`. PR 템플릿의 이슈 줄에 씀 |

- 이유: PR 제목과 본문의 형식을 맞춰 두면 어느 저장소에서든 PR 목록만 보고 변경 종류를 알 수 있음
- 방법: PR 제목은 `[Feat] 로그인 API 구현`처럼 쓰고, 본문에 `Closes #번호`를 적음
- `Closes #번호`를 쓰면 PR 화면 Development에 이슈가 자동으로 연결되고, 머지하면 이슈가 자동으로 닫힘. 손으로 연결하지 않음
- 작업이 PR 여러 개로 나뉘면 이슈를 하위 이슈(Sub-issue)로 미리 나누고 PR마다 하위 이슈 하나를 `Closes`로 닫음. 상위 이슈는 PR에 연결하지 않음. 하위 이슈가 모두 닫히고 상위 이슈 체크리스트(머지 뒤 확인 포함)가 끝나면 닫음(`tools/new-issue.sh -p 상위번호`, `conventions/issue-pr.md` "체크리스트 완료와 머지·종료")
- `Refs #번호`는 쓰지 않음. Development에 연결되지 않아 PR과 이슈의 관계를 보드에서 찾을 수 없음. 예외: 릴리스(`dev` → `main`)와 hotfix PR은 이슈를 연결하지 않음
- 키워드는 `Closes`, `Fixes`, `Resolves`(대소문자 무관, 콜론 허용). 다른 저장소 이슈는 `Closes BOAZ-website/frontend#209`. PR 하나에 `Closes`는 1개만 씀
- 키워드는 PR 본문이나 커밋 메시지에서만 동작함(PR 댓글은 동작하지 않음). PR을 올린 뒤 본문을 고쳐도 연결됨
- 키워드는 PR 대상이 저장소 기본 브랜치일 때만 동작함. 기능 PR은 기본 브랜치로 보냄. hotfix·릴리스 PR(`main` 대상)은 연결하지 않아도 됨
- 기본 브랜치(2026-11-28 조회): backend, frontend, frontend_admin, product-infra, design-system은 `dev`. engineering-playbook, backend-docs, frontend_recruiting_admin은 `main`(`dev` 없음)
- `hotfix`는 커밋 type이 아님. hotfix 브랜치의 커밋은 `fix` 등 허용 type으로 쓰고, PR 제목만 `[Hotfix]`로 씀(backend 훅은 `hotfix:` 커밋을 거부함)

### 머지

| 항목 | 규칙 |
|---|---|
| 조건 | 리뷰어 승인, 필수 검사 통과 |
| 방식 | merge commit(현황: 5개 저장소 모두 merge commit으로 머지하고 있음. design-system은 설정에서 merge commit만 허용, 나머지 4개는 squash·rebase도 허용 상태) |
| 금지 | 승인 전 머지, 작성자 단독 머지 |

- 리뷰 규칙 상세: `conventions/code-review.md`
- 이유: 승인 전 머지와 작성자 단독 머지를 막아 모든 변경이 다른 사람의 확인을 거치게 함
- 방법: 리뷰어 승인과 필수 검사 통과를 확인한 뒤 merge commit으로 머지함

## 저장소별 현황

2026-11-24 기준. 통일 기준과 다른 부분은 "차이" 열에 표시

| 저장소 | 커밋 | 브랜치(최근 PR 기준) | PR 제목 | main 대상 PR 검사 | 통일 기준과의 차이 |
|---|---|---|---|---|---|
| backend | `type: 설명 (#이슈번호)`. 훅이 `(#이슈번호)` 강제. type 7종(feat fix docs style refactor test chore) | `type/#이슈번호-설명` | `[Type] 내용`. 제목 검사 있음(type 7종 + hotfix) | 있음 | 브랜치에 `#` 사용, type 4종 부족, 제목 검사에 `[Release]` 없음 |
| product-infra | 훅이 `(#이슈번호)` 강제. type 7종 | `type/설명`(이슈 번호 없음) | `[Type] 내용`. 제목 검사 있음(type 7종 + hotfix, release) | 있음 | 브랜치에 이슈 번호 없음, type 4종 부족 |
| design-system | `type: 설명 (#이슈번호)` | `type/이슈번호-설명` | `[Type] 내용`. 제목 검사 있음(type 7종 + hotfix) | 있음 | 브랜치는 통일 기준과 같음. type 4종 부족, 제목 검사에 `[Release]` 없음 |
| frontend_admin | `type: 설명 (#이슈번호)`. 규약만 있고 훅 없음 | `type/#이슈번호-설명` | 커밋과 같은 형식(`type: 설명 (#이슈번호)`). 제목 검사 없음 | 없음 | PR 제목 형식, 브랜치에 `#` 사용, 검사 없음 |
| frontend | `type: 설명`. 이슈 번호 선택. commitlint가 type 검사(feat fix refactor docs init style chore test deploy add del types) | `type/설명/#이슈번호`. 이슈 번호 없는 브랜치도 있음 | `[Type] 내용`이 대부분. 릴리스 PR은 `dev → main`. 제목 검사 없음 | 없음 | 커밋에 이슈 번호 없음, type 구성 다름, 브랜치 형식 다름, 검사 없음 |

- 제목 검사와 main 대상 PR 검사는 3개 저장소 모두 경고 댓글만 남기고 머지를 막지 않음
- 3개 저장소의 검사 파일은 같은 내용을 복사한 것임. 통일할 때 조직 `.github` 저장소의 재사용 워크플로 하나로 바꿈
- 릴리스 PR 제목 현황: frontend는 `dev → main` 또는 기능 PR과 같은 제목, design-system은 `[Chore] v0.1.1 릴리스`

- 비공개 문서 저장소 backend-docs: `main`만 씀(위 브랜치 흐름의 예외). 커밋 훅·PR 제목 형식은 backend와 같고 type 7종이라 통일 기준보다 4종 부족
- backend 훅은 merge 커밋과 자동 생성 revert 커밋을 통과시킴
- 훅은 로컬 설정(`git config core.hooksPath .githooks`)을 해야 동작
- 이 표는 통일 기준을 각 저장소에 적용하기 전 상태를 기록한 것. 아래 "적용 일정"에 따라 차이를 줄여 감

## 적용 일정

| 순서 | 단계 | 일자 | 담당 | 완료 조건 |
|---|---|---|---|---|
| 1 | playbook 공개 | 2026-11-24 | PM | 저장소 공개 상태 |
| 2 | `.github` 공용 검사 도입(경고만) | 모집 시즌이 끝나고(season-down 후 동결 해제) 27&28기 인계 기간 안에 | PM | 공용 워크플로 머지 |
| 3 | 저장소별 전환 | 27&28기 시작 후 첫 스프린트 안에. 시점은 PM이 정함 | PM | 저장소별 전환 PR 머지 |
| 4 | 차단 전환 | 단계 3 완료 2주 뒤 | PM | 공용 검사 실패 시 머지 차단 확인 |

- 기존 커밋 기록은 수정하지 않음. 적용 기준일부터 적용
- 단계 3은 다른 저장소 적용 기준. 2026-12 시즌 중에는 규칙 변경 작업 보류

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 머지 방식을 merge commit으로 확정하고 4개 저장소 설정에서 squash·rebase를 끌지 | PM | 단계 2 전 |
| 릴리스 PR 제목을 `[Release] 내용`으로 확정할지 | PM | 단계 2 전 |
| 공용 검사 도입일, 적용 기준일 | PM | playbook 공개 직후 |
