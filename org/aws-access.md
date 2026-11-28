> 담당 역할: PM(승인), Product Engineer(AWS 관리자 권한 보유자가 수행)
> 최종 검토일: 2026-11-29
> 적용 범위: 인프라 Product(AWS 계정)
> 상태: 확정

# AWS 계정 발급·변경·회수

요청·PM 승인·관리자 회수 순서·보유 인원 규칙은 `org/access.md`에 있음. 이 문서는 AWS(IAM) 계정에만 해당하는 세부 절차를 다룸. IAM 사용자 이름, 계정 ID, 키, 비밀번호는 적지 않음. 개별 정보는 팀 Notion "AWS 접근 목록"에서 관리

## 결정 사항

| 항목 | 규칙 |
|---|---|
| 권한 부여 단위 | 그룹만 사용. 사용자에게 정책을 직접 붙이지 않음 |
| 그룹 | 두 개만 사용(아래 표) |
| 그룹 중복 | Admin 사용자를 `terraform-readonly`에 함께 넣지 않음. plan용 정책의 거부가 관리자 권한까지 막음 |
| 사용자 이름 | 기존 형식 `<접두어>_<이름 로마자>`를 따름. 대응표는 팀 Notion. 읽기 전용 그룹에도 접두어가 `admin`인 계정이 있으나 역사적 이유이며 권한과 무관 |
| MFA | 강제하지 않음. 등록을 권장함(product-infra `decisions.md` "팀원 AWS 접근 방식", 2026-10-02 결정, 2026-11-28 PM 재확인) |
| 액세스 키 | 새로 발급하지 않음(예외는 아래). 이미 있는 키는 막지 않음 |
| 로컬 CLI | `aws login`(브라우저 로그인 임시 세션). 두 그룹 모두 사용 가능 |
| 기계용 자격 증명 | 사람 계정과 IAM 사용자 키를 쓰지 않음. 배포는 GitHub Actions OIDC 롤, 서버는 EC2 역할 |
| 시크릿 저장 | SSM Parameter Store에는 반드시 SecureString으로 저장. 읽기 전용은 평문 String 파라미터를 읽을 수 있고 SecureString은 KMS 복호화 거부로 읽지 못함 |
| tfstate | 읽기 전용도 plan 때문에 읽을 수 있음. 민감값을 state에 남기지 않음 |

### 그룹

| 그룹 | 권한 | 대상 | 관리 방식 |
|---|---|---|---|
| `Admin` | AdministratorAccess(로컬 로그인 권한 포함) | AWS 관리자 권한 보유자(보유 인원 규칙은 `org/access.md`). Terraform `apply` 실행 | 코드 밖(콘솔). 2026-12 시즌 뒤 bootstrap으로 import 예정 |
| `terraform-readonly` | ReadOnlyAccess + plan용 정책 + 비밀번호 변경 + 로컬 로그인 권한(`SignInLocalDevelopmentAccess`, 현재 콘솔로 부착, 코드 반영 예정) | 전원 | product-infra `bootstrap/team_readonly_group.tf`(로컬 로그인 권한 제외) |

- `terraform-readonly`는 파일 내용 열람(`s3:GetObject*`), 시크릿·KMS 복호화, 로그 내용 조회를 거부함
- `Admin`과 사용자·멤버십은 공개 저장소에 사용자 이름을 쓸 수 없어 코드 밖에서 관리함
- 로컬 로그인 권한과 `Admin` import 반영은 product-infra#136에서 추적 중

### 액세스 키 예외

| 항목 | 규칙 |
|---|---|
| 대상 | `terraform-readonly` 사용자만. `Admin` 사용자에게는 발급하지 않음 |
| 신청 | 요청에 사유와 기한(절대 날짜)을 적음 |
| 승인 | PM |
| 수량 | 사용자당 1개 |
| 기한 후 | 기한 다음 날 비활성화 후 삭제. 정기 점검에서 확인 |

### 기계용 자격 증명

