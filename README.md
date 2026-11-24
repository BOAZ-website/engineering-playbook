# engineering-playbook

BOAZ 서비스운영팀이 일하는 방식을 모아 둔 저장소입니다. 브랜치를 어떻게 만들고, PR을 어떻게 올리고, 누가 무엇을 결정하고, 운영에 어떻게 배포하는지를 한곳에서 찾을 수 있습니다.

## 이 저장소가 있는 이유

서비스운영팀은 약 6개월마다 기수가 바뀝니다. 그때마다 규칙이 사람을 따라 사라지거나 저장소마다 달라졌습니다. 이 저장소는 그 문제를 막으려고 만들었습니다.

- 새로 합류한 팀원이 이 저장소만 읽고 첫 작업을 시작할 수 있게 합니다.
- 팀원 누구나 5개 Product 어디서든 같은 규칙으로 작업할 수 있게 합니다.
- 규칙이 왜 그렇게 정해졌는지를 결정 기록으로 남겨, 다음 기수가 이유를 알고 고칠 수 있게 합니다.

## 누가 읽나요

- 서비스운영팀에 새로 합류한 PM과 Product Engineer
- 다른 Product의 작업을 처음 맡는 팀원
- BOAZ 저장소에 기여하려는 사람

## 어떻게 쓰나요

상황에 맞는 문서를 찾아 읽으면 됩니다.

| 이런 상황이라면 | 이 문서를 봅니다 |
|---|---|
| 팀에 처음 합류했다 | 아래 "처음 읽는 순서" |
| 브랜치를 만들거나 커밋·PR을 올린다 | [conventions/git.md](conventions/git.md) |
| PR을 리뷰하거나 리뷰를 받는다 | [conventions/code-review.md](conventions/code-review.md) |
| 티켓과 이슈를 만들고 진행 상태를 남긴다 | [process/dev-cycle.md](process/dev-cycle.md) |
| 운영에 배포하거나 급한 수정(hotfix)을 한다 | [process/release.md](process/release.md) |
| 누가 결정하는지, 어떤 권한이 필요한지 알고 싶다 | [org/roles-and-authority.md](org/roles-and-authority.md) |
| 백엔드 작업을 처음 한다 | [products/backend.md](products/backend.md) |
| 웹사이트, 관리자 페이지, 인프라, 디자인 시스템 작업을 처음 한다 | [products/website.md](products/website.md), [products/admin.md](products/admin.md), [products/infra.md](products/infra.md), [products/design-system.md](products/design-system.md) |
| API 응답 형식, 인증, 배포 순서를 확인한다 | [contracts/api.md](contracts/api.md), [contracts/auth.md](contracts/auth.md), [contracts/release-order.md](contracts/release-order.md) |
| 장애가 났다 | [process/incident.md](process/incident.md) |
| 권한을 요청하거나 회수한다 | [org/access.md](org/access.md) |
| 팀에 합류하거나 기수를 인수인계한다 | [org/onboarding.md](org/onboarding.md), [org/handover.md](org/handover.md) |
| 문서, 이슈, PR 본문을 쓴다 | [conventions/doc-writing.md](conventions/doc-writing.md) |
| 규칙이 왜 이렇게 됐는지 궁금하다 | [decisions/](decisions/) |
| 규칙을 바꾸고 싶다 | 아래 "문서를 고치는 방법" |

### 처음 읽는 순서

첫날에는 아래 네 개를 읽습니다.

1. 이 문서
2. [conventions/doc-writing.md](conventions/doc-writing.md): 공개 저장소에 적으면 안 되는 것
3. [conventions/git.md](conventions/git.md): 브랜치, 커밋, PR 제목 형식
4. [org/roles-and-authority.md](org/roles-and-authority.md): 역할과 결정 권한

첫 주에는 아래를 읽고, 이슈 하나에 연결된 PR 하나를 머지하는 것을 목표로 합니다.

5. [conventions/code-review.md](conventions/code-review.md)
6. [process/dev-cycle.md](process/dev-cycle.md)
7. [process/release.md](process/release.md)
8. 맡은 작업의 Product 문서([products/](products/))

## 팀과 Product

