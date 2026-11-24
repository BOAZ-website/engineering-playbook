> 담당 역할: Product Engineer | PM
> 최종 검토일: 2026-11-25
> 적용 범위: design-system 저장소
> 상태: 초안

# 디자인 시스템

저장소 README와 CONTRIBUTING에 있는 내용은 복사하지 않고 경로로 가리킴. 아래 사실은 2026-11-24 기준 저장소의 `README.md`, `CONTRIBUTING.md`, `package.json`에서 확인함

## 메타

| 항목 | 내용 |
|---|---|
| 담당 역할 | Product Engineer(영역 고정 없음), PM(우선순위·승인) |
| 상태 | 개발 중. `v0.1.1` 릴리스 완료(2026-11-24 기준), 컴포넌트 구현 진행 중 |
| 저장소 | https://github.com/BOAZ-website/design-system |
| 사용자 | 웹사이트와 관리자 페이지를 개발하는 Product Engineer |
| 의존하는 Product | 없음 |
| 제공하는 API·산출물 | CSS 변수(`--boaz-*`), Tailwind v4 테마, 토큰 참조 객체와 타입, React 컴포넌트, 컴포넌트·패턴 명세 |
| 사용하는 API·산출물 | 없음(Style Dictionary로 빌드) |
| 관련 계약 문서 | `contracts/design-system-versioning.md` |

## Product 소개

디자인 시스템은 웹사이트와 관리자 페이지가 같은 색, 글꼴, 간격, 컴포넌트를 쓰도록 기준을 한곳에서 관리하는 Product. 두 앱은 git 태그로 설치해 사용함

| 영역 | 내용 |
|---|---|
| 토큰 | 색, 타이포그래피, radius, spacing. 원본은 DTCG 형식 JSON |
| 명세 | 컴포넌트와 패턴(feedback, form, accessibility, voice & tone) 명세 |
| 구현 | 명세를 구현한 React 컴포넌트. Storybook으로 미리보기 |

- 이 저장소는 기준을 만들고, 두 앱 코드는 각 앱 저장소에서 고침(저장소 `AGENTS.md`)
- `home/`은 웹사이트용, 관리자 페이지용 `admin/`은 2026-11-24 기준 내용이 없음
- 토큰 이름 삭제·변경은 두 앱을 깨뜨리는 호환되지 않는 변경이라 버전 규칙이 중요(`contracts/design-system-versioning.md`)

## 역할과 범위

| 항목 | 내용 |
|---|---|
| 목적 | 웹사이트와 관리자 페이지가 함께 쓰는 디자인 토큰, 컴포넌트·패턴 명세, React 컴포넌트를 한곳에서 관리 |
| 저장소 | design-system |
| 사용처 | 웹사이트(`products/website.md`), 관리자 페이지(`products/admin.md`) |
| 스택 | 토큰은 DTCG 형식 JSON을 Style Dictionary로 빌드. 컴포넌트는 React 19, TypeScript, Vite. 미리보기는 Storybook, 테스트는 Vitest |
| 산출물 | CSS 변수(`--boaz-*`), Tailwind v4 테마, 토큰 참조 객체와 타입, 컴포넌트 JS와 CSS |
| 현황 | 2026-11-24 기준 `v0.1.1` 릴리스 완료(파운데이션 토큰). 컴포넌트 구현 진행 중이며 컴포넌트가 처음 들어가는 버전은 `v0.2.0` |

| 자료 | 위치 |
|---|---|
| 구성, 설치, 사용법 | design-system 저장소 `README.md` |
| 합류 순서, 권한, 개발 환경, 브랜치·리뷰·커밋 규약, PR 점검 항목 | 저장소 `CONTRIBUTING.md` |
| 토큰 이름 규칙, 명세·구현 절차, 호환되지 않는 변경 정책 | 저장소 `AGENTS.md` |
| 작업 목록과 완료 조건 | 저장소 `docs/wbs/` |

## 폴더 구성

| 폴더 | 담는 것 |
|---|---|
| `core/tokens/` | 두 앱 공통 글꼴 토큰(글꼴 스택, 굵기) |
| `home/tokens/` | 웹사이트 토큰(색, 타이포그래피, radius, spacing) |
| `home/components/`, `home/patterns/` | 웹사이트 컴포넌트 명세, 패턴과 가이드라인 |
| `home/src/` | 명세를 구현한 React 컴포넌트 |
| `admin/` | 관리자 페이지용. 2026-11-24 기준 폴더만 있고 내용은 미작성 |
| `dist/` | 빌드 결과. 직접 고치지 않고 커밋에 포함 |