| 용도 | 방식 | 비고 |
|---|---|---|
| 배포(GitHub Actions) | OIDC 롤(product-infra `modules/iam`) | 저장소의 production environment만 신뢰. 롤별 신뢰 저장소는 코드 기준(관리자 배포 롤은 현재 2개 저장소 신뢰) |
| PR plan(GitHub Actions) | 읽기 전용 OIDC 롤(product-infra `bootstrap/ci_plan_role.tf`) | pull_request만 신뢰 |
| 서버 | EC2 역할 | 장기 키 없음 |

- 신뢰 조건은 저장소만 제한하고 S3 버킷 경로는 제한하지 않음. 경로 범위는 배포 워크플로가 지킴

## 발급 절차

AWS 관리자 권한 보유자가 수행함

| 순서 | 작업 | 담당 | 확인 |
|---|---|---|---|
| 1 | 요청 확인(`org/access.md` 절차). 그룹과 만료일(절대 날짜, 없으면 기수 종료일) 확정 | AWS 관리자 권한 보유자 | 요청 이슈에 그룹과 만료일 기재 |
| 2 | IAM 사용자 생성 | AWS 관리자 권한 보유자 | 사용자가 목록에 보임 |
| 3 | 그룹에 추가(기본 `terraform-readonly`) | AWS 관리자 권한 보유자 | 그룹 1개만 소속, 직접 정책 없음 |
| 4 | 콘솔 로그인 생성. 첫 로그인 때 비밀번호 변경 강제 | AWS 관리자 권한 보유자 | 비밀번호 재설정 필수 설정 확인 |
| 5 | 초기 비밀번호와 로그인 주소(계정 별칭 URL, 팀 Notion에 있음)를 본인에게 1:1 또는 팀 비밀번호 관리자로 전달. 공개 채널과 GitHub 금지. MFA 등록 안내(권장) | AWS 관리자 권한 보유자 | 본인이 수신 확인 |
| 6 | 로그인해 비밀번호 변경, `aws login` 설정 | 요청자 | `aws login` 후 `aws sts get-caller-identity` 성공 또는 콘솔에서 S3 버킷 목록 조회 |
| 7 | 팀 Notion "AWS 접근 목록" 갱신(사용자 이름, 그룹, 부여일, 만료일) | AWS 관리자 권한 보유자 | 목록과 IAM 일치 |

- 초기 비밀번호는 발급 후 7일 안에 로그인하지 않으면 콘솔 로그인을 삭제하고 재발급함(초기 기준)

## 변경 절차

| 변경 | 규칙 |
|---|---|
| 읽기 전용 → 관리자 | PM 승인. 새 그룹 추가 → 접근 확인 → 이전 그룹 제거 순서 |
| 관리자 → 읽기 전용 | 업무 종료 시 PM 확인. 같은 순서로 이동. 이동 뒤 보유 인원 규칙 충족 확인(`org/access.md`) |
| 임시 관리자 | 요청에 종료일(절대 날짜) 명시. 종료일 다음 날까지 읽기 전용으로 되돌림. 정기 점검에서 만료일 지난 `Admin` 확인 |
| 변경 후 공통 | 팀 Notion "AWS 접근 목록"의 그룹·만료일 갱신 |

## 회수 절차

`org/access.md` "기수 교체 시 회수" 5단계(퇴임자 권한 회수)의 AWS 세부. 퇴임·업무 종료 때 같은 순서를 적용함

| 순서 | 작업 | 확인 |
|---|---|---|
| 0 | 본인에게 보유 자료 목록(배포 백업 등)을 받아 팀 공유 위치로 이전. 회수 전에 수행 | 목록의 자료가 모두 이전됨 |
| 1 | 액세스 키 비활성화(키가 없으면 생략) | 키 상태가 비활성 |
| 2 | 그룹에서 제거. 이미 발급된 세션이 남을 수 있으므로 필요하면 콘솔에서 "활성 세션 취소(Revoke active sessions)" 실행 | 소속 그룹 0개 |
| 3 | 콘솔 로그인 삭제. 직후 팀 Notion에 회수일과 삭제 예정일(회수일+30일) 기록 | 콘솔 로그인 없음 |
| 4 | 30일 뒤(초기 기준) 키와 사용자 삭제. 접근 거부·복구 요청이 없으면 AWS 관리자 권한 보유자가 수행. 삭제는 되돌릴 수 없어 유예함 | 사용자가 목록에서 사라짐 |
| 5 | 팀 Notion "AWS 접근 목록"에 삭제 완료 기록 | 목록과 IAM 일치 |

