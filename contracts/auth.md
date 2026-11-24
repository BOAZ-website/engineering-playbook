> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-25
> 적용 범위: backend, frontend, frontend_admin
> 상태: 확정

# 인증 계약

## 결정 사항

| 항목 | 규칙 |
|---|---|
| 일반 사용자 | 소셜 로그인으로 access token 발급 |
| 관리자 | 아이디·비밀번호 로그인 |
| 접근 제어 위치 | 백엔드 `SecurityConfig`의 경로 매처 |
| 미등록 경로 | 모두 `permitAll` |

- 근거: 접근 제어가 한 곳에만 있으므로 누락이 곧 무인증 노출

## 일반 사용자

| 단계 | 동작 |
|---|---|
| 1 | 소셜 로그인(Google, Kakao, Naver)으로 진입. 경로는 `/oauth2/authorize/*` |
| 2 | access token 수령 |
| 3 | 프론트엔드가 토큰을 localStorage의 `access_token` 키에 저장 |
| 4 | 요청마다 `Authorization: Bearer` 헤더로 전송 |
| 5 | 401 응답 시 쿠키 기반 재발급 API로 토큰 재발급 |
| 6 | 재발급 중 실패한 요청은 큐에 모았다가 재시도 |

- 재발급 API: `POST /api/v1/auth/user/refresh`
- 처리 위치: frontend 저장소 `src/shared/api/client.ts`

## 관리자

| 항목 | 내용 |
|---|---|
| 로그인 | 아이디·비밀번호 |
| 백엔드 역할 | `SUPER`, `TEAM` |
| 보호 범위 | `/api/v1/admin/**` 전체가 두 역할로 보호됨 |
| 관리자 페이지의 `HOST`, `CONTENT_ADMIN` | 백엔드에 없음. `products/admin.md` 참조 |
| 관리자 페이지 연동 상태 | 2026-10-31 기준 미연동 |

## 새 API 추가 시 주의

| 순서 | 작업 | 확인 |
|---|---|---|
| 1 | 인증이 필요한 경로를 `SecurityConfig`에 추가 | 미등록 경로는 모두 허용 |
| 2 | 컨트롤러에 인증 어노테이션 부착 | `products/backend.md`의 도메인 추가 체크리스트 |
| 3 | PR 본문에 `SecurityConfig` 변경 내용 기재 | 프론트엔드가 토큰 처리 확인 가능 |
| 4 | 관리자용 경로는 `/api/v1/admin/...` 사용 | 역할 보호 적용 |

## 코드 위치

| 대상 | 위치 |
|---|---|
| 접근 제어 | backend 저장소 `SecurityConfig` |
| 토큰 저장·재발급 처리 | frontend 저장소 `src/shared/api/client.ts` |
| 컨트롤러 테스트의 인증 설정 | backend 저장소 `TestSecurityConfig` |

## 관련 문서

- 응답 형식과 오류 코드: `contracts/api.md`
- 환경 변수 키(JWT, OAuth)는 backend 저장소 `README.md` 참조. 값은 적지 않음

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 관리자 페이지 연동 시 토큰 저장·재발급 방식 | PM | 백엔드 연동 착수 전 |
| `HOST`, `CONTENT_ADMIN` 역할의 백엔드 반영 | PM | 백엔드 연동 착수 전 |
