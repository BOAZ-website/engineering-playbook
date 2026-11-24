> 담당 역할: Product Engineer | PM
> 최종 검토일: 2026-11-25
> 적용 범위: backend 저장소
> 상태: 초안

# 백엔드 서버

저장소 README에 있는 내용은 복사하지 않고 경로로 가리킴

## 메타

| 항목 | 내용 |
|---|---|
| 담당 역할 | Product Engineer(영역 고정 없음), PM(우선순위·승인) |
| 상태 | 운영 중(2026-11-25 기준) |
| 저장소 | https://github.com/BOAZ-website/backend |
| 사용자 | 웹사이트(공개 API 호출), 관리자 페이지(관리자 API 호출 예정), 운영진(Swagger UI) |
| 의존하는 Product | 인프라(서버·DB·배포 구성) |
| 제공하는 API·산출물 | REST API(`/api/v1/...`, 관리자용은 `/api/v1/admin/...`), OpenAPI 스펙 |
| 사용하는 API·산출물 | MySQL, S3, Google·Kakao·Naver 소셜 로그인 |
| 관련 계약 문서 | `contracts/api.md`, `contracts/auth.md`, `contracts/release-order.md` |

## Product 소개

백엔드 서버는 사용자 API와 관리자 API를 한 애플리케이션으로 제공하는 Spring Boot 서버. 웹사이트가 보여 주는 모집·후기·커리큘럼·아카이브·FAQ 데이터와 로그인, 지원서 접수를 처리함

| 도메인 폴더 | 내용 |
|---|---|
| `recruitment` | 모집 정보, 지원서, 지원자 평가(관리자용 `ApplicantEvaluationAdminController` 포함) |
| `auth`, `user`, `admin` | 소셜 로그인과 토큰 재발급, 사용자 정보, 관리자 로그인과 관리자 계정 |
| `review`, `curriculum`, `archive`, `faq` | 후기, 커리큘럼, 아카이브(프로젝트·블로그·활동·terms), FAQ. 공개용과 관리자용 컨트롤러가 나뉨 |

- 웹사이트는 `/api/v1/recruitment`, `/api/v1/reviews`, `/api/v1/curriculums`, `/api/v1/archiving` 등을 호출함(`frontend/src/shared/api/end-point.ts`)
- 관리자 API는 `SUPER`, `TEAM` 역할로 보호됨. 관리자 페이지는 2026-10-31 기준 백엔드에 연결되지 않음
- 응답은 `ApiResponse<T>`, JSON 필드는 snake_case. DTO가 바뀌면 웹사이트 타입 재생성이 필요(`contracts/api.md`)
- 모집 시즌에는 로드밸런서 + 서버 2대 + 데이터베이스 Multi-AZ 구성으로 전환됨(`products/infra.md`)

| 자료 | 위치 |
|---|---|
| 기술 스택, 실행 방법, 환경 변수 표, 패키지 구조, 배포 구성 | backend 저장소 `README.md` |
| DB 마이그레이션 규칙, 배포 순서, 실패 복구 | backend 저장소 `src/main/resources/db/README.md` |
| 작업 규칙 | backend 저장소 `AGENTS.md` |
| 기능·API 명세, 테스트 명세 | 비공개 저장소 backend-docs 참조 |
| 인프라 구성 | `product-infra` 저장소, 저장소 README의 아키텍처 절 |

## 처음 하는 작업 순서

| 순서 | 작업 | 확인 |
|---|---|---|
| 1 | JDK 21, Docker 준비 | `docker --version` 실행 |
| 2 | 저장소 복제 후 `git config core.hooksPath .githooks` 실행 | 커밋 메시지 검사 활성화 |
| 3 | 로컬 MySQL 실행(`docker compose up -d mysql`) | 컨테이너 기동 |
| 4 | 루트에 `.env` 생성. 필수 키는 README 환경 변수 표 참조 | 값은 팀 Notion 또는 PM 안내에 따라 개별 발급. 저장소에 커밋 금지 |
| 5 | `./gradlew bootRun` 실행 | 헬스체크 응답 `UP`, Swagger UI 접속 |
| 6 | `./gradlew test` 실행 | Docker 실행 상태에서 전체 통과 |
| 7 | 이슈 1건 선택 후 `dev`에서 브랜치 생성, 첫 PR 생성 | `conventions/git.md` |

- 필수 키가 없으면 앱이 기동하지 않음
- `local` 프로필은 기동 시 테이블 생성과 시드 데이터 입력을 수행. 마이그레이션 파일은 적용하지 않음
- 시드 계정 정보는 저장소의 시드 파일에서 확인. 이 문서에 적지 않음
- 첫 도메인 작업 시 Service 단위 테스트 최소 1건 함께 작성

## 테스트 4계층

| 계층 | 도구 | 대상 | Docker |
|---|---|---|---|
| Service | JUnit 5, Mockito, AssertJ | 비즈니스 규칙, 분기, 예외 | 불필요 |
| Controller | `@WebMvcTest`, `TestSecurityConfig`, 서비스는 `@MockitoBean` | HTTP 계약, 검증, 인증·인가 | 불필요 |
| Repository | `@DataJpaTest`, `TestcontainersBase` 상속 | JPA 쿼리, 제약, 연관관계 | 필요 |
| Integration | `@SpringBootTest`, `TestcontainersBase` 상속 | Service와 Repository 연결, 도메인 시나리오 | 필요 |

