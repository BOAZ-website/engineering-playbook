> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-24
> 적용 범위: BOAZ 서비스운영팀의 5개 Product 전체
> 상태: 초안

# engineering-playbook

## 목적

- 서비스운영팀의 개발 프로세스 중 잘 바뀌지 않는 규칙과 절차의 기준 문서
- 기수 교체(약 6개월 주기) 때 새 팀원이 읽고 바로 작업을 시작할 수 있는 상태 유지
- 규칙이 바뀐 이유를 결정 기록(`decisions/`)으로 보존

## 다루는 것과 다루지 않는 것

| 자료 | 위치 | 비고 |
|---|---|---|
| 브랜치·커밋·PR 규칙, 코드 리뷰 규칙 | 이 저장소 | `conventions/` |
| 개발 주기, 릴리스 절차 | 이 저장소 | `process/` |
| 역할, 결정 권한, 접근 권한 규칙 | 이 저장소 | `org/` |
| Product별 작업 시작 가이드 | 이 저장소 | `products/` |
| 규칙을 바꾼 결정과 근거 | 이 저장소 | `decisions/` |
| 티켓, 스프린트, 회의록, 로드맵, 기획 문서 | 팀 Notion | 자주 바뀌는 자료 |
| 실명 명단, 연락처 | 팀 Notion | 이 저장소에 적지 않음 |
| 백엔드 기능·API 명세 | 비공개 저장소 backend-docs | 이 저장소는 위치만 안내 |
| 실행 방법, 환경 변수 표, 구조 설명 | 각 Product 저장소의 README | 복사하지 않고 경로로 가리킴 |
| 시크릿, 키, 계정 정보 | 어디에도 적지 않음 | 보관 방식은 `conventions/doc-writing.md` 참조 |

## 공개 규칙

- 이 저장소는 공개 저장소
- 실명, GitHub 계정명, 이메일, 연락처 기재 금지. 담당은 역할명(PM, Product Engineer)으로 기재
- 내부 링크(Notion, Google Drive, Figma, AWS 콘솔, Discord) 기재 금지. "팀 Notion의 ○○ 페이지"처럼 이름으로 지칭
- 시크릿, 계정 ID, ARN, 자원 ID, IP, 호스트명 등 기재 금지
- 전체 목록과 문체 규칙: `conventions/doc-writing.md`

## Product 목록

| Product | 저장소 | 현황 | Product 문서 |
|---|---|---|---|
| 관리자 페이지 | frontend_admin | 2026-10-31 기준 백엔드 미연동 UI 프로토타입 | 미작성 |
| 웹사이트 | frontend | 공개 홈페이지 | 미작성 |
| 백엔드 서버 | backend (명세: 비공개 저장소 backend-docs) | 사용자·관리자 API 서버 | `products/backend.md` |
| 인프라 | product-infra | Terraform 이전 작업 진행 | 미작성 |
| 디자인 시스템 | design-system | 2026-11-24 기준 v0.1.1 릴리스 완료. core·home·admin 폴더로 구조 개편 진행, Button 컴포넌트와 Storybook 구성 | 미작성 |

- 미작성 Product 문서는 `products/_template.md` 기준으로 작성
- Product Engineer는 담당 영역을 고정하지 않고 5개 Product 전체를 다룸

## 폴더 안내

| 폴더 | 내용 |
|---|---|
| `conventions/` | git, 코드 리뷰, 문서 작성 규칙 |
| `process/` | 개발 주기(`dev-cycle.md`), 릴리스(`release.md`) |
| `org/` | 역할과 권한(`roles-and-authority.md`) |
| `products/` | Product별 작업 가이드와 공통 템플릿 |
| `decisions/` | 결정 기록(번호순)과 템플릿 |

## 읽는 순서

### 첫날

| 순서 | 문서 | 확인할 것 |
|---|---|---|
| 1 | 이 문서 | 저장소 경계, 공개 규칙 |
| 2 | `conventions/doc-writing.md` | 적지 않는 것 목록 |
| 3 | `conventions/git.md` | 브랜치·커밋·PR 제목 형식 |
| 4 | `org/roles-and-authority.md` | 역할, 결정 권한 |

### 첫 주

| 순서 | 문서 | 확인할 것 |
|---|---|---|
| 5 | `conventions/code-review.md` | 리뷰어 수, 머지 조건 |
| 6 | `process/dev-cycle.md` | 스프린트, 티켓 흐름 |
| 7 | `process/release.md` | 릴리스, hotfix |
| 8 | `products/backend.md` | 백엔드 첫 작업 순서 |
| 9 | `decisions/0001-convention-unification.md`, `decisions/0002-team-structure.md` | 현행 규칙의 근거 |

- 첫 주 완료 기준: 이슈 1건에 연결된 PR 1건 머지

## 문서 고치는 방법

| 항목 | 규칙 |
|---|---|
| 변경 경로 | PR로만 변경. `main` 직접 push 금지. 이 저장소는 문서 저장소라 `dev` 없이 `main`만 씀(작업 브랜치 → `main` PR) |
| 리뷰 | 리뷰어 1명 이상 승인 후 머지 |
| 머리말 | 수정한 문서의 최종 검토일 갱신 |
| 규칙 변경 | 결정 기록을 새로 추가(`decisions/_template.md` 사용). 기존 기록은 수정하지 않고 상태만 변경 |
| 정기 검토 | 6개월마다 전체 문서 검토. 기수 교체 전에 완료 |
| 형식 | Markdown만 사용. 문서 사이트는 만들지 않음 |

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 미작성 Product 문서 4종의 작성 담당 | PM | 다음 기수 시작 전 |
| 정기 검토 담당 역할 | PM | 다음 기수 시작 전 |
