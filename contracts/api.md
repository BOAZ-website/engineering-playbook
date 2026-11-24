> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-25
> 적용 범위: backend, frontend, frontend_admin
> 상태: 초안

# API 계약

## 결정 사항

| 항목 | 규칙 |
|---|---|
| 응답 형식 | 모든 응답을 공통 응답 래퍼로 감쌈 |
| JSON 필드명 | snake_case |
| 오류 코드 | 백엔드의 `ErrorCode` enum 한 곳에서 관리 |
| 프론트엔드 응답 타입 | 직접 작성하지 않음. 백엔드 OpenAPI 스펙에서 생성 |

- 근거: 화면과 서버가 같은 형식을 가정해야 파싱 오류가 줄어듦

## 응답 형식

| 필드 | 설명 | 성공 | 실패 |
|---|---|---|---|
| `status` | 처리 결과 | 포함 | 포함 |
| `data` | 응답 본문 | 포함 | 없음 |
| `errorCode` | 오류 코드 | 없음 | 포함 |
| `message` | 오류 메시지 | 없음 | 포함 |

- 백엔드 타입 이름은 `ApiResponse<T>`
- 오류는 `CustomException(ErrorCode)`를 던지면 전역 예외 처리기가 같은 형식으로 변환
- 프론트엔드 호출 헬퍼가 `data`를 꺼내므로 호출부는 `data` 안쪽 타입만 다룸
- `errorCode`의 실제 JSON 필드명 표기: 2026-11-25 기준 backend `application-local/dev/prod.yml`에 Jackson `property-naming-strategy: SNAKE_CASE` 설정됨. 따라서 `error_code`로 직렬화됨

## 코드 위치

| 대상 | 위치 |
|---|---|
| 오류 코드 | backend 저장소 `global/exception/ErrorCode` |
| 예외 변환 | backend 저장소 `GlobalExceptionHandler` |
| 생성 타입 | frontend 저장소 `src/shared/api/schema.d.ts` |
| 타입 별칭 | frontend 저장소 `src/shared/api/types.ts` |
| 호출 헬퍼 | frontend 저장소 `src/shared/api/client.ts` |
| 엔드포인트 상수 | frontend 저장소 `src/shared/api/end-point.ts` |

## 수정 금지 파일

| 파일 | 규칙 |
|---|---|
| `schema.d.ts` | 직접 수정 금지. 재생성으로만 갱신 |

## DTO 변경 시 절차

| 순서 | 작업 | 담당 |
|---|---|---|
| 1 | 백엔드 PR 본문에 "프론트엔드 타입 재생성 필요" 기재 | 백엔드 PR 작성자 |
| 2 | 팀 Notion의 해당 Ticket에 알림 | 백엔드 PR 작성자 |
| 3 | 백엔드 `dev` 머지 | 리뷰어 승인 후 PR 작성자 |
| 4 | frontend에서 `pnpm generate:types` 실행 | Product Engineer |
| 5 | 타입 오류 수정 후 프론트엔드 PR 생성 | Product Engineer |

- 생성에는 OpenAPI 스펙 접근 인증 값(`SWAGGER_BASIC_AUTH`)이 필요. 값은 개별 보관하고 저장소에 적지 않음
- 알림 자동화: 도입하지 않음. PR 작성자가 PR 본문에 "프론트엔드 타입 재생성 필요"를 적고 직접 알림. 놓치는 일이 반복되면 CI의 OpenAPI 차이 검출 도입을 검토
- 호환되지 않는 변경은 `contracts/release-order.md`의 3단계 절차 적용

## 변경 종류별 영향

| 변경 | 영향 | 조치 |
|---|---|---|
| 요청·응답 DTO 변경 | 생성 타입이 구버전이 됨 | 타입 재생성 |
| 필드 삭제·이름 변경 | 화면 오류 | `contracts/release-order.md` |
| 오류 코드 변경 | 프론트엔드 오류 처리 변경 | PR에 `ErrorCode` 변경 내용 기재 |
| 인증 필요 경로 추가 | 프론트엔드 토큰 처리 확인 | `contracts/auth.md` |

## 관리자 페이지

- frontend_admin은 2026-10-31 기준 백엔드 미연동. 임시 API가 같은 `/api/v1/...` 경로로 응답
- 연동 시 같은 절차 적용 [확인 필요: 관리자 페이지 타입 생성 방식]

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 타입 재생성 알림 자동화 | PM | `.github` 공용 검사 설계 시 |
| 관리자 페이지 타입 생성 방식 | PM | 백엔드 연동 착수 전 |
