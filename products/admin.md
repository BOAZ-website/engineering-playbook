> 담당 역할: Product Engineer | PM
> 최종 검토일: 2026-11-25
> 적용 범위: frontend_admin 저장소(관리자 페이지)
> 상태: 초안 (백엔드 연동 범위·시즌 중 운영·타입 생성 방식은 연동 시작 후 확정)

# 관리자 페이지

저장소 문서에 있는 내용은 복사하지 않고 경로로 가리킴

## 메타

| 항목 | 내용 |
|---|---|
| 담당 역할 | Product Engineer(영역 고정 없음), PM(우선순위·승인) |
| 상태 | 백엔드 미연동 UI 프로토타입(2026-10-31 기준, 저장소 `CLAUDE.md`) |
| 저장소 | https://github.com/BOAZ-website/frontend_admin |
| 사용자 | 운영진(`SUPER`, `TEAM`), 출결 입력 담당(`HOST`), 콘텐츠 관리 담당(`CONTENT_ADMIN`) |
| 의존하는 Product | 백엔드 서버(연동 시), 인프라(정적 호스팅·CDN), 디자인 시스템(적용 예정) |
| 제공하는 API·산출물 | 관리자 콘솔(정적 번들) |
| 사용하는 API·산출물 | 연동 전에는 브라우저 안 임시 API·임시 DB. 연동 후 백엔드 `/api/v1/admin/...` |
| 관련 계약 문서 | `contracts/api.md`, `contracts/auth.md`, `contracts/design-system-versioning.md` |

## Product 소개

관리자 페이지는 운영진이 모집, 출결, 회원, 시스템 설정을 한 곳에서 관리하기 위한 콘솔. 2026-10-31 기준 백엔드와 연결되지 않았고, 화면이 임시 API로 동작함

| 화면 묶음(`src/pages`) | 내용 |
|---|---|
| `attendance-*`(`input`, `scores`, `rules`, `hosts`, `events`, `internal-category`) | 출결 입력, 점수 집계, 점수 규칙, HOST 계정, 행사 출결, BASE·ADV·스터디 출결 |
| `recruiting-manage`, `recruiting-evaluation` | 모집 관리, 지원자 평가 |
| `member-management` | 회원 관리 |
| `system-accounts`, `system-audit`, `system-semesters` | 계정, 감사 로그, 학기 관리 |

- 역할별로 사이드바 메뉴 범위가 달라짐. `HOST`, `CONTENT_ADMIN`은 백엔드에 아직 없음
- 임시 API 경로는 백엔드와 같은 `/api/v1/...` 형식이라 연동 시 호출 경로를 유지할 수 있음
- 백엔드에는 관리자용 모집·지원자 평가·후기·커리큘럼·FAQ·아카이브 컨트롤러가 이미 있음(`backend` 저장소 `domain/*`). 화면과의 대응은 [확인 필요: 연동 대상 범위]
- 모집 시즌에는 모집 관리와 지원자 평가 화면의 사용이 많아짐 [확인 필요: 시즌 중 운영 방식]

## 상태 요약

| 항목 | 내용 |
|---|---|
| 목적 | 운영진용 관리자 콘솔 |
| 저장소 | frontend_admin |
| 스택 | React 19, Vite, Tailwind v4, npm |
| 기준일 확인 | 2026-11-25 기준 백엔드 미연동. `src/shared/api/client.ts`가 환경 변수 `VITE_API_BASE_URL`이 있으면 해당 서버로 요청하고, 비어 있으면 브라우저 안의 임시 API(`src/shared/api/mock`)가 응답함. `.env.example`에서 이 값은 비어 있음 |

| 자료 | 위치 |
|---|---|
| 구조·아키텍처 상세 | frontend_admin 저장소 `CLAUDE.md` |
| 협업 규칙, 검사, lint 억제 목록 | `CONTRIBUTING.md`, `README.md` |
| 설계·명세·화면 문서 지도 | `docs/README.md` |
| 코드 작성 규칙 | `docs/04-code-style.md` |
| 임시 API·임시 DB 목록 | `docs/frontend/01-mock-api.md`, `docs/frontend/02-mock-db.md` |
| WBS와 진행 현황 | `docs/01-wbs.md`, `docs/03-wbs-fe.md` |

## 첫 실행

| 순서 | 작업 | 확인 |
|---|---|---|
| 1 | `.nvmrc`의 Node 버전(24.15.0) 사용 | `node --version` |
| 2 | `npm ci`, `npm run dev` 실행 | 개발 서버 기동 |
| 3 | 환경 변수 없이 실행 | 서버 주소 키(`VITE_API_BASE_URL`)가 없으면 임시 API가 응답 |

- 2026-10-31 기준 빌드에는 환경 변수가 필요 없음
- PR 검사에 배포 자격 증명을 추가하지 않음

## 구조 요약

