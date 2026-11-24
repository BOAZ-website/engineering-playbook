> 담당 역할: Product Engineer | PM
> 최종 검토일: 2026-11-24
> 적용 범위: frontend 저장소(공개 홈페이지)
> 상태: 초안

# 웹사이트

저장소 README에 있는 내용(설치·실행 명령, 폴더 구조)은 복사하지 않고 경로로 가리킴

## 한눈에 보기

| 항목 | 내용 |
|---|---|
| 목적 | 공개 홈페이지 |
| 저장소 | frontend |
| 스택 | React 19, TypeScript, Vite, Vanilla Extract, React Router v7, TanStack Query, Axios, pnpm |
| 현황 | 운영 중 |
| 명세 위치 | 기능·화면 명세는 팀 Notion 참조 |

| 자료 | 위치 |
|---|---|
| 실행·빌드·린트 명령, 폴더 구조 | frontend 저장소 `README.md` |
| 문서 작성 규칙 | frontend 저장소 `AGENTS.md` |
| 커밋·브랜치·PR 규칙 | `conventions/git.md` |

## 첫 실행에 필요한 것

| 순서 | 작업 | 확인 |
|---|---|---|
| 1 | 저장소 `README.md`의 설치·실행 절차 수행 | 개발 서버 기동 |
| 2 | 루트에 `.env` 생성. 키 이름은 `VITE_API_BASE_URL`, `VITE_APP_URL` | 값은 팀 Notion 또는 PM 안내에 따라 개별 수령. 저장소에 커밋 금지 |
| 3 | 타입 재생성이 필요하면 `SWAGGER_BASIC_AUTH` 준비 | 값은 개별 보관 |

- Node 버전은 CI 기준 20, pnpm 버전은 CI 기준 10.18.2
- 설치 시 `prepare` 스크립트가 lefthook 훅을 설치함

## 구조와 규칙

| 항목 | 규칙 |
|---|---|
| 레이어 | FSD: `app`, `pages`, `widgets`, `features`, `entities`, `shared` |
| import 별칭 | `@/` |
| 라우터 위치 | `src/shared/router/`(`app`이 아님) |
| 엔드포인트 상수 | `src/shared/api/end-point.ts`의 `END_POINT` |
| 스타일 | Vanilla Extract. `pnpm lint:css`로 Stylelint 검사 |
| React Compiler | Babel 플러그인으로 활성화 |

- 하위 레이어가 상위 레이어를 import하지 않음 [확인 필요: ESLint 규칙으로 강제되는지]

## API 타입 생성

- 응답 타입은 직접 작성하지 않음. 백엔드 OpenAPI 스펙에서 생성한 `src/shared/api/schema.d.ts`를 `src/shared/api/types.ts`가 별칭으로 내보냄
- `schema.d.ts`는 수정 금지. 백엔드 DTO가 바뀌면 `pnpm generate:types`로 재생성
- 호출 헬퍼(`get`, `post`, `put`, `patch`, `del`)는 `src/shared/api/client.ts`. 응답의 `data` 안쪽 타입만 다룸
- 재생성 절차, 알림 책임, 응답 형식: `contracts/api.md`

## 인증 처리

- 소셜 로그인 후 받은 access token을 `Authorization: Bearer` 헤더로 전송
- 401 응답 시 토큰 재발급 후 실패한 요청을 재시도
- 상세: `contracts/auth.md`

## 커밋 훅 주의

| 훅 | 동작 | 주의 |
|---|---|---|
| pre-commit | `pnpm lint`, `pnpm format`, `pnpm lint:css` 병렬 실행 | `pnpm format`이 결과를 자동으로 스테이징(`stage_fixed`). 커밋에 포맷 변경이 섞일 수 있음 |
| commit-msg | `commitlint.config.ts`로 `type: 설명` 검사 | 허용 type 12종(feat fix refactor docs init style chore test deploy add del types) |
| pre-push | `pnpm check-types` | 타입 오류 시 push 실패 |

- 커밋 전 `git status`로 의도하지 않은 포맷 변경 포함 여부 확인
- `--no-verify` 사용 금지
- 이슈 번호 `(#이슈번호)`는 현재 훅이 강제하지 않음. 통일 기준과의 차이는 `conventions/git.md`의 저장소별 현황 참조

## PR 전 점검

| 항목 | 명령 | CI 실행 |
|---|---|---|
| ESLint | `pnpm lint` | 실행 |
| Stylelint | `pnpm lint:css` | 실행 |
| 타입 검사 | `pnpm check-types` | 실행 |
| 빌드 | `pnpm build` | 실행 |
| 포맷 | `pnpm format` | 미실행(훅에서만) |

- CI는 `dev` 대상 PR에서 실행
- 테스트 프레임워크 없음

## 배포와 되돌리기

| 항목 | 내용 |
|---|---|
| 배포 경로 | `main` push → 워크플로 `deploy-www.yml`: 빌드 → S3 동기화(삭제 포함) → CloudFront 캐시 무효화 |
| 빌드 환경 변수 | `VITE_API_BASE_URL`, `VITE_APP_URL`(GitHub 저장소 변수) |
| 승인 | 배포 job이 `production` 환경을 사용 [확인 필요: 환경 승인자 설정 여부] |
| 확인 방법 | [확인 필요: 배포 후 점검 항목] |
| 되돌리는 방법 | [확인 필요: 이전 빌드로 되돌리는 절차] |

- 백엔드 변경과 함께 배포할 때 순서: `contracts/release-order.md`

## 자주 하는 실수

| 실수 | 결과 | 예방 |
|---|---|---|
| `schema.d.ts` 직접 수정 | 재생성 시 변경 소실 | 백엔드 DTO 변경 후 재생성 |
| 백엔드 DTO 변경 후 재생성 누락 | 타입과 실제 응답 불일치 | PR 본문의 "프론트엔드 타입 재생성 필요" 확인 |
| 라우터를 `app`에서 찾음 | 파일 못 찾음 | `src/shared/router/` 확인 |
| 엔드포인트 문자열 직접 기재 | 경로 중복·불일치 | `END_POINT` 상수 사용 |
| 훅의 자동 포맷 결과 미확인 | 무관한 변경이 PR에 포함 | 커밋 전 diff 확인 |

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 배포 후 점검 항목과 되돌리는 절차 | Product Engineer(조사), PM(확정) | 2026-12 시즌 시작 전 |
| 레이어 의존 방향의 자동 검사 여부 | Product Engineer | 다음 기수 온보딩 전 |
