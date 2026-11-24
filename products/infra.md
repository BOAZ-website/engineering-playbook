> 담당 역할: Product Engineer | PM
> 최종 검토일: 2026-11-25
> 적용 범위: product-infra 저장소
> 상태: 확정

# 인프라

저장소 README에 있는 내용(설치·명령, 폴더 구조)은 복사하지 않고 경로로 가리킴. 자원 ID·계정 ID·호스트명·명령 상세는 비공개 운영 문서 참조

## 메타

| 항목 | 내용 |
|---|---|
| 담당 역할 | Product Engineer(영역 고정 없음, Terraform apply 권한 보유자), PM(다운타임·시즌 일정 승인) |
| 상태 | 개발 중. 기존 AWS 자원을 Terraform으로 가져오는(import) 작업 진행 중. 2026-11-25 기준 9개 그룹 중 네트워크·권한·파라미터·스토리지·배포 5개 완료, 경보·서버 2개 작업 중, 데이터베이스·CDN 2개 대기. 데이터베이스·CDN은 시즌 뒤로 미룸 |
| 저장소 | https://github.com/BOAZ-website/product-infra |
| 사용자 | Product Engineer, PM |
| 의존하는 Product | 다른 Product에 의존하지 않음. 반대로 백엔드 서버, 웹사이트, 관리자 페이지가 이 인프라 위에서 동작함 |
| 제공하는 API·산출물 | Terraform 코드(네트워크, 서버, 데이터베이스, 스토리지, CDN, 배포, 권한, 파라미터 모듈), 시즌 전환 런북 |
| 사용하는 API·산출물 | AWS, GitHub Actions(읽기 전용 plan), 백엔드 저장소의 시즌 전환 스크립트(이전 전까지) |
| 관련 계약 문서 | 해당 없음. 릴리스·시즌 충돌은 `process/release.md` |

## Product 소개

인프라는 BOAZ 홈페이지가 도는 AWS 환경(서버, 데이터베이스, 정적 호스팅, CDN, 배포 파이프라인)을 콘솔·스크립트 대신 Terraform 코드로 관리하려는 Product. 애플리케이션 저장소와 분리되어 인프라만 담당함

| 대상 | 구성 |
|---|---|
| 웹사이트·관리자 페이지 | 정적 호스팅 + CDN |
| 백엔드 서버 | 서버(EC2) + CodeDeploy 배포, systemd 서비스로 실행 |
| 평시 | 서버 1대 + 데이터베이스 |
| 모집 시즌 | 로드밸런서 + 서버 2대 + 데이터베이스 Multi-AZ. API 앞단 CDN의 요청 대상도 바뀜 |

- 시즌 전환은 `season_capacity`, `api_origin` 두 Terraform 변수로 관리하는 방향. 2026-11-25 기준 전환은 backend 저장소의 `infra/scripts/season-up.sh`, `season-down.sh`가 수행함
- 데이터베이스, 스토리지, CDN은 삭제·교체 시 데이터 손실 위험이 있어 보호 대상(아래 "보호 리소스 규칙")
- 모집 시즌 시작과 종료가 가장 중요한 운영 시기. season-up은 서류 모집 시작 전, season-down은 서류 모집 마감 직후(면접 기간에는 시즌 구성을 유지하지 않음). 2026-12 시즌은 2026-11-27 season-up

## 목적과 범위

| 항목 | 내용 |
|---|---|
| 목적 | 운영 AWS 인프라를 Terraform으로 코드 관리 |
| 저장소 | product-infra |
| 범위 In | 네트워크, 서버, 데이터베이스, 정적 호스팅, CDN, 배포, 권한 설정, 시즌 전환 |
| 범위 Out | 애플리케이션 코드(backend, frontend, frontend_admin) |
| 현황 | 기존 자원을 Terraform으로 가져오는(import) 작업 진행 중. 2026-11-25 기준 9개 그룹 중 네트워크·권한·파라미터·스토리지·배포 5개 완료, 경보·서버 2개 작업 중, 데이터베이스·CDN 2개 대기. 데이터베이스·CDN은 시즌 뒤로 미룸 |

| 자료 | 위치 |
|---|---|
| 사전 준비, 명령, 폴더 구조 | product-infra 저장소 `README.md` |
| 문서 지도, 역할별 읽기 순서 | `docs/README.md` |
| 그룹 import 공통 절차 | `docs/guides/import-procedure.md` |
| 시즌 전환 런북 | `docs/guides/season-runbook.md` |
| 작업 규칙 | `CLAUDE.md` |
| 조사·결정·import 기록 | 저장소 `docs/records/`. 식별자가 있어 이 문서에서 요약하지 않음 |

## 환경 구성 개요

