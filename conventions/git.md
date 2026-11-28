> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-28
> 적용 범위: BOAZ-website 조직의 모든 저장소
> 상태: 확정

# Git 규칙

근거: `decisions/0001-convention-unification.md`, `decisions/0005-title-type-unification.md`

이 문서는 브랜치, dev→main 흐름, 커밋 원칙을 정함. PR·이슈 제목과 이슈 연결은 `conventions/issue-pr.md`, 머지 조건은 `conventions/code-review.md`, 저장소마다 다른 값(기본 브랜치, 커밋 형식, 적용 현황)은 `conventions/repos.md`

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
- 저장소마다 기본 브랜치가 다름(`dev` 또는 `main`). 목록은 `conventions/repos.md`

### 브랜치 흐름

| 작업 | 분기 | PR 대상 | 머지 후 |
|---|---|---|---|
| 일반 작업 | `dev` | `dev` | 브랜치 삭제 |
| 릴리스 | `dev` | `main` | 없음. PR 제목은 `[Release] 내용` |
| hotfix | `main`에서 `hotfix/*` | `main` | `dev`에 역머지 |

- `main`에 변경이 들어가는 경로는 두 가지뿐임(2026-11-24 PM 확정)
  - 릴리스: `dev` → `main` PR
  - hotfix: `hotfix/*` → `main` PR
- 그 밖의 브랜치(`feat/*`, `fix/*` 등)에서 `main`으로 PR을 올리지 않음. 운영에 바로 반영해야 하는 변경은 반드시 `main`에서 `hotfix/*` 브랜치를 만들어 올림
- 예외: 배포하는 코드가 없는 문서 저장소(engineering-playbook, backend-docs)는 `dev` 없이 `main`만 쓰고 모든 PR을 `main` 대상으로 올림. 위 두 경로 규칙은 적용하지 않음
- `main` 직접 push 금지. 관리자도 예외 없음
- `release/*` 브랜치는 쓰지 않음
- 대상 브랜치 규칙은 BOAZ Rules가 검사함([issue-pr.md](issue-pr.md) "PR 검사")
- 강제 방법: 저장소별 룰셋으로 `main` 직접 push를 막고, 필수 검사 `pr-rules`로 머지를 차단함(`conventions/issue-pr.md` "PR 검사"). 저장소별 적용 현황과 일정은 `conventions/repos.md`
- hotfix 역머지 방법: 같은 `hotfix/*` 브랜치로 `dev` 대상 PR을 하나 더 올림(backend 선례: `main` 대상 PR과 `dev` 대상 PR을 한 쌍으로 올림)
- 다른 작업 브랜치 위에 작업 브랜치를 만들지 않음
- PR 1건에는 이슈 1건의 변경만 포함(연결 방법은 `conventions/issue-pr.md` "PR 제목과 이슈 연결")
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
| 형식 | `type: 설명` 꼴. type 목록과 이슈 번호 필수 여부는 저장소별로 다름(`conventions/repos.md`) |
| 이슈 번호 | `(#이슈번호)`를 끝에 적는 것을 권장. 훅이 강제하는 저장소는 반드시 적음 |
| 예 | `feat: 로그인 API 구현 (#12)` |
| 언어 | 설명은 한국어 |
| 단위 | 커밋 1건에 변경 1가지 |

- 왜: 커밋 메시지에 type과 이슈 번호가 있으면 기록만 보고 변경 종류와 관련 이슈를 알 수 있음
- 방법: type, 한국어 설명, 이슈 번호 순서로 씀. 한 커밋에 서로 다른 변경을 섞지 않음
- 커밋 형식은 저장소별로 유지하고 통일하지 않음. PR·이슈 제목 형식만 모든 저장소가 같음(`decisions/0005-title-type-unification.md`)
- `hotfix`는 커밋 type이 아님. hotfix 브랜치의 커밋은 `fix` 등 그 저장소가 허용하는 type으로 쓰고, PR 제목만 `[Hotfix]`로 씀(backend 훅은 `hotfix:` 커밋을 거부함)
- 기존 커밋 기록은 수정하지 않음
