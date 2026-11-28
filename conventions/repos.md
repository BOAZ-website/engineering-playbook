> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-28
> 적용 범위: BOAZ-website 조직의 모든 저장소
> 상태: 확정

# 저장소별 차이

모든 저장소가 따르는 공통 규칙은 `conventions/git.md`, `conventions/issue-pr.md`, `conventions/code-review.md`에 있음. 이 문서는 저장소마다 다른 값(기본 브랜치, 커밋 형식, 저장소별 확인 항목, 검사 적용 상태, AI 지침 파일)만 모아 둠

근거: `decisions/0001-convention-unification.md`, `decisions/0005-title-type-unification.md`

## 저장소 현황

2026-11-28 조회. 목표 상태(모든 저장소에 repo-rule-keeper 적용, 공개 저장소 룰셋에 PR 승인 1과 필수 검사 `repo-rule-keeper`)와 다른 부분은 "차이"로 표시

### 브랜치·커밋·PR 확인

| 저장소 | 기본 브랜치 | 커밋 형식·훅 | PR 저장소별 확인 |
|---|---|---|---|
| backend | `dev` | `type: 설명 (#번호)`. type은 feat fix docs style refactor test chore. `commit-msg` 훅이 이슈 번호를 필수로 검사함 | 엔티티 변경 시 마이그레이션 파일과 `./gradlew test` |
| frontend | `dev` | `type: 설명`. 이슈 번호는 선택. type은 feat fix refactor docs init style chore test deploy add del types. 훅 없음(lefthook `pre-commit`은 포맷만 실행) | 미정(PR 템플릿 없음) |
| frontend_admin | `dev` | `type: 설명 (#번호)`. type은 위 7종과 ci build perf revert. 훅 없음(CONTRIBUTING 규약으로만 관리) | lint·format·check-types·build 4종 통과, UI 변경 시 전후 화면 |
| frontend_recruiting_admin | `main` | 규약 없음(혼재) | 없음 |
| product-infra | `dev` | `type: 설명 (#번호)`. `commit-msg`·`pre-commit` 훅 있음 | 자기 그룹 파일만 수정, plan의 교체·삭제 0건, 보호 자원 `prevent_destroy`, 시크릿·계정 ID 없음, 계정·자원 ID는 `docs/records/`에만 |
| backend-docs(비공개) | `main` | `type: 설명 (#번호)`. `commit-msg` 훅 있음 | `build_index`·`build_dbml --lint`, ErrorCode 동기화, 비고·`updated` 갱신 |
| engineering-playbook | `main` | 규약 `type: 설명 (#번호)`. 훅 없음 | 최종 검토일, 결정 기록, 문서 간 어긋남, 공개 저장소 확인 |
| design-system | `dev` | `type: 설명 (#번호)`. `commit-msg` 훅 있음 | 개인 정보 없음, 외부 자료 출처·라이선스 |

### 템플릿·검사·룰셋·AI 지침 파일