팀은 PM 1명과 Product Engineer 3명으로 구성합니다(다음 기수부터 적용). Product Engineer는 담당 영역을 고정하지 않고 아래 5개 Product를 모두 다룹니다.

| Product | 저장소 | 설명 | Product 문서 |
|---|---|---|---|
| 웹사이트 | frontend | 공개 홈페이지 | [products/website.md](products/website.md) |
| 관리자 페이지 | frontend_admin | 운영진용 관리자 콘솔 | [products/admin.md](products/admin.md) |
| 백엔드 서버 | backend | 사용자·관리자 API 서버 | [products/backend.md](products/backend.md) |
| 인프라 | product-infra | AWS 인프라와 Terraform | [products/infra.md](products/infra.md) |
| 디자인 시스템 | design-system | 공통 디자인 토큰과 컴포넌트 | [products/design-system.md](products/design-system.md) |

## 폴더 구성

| 폴더 | 담는 것 |
|---|---|
| [conventions/](conventions/) | 모든 저장소에 공통인 규칙: git, 코드 리뷰, 문서 작성 |
| [process/](process/) | 일하는 절차: 개발 주기, 릴리스와 hotfix |
| [org/](org/) | 역할, 결정 권한, 접근 권한 규칙 |
| [products/](products/) | Product별 작업 시작 안내 |
| [contracts/](contracts/) | Product 사이의 약속: API 형식, 인증, 배포 순서, 디자인 시스템 버전 |
| [decisions/](decisions/) | 규칙을 정하거나 바꾼 결정과 그 이유 |

## 여기에 없는 것

이 저장소는 잘 바뀌지 않는 규칙과 절차만 담습니다. 아래 자료는 다른 곳에 있습니다.

| 자료 | 있는 곳 |
|---|---|
| 티켓, 스프린트, 회의록, 로드맵, 기획 문서 | 팀 Notion |
| 팀원 명단과 연락처 | 팀 Notion |
| 실행 방법, 환경 변수, 코드 구조 | 각 Product 저장소의 README |
| 백엔드 기능 명세와 API 명세 | 비공개 저장소 |
| 시크릿, 키, 계정 정보 | 어디에도 적지 않습니다 |

## 공개 저장소 규칙

이 저장소는 누구나 볼 수 있습니다. 문서를 쓸 때 아래를 지킵니다.

- 사람은 실명이나 계정명 대신 역할명(PM, Product Engineer)으로 적습니다.
- 내부 링크(Notion, Google Drive, Figma, AWS 콘솔, Discord)를 적지 않습니다. "팀 Notion의 ○○ 페이지"처럼 이름으로만 가리킵니다.
- 시크릿, 계정 ID, 자원 ID, IP, 호스트명을 적지 않습니다.

전체 목록은 [conventions/doc-writing.md](conventions/doc-writing.md)에 있습니다.

## 문서를 고치는 방법

규칙이 실제와 다르거나 바꾸고 싶은 부분이 있으면 직접 고쳐 주세요.

1. 작업 브랜치를 만들어 문서를 고칩니다. 이 저장소는 문서 저장소라 `dev` 없이 `main`만 씁니다.
2. `main` 대상으로 PR을 올리고, 1명 이상의 승인을 받아 머지합니다. `main`에 직접 push하지 않습니다.
   - 이 저장소를 관리하는 PM은 승인 없이 PR을 머지할 수 있습니다. 이 저장소에만 두는 예외이고, `main` 직접 push는 PM도 할 수 없습니다.
3. 규칙 자체를 바꾸는 경우에는 [decisions/_template.md](decisions/_template.md)로 결정 기록을 함께 추가합니다.
4. 고친 문서 맨 위의 "최종 검토일"을 갱신합니다.

모든 문서는 6개월마다, 기수가 바뀌기 전에 한 번씩 검토합니다.

## 문서 상태

2026-11-24 기준 1차 초안입니다. 각 문서 맨 위에 담당 역할, 최종 검토일, 적용 범위, 상태가 적혀 있습니다. 통일 기준을 각 저장소에 실제로 적용하는 일정은 [conventions/git.md](conventions/git.md)의 "적용 일정"에 있습니다.
