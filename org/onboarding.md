> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-24
> 적용 범위: 서비스운영팀 신규 합류자
> 상태: 초안

# 온보딩

## 합류 첫날

| 항목 | 담당 | 완료 조건 |
|---|---|---|
| 저장소 쓰기, AWS 읽기 전용, Terraform `plan` 권한 요청 | 신규 합류자 | 권한 부여 확인(`org/access.md`) |
| 팀 메신저 합류 | PM | 초대 수락 |
| `README.md` 읽기 | 신규 합류자 | 읽음 |
| `conventions/doc-writing.md` 읽기 | 신규 합류자 | 공개 저장소 금지 항목 숙지 |
| `conventions/git.md` 읽기 | 신규 합류자 | 브랜치·커밋·PR 제목 형식 숙지 |
| `org/roles-and-authority.md` 읽기 | 신규 합류자 | 역할과 결정 권한 숙지 |

## 첫 주

| 항목 | 담당 | 완료 조건 |
|---|---|---|
| 맡은 Product의 로컬 실행 | 신규 합류자 | Product 문서의 "처음 하는 작업 순서" 완료 |
| `conventions/code-review.md` 읽기 | 신규 합류자 | 읽음 |
| `process/dev-cycle.md` 읽기 | 신규 합류자 | 읽음 |
| `process/release.md` 읽기 | 신규 합류자 | 읽음 |
| `process/incident.md` 읽기 | 신규 합류자 | 읽음 |
| 이슈 1건 선택, PR 1건 머지 | 신규 합류자 | 이슈에 연결된 PR 머지 |
| 로컬 실행 중 어긋난 문서 수정 | 신규 합류자 | 수정 PR 머지 |

- 첫 PR은 작은 변경으로 선택. 문서 수정도 가능
- 로컬 환경 값은 PM 안내에 따라 개별 수령. 저장소에 커밋 금지

## Product별 시작 문서

| Product | 저장소 | 시작 문서 |
|---|---|---|
| 웹사이트 | frontend | `products/website.md` |
| 관리자 페이지 | frontend_admin | `products/admin.md` |
| 백엔드 서버 | backend | `products/backend.md` |
| 인프라 | product-infra | `products/infra.md` |
| 디자인 시스템 | design-system | `products/design-system.md` |

- Product 간 약속: `contracts/api.md`, `contracts/auth.md`, `contracts/release-order.md`, `contracts/design-system-versioning.md`
- Product Engineer는 5개 Product를 모두 다루므로 첫 달 안에 각 Product 문서를 한 번씩 읽음

## 질문하는 곳

| 질문 종류 | 위치 |
|---|---|
| 작업 범위, 우선순위 | 해당 이슈 댓글, PM |
| 코드, 구현 | 팀 메신저 또는 PR 댓글 |
| 권한 요청 | PM |
| 장애 | `process/incident.md` 절차 |
| 문서가 실제와 다름 | PR로 직접 수정 |

- 질문과 답은 이슈나 PR에 남기는 것을 우선. 메신저에서 끝난 결정은 이슈에 옮겨 기록

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 로컬 환경 값 전달 방식 | PM | 다음 기수 온보딩 전 |
| 온보딩 담당자 지정 | PM | 다음 기수 시작 전 |