| 저장소 | 절차 전용 이슈 템플릿 | repo-rule-keeper 적용 | 룰셋 | AI 지침 파일 |
|---|---|---|---|---|
| backend | 없음(`feature_request.md`는 `task.yml`로 대체 예정) | 미적용(PR #260 열림) | 없음 | `AGENTS.md`(`CLAUDE.md`는 `@AGENTS.md`) |
| frontend | 없음 | 미적용(PR #211) | `dev` 룰셋 비활성 | `AGENTS.md` |
| frontend_admin | 없음 | 미적용(PR #102) | 없음 | `CLAUDE.md`, `CONTRIBUTING.md` |
| frontend_recruiting_admin | 없음(템플릿 없음) | 미적용(PR #7) | 없음 | 없음 |
| product-infra | 없음 | 미적용(PR #140) | 없음 | `CLAUDE.md` |
| backend-docs(비공개) | `docs_task.md`(유지) | 미적용(PR #27) | 없음(무료 플랜 비공개라 강제할 수 없어 표시만 함) | `AGENTS.md` |
| engineering-playbook | `recruiting-season.md`(유지) | 적용(로컬 호출 `repo-rule-keeper-run`, `repo-rule-keeper-issue-run`) | `main` 보호(2026-11-28 작업 중 일시 비활성) | 없음 |
| design-system | 없음 | 미적용(PR #100) | `v*` 태그 보호만 | `AGENTS.md` |

- 모든 저장소의 PR 머지 시 브랜치 자동 삭제가 켜져 있음(2026-11-28). 작업 종류 라벨 9종은 8개 저장소 모두 있음
- 기본 브랜치가 `main`인 저장소(engineering-playbook, backend-docs, frontend_recruiting_admin)는 `dev`가 없음. `Closes`는 기본 브랜치를 향한 PR에서만 동작하므로 이 저장소의 일반 PR도 `main` 대상임(`conventions/git.md` "브랜치 흐름")
- 커밋 훅은 로컬 설정(`git config core.hooksPath .githooks`)을 해야 동작함. backend 훅은 merge 커밋과 자동 생성 revert 커밋을 통과시킴
- 커밋 형식은 저장소별로 유지함(`decisions/0005-title-type-unification.md`). PR·이슈 제목은 모든 저장소가 `[Type] 내용`으로 같음(`conventions/issue-pr.md` "제목")

### 목표 상태와 차이

| 저장소 | 차이 |
|---|---|
| backend | 차이: repo-rule-keeper 미적용, 룰셋 없음. 흡수 대상 워크플로 남음: `auto-assign`, `pr-base-guard`, `title-guard` |
| frontend | 차이: repo-rule-keeper 미적용, `dev` 룰셋 비활성, PR 템플릿 없음, 커밋에 이슈 번호가 선택. 흡수 대상 워크플로 남음: `auto-assign`, `auto-label` |
| frontend_admin | 차이: repo-rule-keeper 미적용, 룰셋 없음 |
| frontend_recruiting_admin | 차이: repo-rule-keeper 미적용, 룰셋 없음, 템플릿 없음, 커밋 규약 없음, 이슈·PR 템플릿 도입 필요 |
| product-infra | 차이: repo-rule-keeper 미적용, 룰셋 없음. 흡수 대상 워크플로 남음: `auto-label`, `pr-base-guard`, `title-guard` |
| backend-docs | 차이: repo-rule-keeper 미적용. 룰셋은 비공개 플랜 한계로 강제 불가(표시만). 흡수 대상 워크플로 남음: `auto-assign`, `title-guard` |
| engineering-playbook | 차이: 룰셋 일시 비활성(작업 뒤 복구). 다시 켤 때 필수 검사를 `check-title`에서 `repo-rule-keeper`로 바꿈(`title-guard.yml`은 삭제함) |
| design-system | 차이: repo-rule-keeper 미적용, `dev`·`main` 룰셋 없음(`v*` 태그만 보호). 흡수 대상 워크플로 남음: `auto-assign`, `auto-label`, `pr-base-guard`, `title-guard` |

- 제목 검사, 자동 라벨, 작성자 자동 지정, 대상 브랜치 경고는 모두 repo-rule-keeper에 들어 있으므로 repo-rule-keeper 적용이 끝나면 저장소별 `title-guard.yml`, `auto-label.yml`, `auto-assign.yml`, `pr-base-guard.yml`은 삭제함. 빌드·테스트·배포 워크플로(ci, cd, deploy 등)는 저장소 고유라 유지함
- 저장소 고유라 repo-rule-keeper로 대체하지 않고 유지하는 워크플로: backend의 `docs-sync-reminder`, backend-docs의 `generated-files`, design-system의 `release-check`, 각 저장소의 CI·배포 워크플로
- frontend의 사람 이름 라벨(윤지·지선·태영)은 2026-11-28 삭제함(PM 결정, 담당자는 Assignee로 봄). frontend `🎉 INIT`(15건)·`🚀 Deploy`(9건), product-infra `🚀 DEPLOY`(3건)는 기존 이슈·PR에 `🧹 CHORE`·`🚀 RELEASE`를 붙인 뒤 삭제함(2026-11-28). GitHub 기본 라벨 9개(bug, documentation, enhancement 등)도 모든 저장소에서 삭제함. 남는 라벨은 작업 종류 9종과 backend 기능 라벨뿐
- 저장소 PR이 머지되면 이 표를 같은 PR에서 고치고 "최종 검토일"을 갱신함

## 적용 일정

| 순서 | 단계 | 일자 | 담당 | 완료 조건 |
|---|---|---|---|---|
| 1 | playbook 공개 | 2026-11-24 | PM | 저장소 공개 상태(완료) |
| 2 | 재사용 워크플로 도입(경고만) | 2026-11-28 | PM | playbook 로컬 호출 적용(완료) |
| 3 | 저장소별 전환 | 27&28기 시작 후 첫 스프린트 안에. 시점은 PM이 정함 | PM | 위 표의 전환 PR 머지, 저장소 포인터 반영 |
| 4 | 차단 전환 | 단계 3 완료 2주 뒤 | PM | 공용 검사 실패 시 머지 차단 확인(공개 저장소 룰셋에 필수 검사 `repo-rule-keeper`) |

- 기존 커밋 기록은 수정하지 않음. 적용 기준일부터 적용
- 단계 3은 다른 저장소 적용 기준. 2026-12 시즌 중에는 규칙 변경 작업 보류

## 새 저장소 추가

- [ ] 기존 이슈를 조직 Project에 넣고 Project 값을 지정함. 자동 추가 규칙은 무료 플랜이라 1개뿐이므로 PM이 일괄로 넣음
- [ ] `tools/callers/`의 호출 파일 2개(`repo-rule-keeper.yml` PR용, `repo-rule-keeper-issue.yml` 이슈용)를 `.github/workflows/`에 같은 이름으로 복사함(`@v2` 고정). 제목 검사·자동 라벨·Assignee 자동 지정·대상 브랜치 경고는 repo-rule-keeper에 들어 있으므로 저장소별 파일(`title-guard.yml`, `auto-label.yml`, `auto-assign.yml`, `pr-base-guard.yml`)을 따로 두지 않음
- [ ] `tools/templates/`의 이슈 폼(`task.yml`, `config.yml`)과 PR 템플릿을 `.github/`에 복사하고 PR 템플릿의 저장소별 확인 칸을 채움
- [ ] GitHub 기본 라벨을 지우고 작업 종류 라벨 9종을 이름·색·설명까지 같게 만듦(`conventions/issue-pr.md` "라벨")
- [ ] 공개 저장소면 룰셋(기본 브랜치, `dev`가 기본 브랜치이면 `main`도 포함)에 PR 승인 1과 필수 검사 `repo-rule-keeper`를 지정함
- [ ] 저장소 설정 "Automatically delete head branches"를 켬(`conventions/git.md` "브랜치")
- [ ] 커밋 훅을 설정하거나 커밋 형식을 이 문서의 표에 적음
- [ ] AI 지침 파일(`AGENTS.md`, `CONTRIBUTING.md`)에 아래 "저장소 쪽 안내 문구 견본"을 넣고 `CLAUDE.md`는 `@AGENTS.md` 한 줄로 둠
- [ ] AWS 배포가 필요하면 배포 롤 신뢰 조건을 `org/aws-access.md` 절차대로 설정함([org/aws-access.md](../org/aws-access.md))
- [ ] 이 문서의 표에 저장소 행을 추가함
- [ ] 워크스페이스 루트 `CLAUDE.md`의 저장소 표에 추가함

## 저장소 쪽 안내 문구 견본

- 각 저장소의 `AGENTS.md`와 `CONTRIBUTING.md`에 아래 견본을 넣음. 규칙 본문은 저장소에 복사하지 않고 playbook을 가리키기만 함
- `CLAUDE.md`는 `@AGENTS.md` 한 줄만 둠. `AGENTS.md`가 없는 저장소는 `CLAUDE.md`에 넣음
- `<저장소>` 행은 위 표의 행, `<형식>`과 `<항목>`은 위 표의 "커밋 형식·훅"과 "PR 저장소별 확인" 값

```
## 협업 규칙
브랜치·이슈·PR·리뷰는 engineering-playbook을 따른다.
- 공통: conventions/issue-pr.md, conventions/git.md, conventions/code-review.md
- 이 저장소의 차이: conventions/repos.md의 <저장소> 행
- 이슈 생성: tools/new-issue.sh(필수 6값), PR은 Closes 1개
이 저장소 고유 규칙(여기에만 둠):
- 커밋: <형식>, 훅 <있음/없음>
- PR 저장소별 확인: <항목>
```