- 모든 테스트는 `@ActiveProfiles("test")` 사용. 외부 연동용 더미 설정은 `src/test/resources/application-test.yml`
- 테스트 DB는 MySQL 8.4 Testcontainers. 마이그레이션 파일을 V1부터 실행한 뒤 엔티티와 대조
- 위 4계층과 별도로 JWT, 인증 필터, OAuth2 등 전역 테스트 존재
- 단일 클래스 실행: `./gradlew test --tests '<클래스 전체 이름>'`

## 도메인 추가 체크리스트

| 순서 | 항목 | 완료 조건 |
|---|---|---|
| 1 | 요구사항과 API 목록 확인 | backend-docs 명세 또는 Ticket 확인 |
| 2 | `domain/<이름>/{controller,service,repository,entity,dto/{request,response}}` 생성 | 패키지 존재 |
| 3 | 공개용과 관리자용 컨트롤러 분리 | 관리자용은 `/api/v1/admin/...` 경로 |
| 4 | 응답은 `ApiResponse<T>`로 감쌈 | 성공·실패 형식 일치 |
| 5 | 오류는 `ErrorCode` enum과 `CustomException` 사용 | `ErrorCode`에 코드 추가 |
| 6 | 인증이 필요한 경로를 `SecurityConfig`에 추가 | 미등록 경로는 모두 허용 상태이므로 누락 시 무인증 노출 |
| 7 | Swagger 어노테이션 | 모든 컨트롤러에 `@Tag`(관리자용은 `[Admin]` 접두사), 인증 필요 시 `@SecurityRequirement(name = "bearerAuth")` |
| 8 | 엔티티 변경 시 마이그레이션 파일 추가 | `./gradlew test` 통과 |
| 9 | 테스트 4계층 작성 | 계층별 테스트 파일 존재 |
| 10 | PR 템플릿 확인 항목 체크 | 마이그레이션 항목 포함 |

- 이름 규칙: DTO는 `XXXRequest`, `XXXResponse`. 서비스 메서드는 동사 + 명사. enum 상수는 대문자 스네이크
- 의존 방향: Controller → Service → Repository → Entity. 하위 계층이 상위 계층을 참조하지 않음
- JSON 필드는 snake_case

## API 변경이 프론트엔드에 주는 영향

| 변경 | 영향 | 조치 |
|---|---|---|
| 응답·요청 DTO 변경 | `frontend`의 `src/shared/api/schema.d.ts`가 구버전이 됨 | 프론트엔드에서 `pnpm generate:types` 재실행. PR 본문에 알림 |
| 필드 삭제·이름 변경 | 프론트엔드 화면 오류 | 배포 순서 협의(`process/release.md`) |
| 오류 코드 변경 | 프론트엔드 오류 처리 변경 | `ErrorCode` 변경 내용을 PR에 기재 |
| 인증이 필요한 경로 추가 | 프론트엔드 토큰 처리 확인 | `SecurityConfig` 변경 내용을 PR에 기재 |

- 운영 OpenAPI 스펙에는 Basic 인증이 있어 타입 재생성에 인증 값이 필요. 값은 팀 Notion 안내에 따라 개별 보관
- `frontend_admin`은 2026-10-31 기준 백엔드 미연동. 연동 시 영향 범위 재확인

## DB 스키마 변경 요약

- 엔티티 변경 PR에 Flyway 마이그레이션 파일 포함
- 공유 DB에 실행된 파일은 수정 금지. 새 파일로 추가
- 새 파일 버전은 `dev`의 모든 파일보다 높게 설정
- 직전 버전 앱과 호환되는지 확인(롤백 대비)
- 데이터 백필은 마이그레이션에 넣지 않고 배포 PR 본문에 기록
- 전체 규칙: backend 저장소 `src/main/resources/db/README.md`, 요약: `process/release.md`

## 배포와 되돌리기 요약

| 항목 | 내용 |
|---|---|
| 배포 경로 | `main` 반영 → GitHub Actions 빌드 → S3 업로드 → CodeDeploy → EC2 systemd 서비스 |
| 환경 변수 | 운영 값은 SSM Parameter Store에서 배포 시 주입. AWS 자격 증명은 EC2 IAM 역할 |
| 마이그레이션 | 앱 기동 시 Flyway 실행 |
| 실패 | 헬스체크 실패 시 CodeDeploy가 직전 버전 앱을 재배포 |
| 후속 조치 | 마이그레이션 실패면 다음 배포 전 실패 기록 복구 필수 |
| 복구 불가 시 | 자동 백업 기준 시점 복원. 새 DB 인스턴스를 만드는 작업이며 인프라 작업 권한 보유자가 수행 |

- 복원 시각 이후의 데이터는 사라지므로 복원 전 쓰기 발생 여부 확인
- 복구 절차 전문: backend 저장소 `db/README.md`의 "마이그레이션이 실패했을 때"
- 장애 시 복구 담당 지정: 장애 대응 절차 문서(`process/incident.md`)는 미작성. 작성 전까지 PM이 지정

## 비공개 저장소 참조

| 내용 | 위치 |
|---|---|
| 기능 명세, API 명세 | backend-docs(비공개) |
| 테스트 명세 | backend-docs(비공개) |
| 접근 권한 | PM에게 요청 |

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 운영 장애 대응 절차 문서화 | PM | 인프라 Product 문서 작성 시 |
| 로컬 환경 값 전달 방식 | PM | 27&28기 온보딩 전 |
| backend README의 커밋 type 안내를 통일 기준 11종으로 갱신 | Product Engineer | 저장소별 전환 시 |