| 구성 | 역할 |
|---|---|
| 평시 | 단일 API 서버 + 데이터베이스 |
| 모집 시즌 | 로드밸런서 + API 서버 2대 + 데이터베이스 Multi-AZ |
| 웹사이트·관리자 페이지 | 정적 호스팅 + CDN |
| API 앞단 | CDN. 평시와 시즌에 요청 대상이 다름 |

- 시즌 전환은 Terraform 변수 2개로 관리 방향. 2026-11-25 기준 backend 저장소의 `infra/scripts/season-up.sh`, `season-down.sh`로 수행
- 기존 구성과 이전 계획: `docs/overview/`

## 변경 절차

| 순서 | 단계 | 의미 |
|---|---|---|
| 1 | 이슈 생성 | 변경 이유와 범위 기록. 티켓과 1:1 |
| 2 | 브랜치·PR | `dev` 대상 PR. 제목 `[Type] 내용`, 커밋은 `(#이슈번호)` 필수 |
| 3 | CI 검사 | 민감 정보 검사, 포맷, 검증, 린트, 테스트 |
| 4 | plan 검토 | PR 코멘트의 plan 요약 확인. 의도하지 않은 변경이 없어야 함 |
| 5 | plan 게이트 | 보호 자원의 삭제·교체 등 금지 변경을 plan에서 찾아 실패 처리 |
| 6 | 리뷰 | 리뷰어 1명 이상에게 요청. import·보호 자원 변경은 리뷰 후 머지 |
| 7 | 머지 | 필수 검사 `Apply Ready` 통과 필요 |
| 8 | apply | 관리자만 실행. 한 번에 한 그룹. 실행 후 plan 변경 0건 확인 |

- 읽기 전용 권한자는 plan과 PR까지 수행. 머지·apply는 관리자에게 요청
- 관리자도 코드·Terraform·스크립트 변경은 PR로 머지
- 문서만 바꾸는 변경은 관리자가 `dev`에 직접 push 가능(2026-11-24부터). 민감 정보 검사 통과와 강제 push 금지 조건
- 관리자에게도 규칙 적용(enforce admins)은 꺼져 있어 기술적 우회는 가능. 규칙으로 금지
- 리뷰 승인은 자동 강제하지 않음(승인 0명). 리뷰 요청은 규칙

## 시즌 전환

| 항목 | 내용 |
|---|---|
| 시점 | 서류 모집 시작 전 season-up, 서류 모집 마감 직후 season-down |
| 담당 | 인프라를 맡은 Product Engineer가 실행하고 PM이 감시와 원상 복구 판단. Terraform 전환 이전 후에는 인프라 apply 규칙(`org/pm-guide.md`)에 따라 PM이 실행 |
| 승인 수준 | PM이 일정과 다운타임 승인 |
| 릴리스와의 관계 | 전환 작업이 릴리스보다 우선. 상세는 `process/release.md` |
| 기록 | 전환 당일 이슈에 결과 댓글 |

- 전환 중 장애: `process/incident.md`
- 절차 상세: 저장소 `docs/guides/season-runbook.md`

## 보호 리소스 규칙

| 대상 | 규칙 |
|---|---|
| 데이터베이스, 스토리지, CDN | `prevent_destroy`로 보호 |
| plan의 delete·replace | 승인 없이 apply 금지 |
| 확인되지 않은 식별자·설정 | 추정값으로 import·apply 금지 |
| 시크릿 | 코드·변수 파일·plan·로그에 두지 않음. 조회하지 않음 |
| 서비스 중단이 있는 작업 | 다운타임 승인과 일정 확정은 PM |

## 경보와 대응 요약

- 경보는 팀 메신저와 그룹 메일로 수신
- 수신 그룹 소유자 2명 이상: `org/access.md`
- 대응 절차: `process/incident.md`. 명령·위치는 비공개 운영 문서 참조

## 공개 저장소 보안 규칙 요약

| 구분 | 규칙 |
|---|---|
| 절대 금지 | 공인 IP, 허용 IP, 시크릿 값, 키, 개인 계정명 |
| 비공개 기록에만 | 계정 ID, ARN, 자원 ID |
| 허용 | 자원 이름, 사설 대역, 리전 |
| 자동 검사 | push protection, secret scanning, CI 검사, 커밋 전 훅 |

- 검사 우회(`--no-verify`, bypass) 금지
- 실수로 올렸으면 즉시 PM과 인프라 담당에게 알림. git 이력 정리 필요
- 전체 규칙: `conventions/doc-writing.md`, 저장소 `README.md`

## 관련 문서

| 문서 | 경로 |
|---|---|
| 장애 대응 | `process/incident.md` |
| 릴리스·시즌 충돌 | `process/release.md` |
| 접근 권한 | `org/access.md` |
| 인수인계 | `org/handover.md` |

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| import 진행 단계(2026-11-25 기준) | Product Engineer(조사) | 문서 검토 시 |
| 비공개 기록 보관 위치 | PM | 인프라 문서 확정 전 |