## 로컬 개발과 미리보기

| 항목 | 내용 |
|---|---|
| 실행 환경 | Node 24(`.nvmrc`), npm |
| 첫 설정 | 커밋 메시지 훅 활성화 후 `npm ci`. 명령은 저장소 `CONTRIBUTING.md` "개발 환경" |
| 빌드 | `npm run build`. 토큰과 컴포넌트를 `dist/`로 생성 |
| 검사 | `npm run typecheck`, `npm test` |
| 미리보기 | `npm run storybook` |
| 명세만 고칠 때 | 설치와 빌드 불필요 |

## 작업 규칙

| 작업 | 규칙 |
|---|---|
| 토큰 변경 | 토큰 원본 JSON을 고친 뒤 빌드하고, 원본과 `dist/`를 같은 커밋에 넣음. CI가 커밋된 `dist/`와 빌드 결과가 다르면 실패 처리 |
| 토큰 값 변경의 커밋 type | `feat` 또는 `fix`. `style`은 포맷 변경에만 사용 |
| 단위 | 크기·행간·간격·radius 토큰은 px. 두 앱의 루트 글꼴 크기가 달라 rem을 쓰면 같은 토큰이 앱마다 다른 크기로 보임 |
| 컴포넌트 구현 | 명세의 Variants·States·Behavior·Accessibility 절을 모두 구현. 값은 토큰 변수로만 작성. 상태별 story와 키보드·aria 테스트 포함 |
| 명세 작성 | 저장소의 명세 양식을 따름. Figma에 없는 값은 추정이라고 표시. 대비 계산 근거 기재 |
| PR 점검 | 저장소 `CONTRIBUTING.md`의 "컴포넌트 PR 점검", "명세 PR 점검" |
| 머지 후 | 이슈 종료 확인, 팀 Notion 티켓 상태 갱신, 저장소 `docs/wbs/`의 티켓 상태 확인 |

## 버전과 릴리스

| 항목 | 내용 |
|---|---|
| 버전 규칙, 릴리스 절차, 앱 반영 방법 | `contracts/design-system-versioning.md` |
| 브랜치·PR | `dev` 기반 작업, `main` 대상 릴리스 PR(`conventions/git.md`) |
| 머지 방식 | merge commit |

## 변경이 다른 Product에 주는 영향

| 변경 | 영향받는 Product | 조치 |
|---|---|---|
| 토큰 이름 변경·삭제, 컴포넌트 속성·이름 변경 | 웹사이트, 관리자 페이지 | 호환되지 않는 변경. 저장소 `AGENTS.md`의 정책과 `contracts/design-system-versioning.md`를 따름 |
| 토큰 값 변경 | 웹사이트, 관리자 페이지 | 새 버전을 올려 쓸 때 두 앱 화면 확인 |
| 불러오는 경로 변경 | 웹사이트, 관리자 페이지 | `v0.2.0`부터 경로에 앱 이름(`home`)이 들어감. 앱의 import 경로 수정 필요 |

## 저장소별 규칙 현황

| 항목 | 현황 | 통일 기준과의 차이 |
|---|---|---|
| 브랜치 | `type/이슈번호-짧은-설명` | 없음 |
| 커밋 | `type: 내용 (#이슈번호)`. 훅이 강제. type 7종 | type 4종 부족 |
| PR 제목 | `[Type] 내용`. 티켓이 있으면 티켓 키를 앞에 둠. `[Hotfix]`는 PR 제목과 `hotfix/*` 브랜치에만 사용 | 제목 검사에 `[Release]` 없음 |
| 보호 | `dev`·`main` 직접 push를 서버가 막지 않고 규약으로만 금지. 승인과 CI 통과 없이도 머지 가능한 상태 | 통일 기준 적용 시 룰셋 필요 |
| 역할 이름 | 저장소 문서는 디자인 시스템 리드, 구현 담당, 명세 담당, 리뷰어로 구분 | 27&28기 체계(PM, Product Engineer)에 맞춰 저장소 문서 수정 필요 |

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| `admin/` 폴더 작성 시점과 관리자 페이지 반영 범위 | PM | 관리자 페이지 디자인 시스템 적용 착수 전 |
| 저장소 문서의 역할 이름을 새 체계로 바꾸는 시점 | PM | 27&28기 시작 전 |
| `dev`·`main` 보호 규칙 적용 | PM | `conventions/git.md` 적용 일정의 단계 3 |