| 항목 | 내용 |
|---|---|
| 라우팅 | react-router 미사용. `src/app/App.tsx`의 `ActivePage` 상태로 화면 전환 |
| 전역 상태 | `App.tsx`의 `useState`. 상태 관리 라이브러리 없음 |
| 레이어 | FSD(`app`, `pages`, `widgets`, `features`, `entities`, `shared`). 별칭 `@/` |
| 출결 모델 | 두 갈래이며 서로 연결되지 않음. 출결 작업 전 어느 모델의 화면인지 확인 |

## 페이지 추가 시 고칠 곳

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | `src/shared/config/activePage.ts` | `ActivePage` 유니온에 ID 추가 |
| 2 | `src/shared/config/pageLabels.ts` | `PAGE_LABELS`에 이름 추가. 누락 시 타입 오류 |
| 3 | `src/widgets/sidebar/ui/Sidebar.tsx` | `SIDEBAR_NAV`에 메뉴 추가 |
| 4 | `src/app/App.tsx` | 조건 렌더링 블록 추가 |

- ID 접두사(`att-`, `content-`, `recruiting`, `evaluation`, `system`)가 breadcrumb과 사이드바 섹션 판정에 쓰이므로 규칙 준수
- import 별칭을 바꾸면 `vite.config.ts`, `tsconfig.json`, `tsconfig.app.json` 세 파일 수정

## 임시 API와 백엔드 연동 시 바꿀 지점

| 항목 | 2026-10-31 기준 | 연동 시 |
|---|---|---|
| 호출 경로 | 화면 → `src/entities/*/api/*Api.ts` → `src/shared/api/client.ts` | 같은 경로 유지 |
| 응답 주체 | `src/shared/api/mock/`가 브라우저 안 임시 DB(SQLite, sql.js)로 응답 | 서버 주소 키 설정 시 실제 서버로 요청 |
| 임시 DB | `db/schema.sql`, `db/seed.sql` | 실제 DB와 별개. 연동 후 정리 대상 |
| 타입 | 직접 작성 | 타입 생성 방식 [확인 필요: 관리자 페이지 타입 생성 방식] |

- 연동 시 적용 절차: `contracts/api.md`, `contracts/auth.md`
- 임시 API 경로는 백엔드와 같은 `/api/v1/...` 형식
- 점수 계산은 화면이 아니라 점수 API가 수행. 화면은 결과만 표시

## 검증

| 항목 | 명령 | CI 실행 |
|---|---|---|
| ESLint(경고 0개) | `npm run lint` | 실행 |
| 포맷 | `npm run format:check` | 실행 |
| 타입 검사 | `npm run check-types` | 실행 |
| 빌드 | `npm run build` | 실행 |
| 테스트 | `npx tsx --test tests/*.test.ts` | 미실행. PR 전 로컬 실행 |

- 네 검사는 `main`, `dev` 대상 PR에서 독립 job으로 실행
- 화면(컴포넌트) 테스트 도구 없음

### lint 억제 목록 규칙

| 규칙 | 내용 |
|---|---|
| 목록 위치 | 루트 `eslint-suppressions.json`(파일·규칙별 개수) |
| 새 위반 숨기기 | 금지. `--suppress-all`로 목록을 늘리지 않음 |
| 기존 위반 수정 시 | `npx eslint . --prune-suppressions` 실행 후 변경분을 같은 PR에 포함 |
| 전체 미해결 확인 | `npx eslint . --no-suppressions` |

## 백엔드에 아직 없는 역할

| 역할 | 백엔드 | 관리자 페이지 |
|---|---|---|
| `SUPER`, `TEAM` | 있음. `/api/v1/admin/**` 보호 | 있음 |
| `HOST`, `CONTENT_ADMIN` | 없음 | 있음. 사이드바 메뉴 범위만 제한 |

- 역할 제한은 사이드바에만 적용됨. 주소 해시 접근은 막지 않음
- 권한 정본: 저장소 `docs/spec/06-system.md`

## 자주 하는 실수

| 실수 | 예방 |
|---|---|
| 페이지 추가 시 4곳 중 일부만 수정 | 위 표 4개 파일 확인 |
| `import type` 누락 | `verbatimModuleSyntax` 활성. 타입은 `import type` 사용 |
| 미사용 매개변수 | 밑줄 접두사(`_name`) |
| 출결 모델 혼동 | 화면이 속한 모델 먼저 확인 |
| 테스트 미실행 | CI가 실행하지 않으므로 로컬 실행 |
| 브랜치명의 `#` | 명령에서 따옴표로 감쌈 |

## 저장소별 규칙 현황

- `conventions/git.md`의 저장소별 현황 표 참조
- 저장소 문서 간 불일치: README는 기본 브랜치를 `dev`로, CONTRIBUTING은 `main`으로 기술
- 기본 브랜치는 `conventions/git.md` 기준(2026-11-24 조회, `dev`). 저장소 문서 정정은 별도 작업

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 백엔드 연동 일정과 타입 생성 방식 | PM | 연동 착수 전 |
| `HOST`, `CONTENT_ADMIN` 역할의 백엔드 추가 | PM | 연동 착수 전 |
| 저장소 CONTRIBUTING의 기본 브랜치 기술(`main`) 정정 | Product Engineer | 저장소별 전환 시 |