## 정기 점검

| 항목 | 내용 |
|---|---|
| 방법 | IAM 콘솔 > 자격 증명 보고서 다운로드 |
| 볼 열 | `password_last_used`, `access_key_*_active`, `access_key_*_last_used_date`, `mfa_active` |
| 시점 | 분기 1회와 기수 교체 때 |
| 수행 | AWS 관리자 권한 보유자 1명 |
| 기록 | 이슈에 건수만 기록. 사용자 이름은 적지 않음 |

| 점검 기준 | 조치 |
|---|---|
| 90일 넘게 쓰지 않은 키·로그인(초기 기준) | 비활성화 후보로 PM에게 보고 |
| 만료일 지난 계정·임시 `Admin` | 회수 또는 읽기 전용으로 되돌림 |
| 회수 후 30일 지난 미삭제 사용자(초기 기준) | 삭제 예정일 확인 후 삭제 |
| 삭제 예정일 지난 사용자 | 회수 절차 4단계 수행 |
| 기한 지난 액세스 키 | 비활성화 후 삭제 |
| MFA 미등록 `Admin` 수 | 건수만 기록(강제 아님) |
| 사용자 직접 정책 | 그룹으로 정리 |
| 팀 Notion 목록과 IAM 불일치 | 목록 또는 IAM을 바로잡음 |

## 새 배포 저장소 추가

| 순서 | 작업 | 확인 |
|---|---|---|
| 1 | product-infra `modules/iam`에 신뢰 조건을 추가하는 PR 작성 | PR plan 통과 |
| 2 | plan 검토 | 해당 롤 신뢰 정책 in-place update만 있고 생성·교체·삭제 0 |
| 3 | AWS 관리자 권한 보유자가 `scripts/apply-group.sh iam <이슈 번호>` 실행(product-infra `docs/guides/import-procedure.md` 2절) | 실행 성공 |
| 4 | 다시 plan | No changes |

- 2026-07-15 이후 생성한 저장소는 immutable subject 형식을 씀: `repo:<조직>@<조직 ID>/<저장소>@<저장소 ID>:environment:production`. 확인 방법은 product-infra `bootstrap/ci_plan_role.tf` 주석
- 배포 금지 기간에 걸리면 PM 승인(아래 "변경 이력 기록")

## root 계정

| 규칙 | 내용 |
|---|---|
| 일상 사용 | 금지 |
| 액세스 키 | 만들지 않음 |
| MFA | 유지 |
| 사용 조건 | 관리자 전원이 접근할 수 없는 비상시에만 PM 승인으로 사용. 사용 뒤 이슈에 기록 |

## 변경 이력 기록

- CloudTrail이 없어 콘솔 변경 이력이 남지 않음. IAM 변경은 당일 product-infra `decisions.md` 또는 해당 이슈에 기록함
- 운영 IAM 변경이 배포 금지 기간(`process/release.md` "모집 시즌 전환과 겹칠 때"의 "배포 금지 기간")에 걸리면 PM 승인을 받음

## 관련 문서

- product-infra `docs/guides/import-procedure.md`의 `aws configure`(액세스 키) 안내와 `decisions.md` "팀원 AWS 접근 방식"(키로 CLI)은 이 문서와 다름. 이 문서가 기준이며 두 문서의 갱신은 product-infra#136에서 진행함

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 관리자 그룹 MFA 필수 여부 | PM | 2026-12 시즌 뒤 |
| root 계정 자격 증명 보관 방식(2명 분리 보관 등) | PM, Product Engineer | 2026-12 시즌 뒤 |
| 사용자 이름 규칙(실명 대체 여부) | PM | 29기 시작 전 |

- 임시 권한의 최대 기간: `org/access.md` 미결 참조
