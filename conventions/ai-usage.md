> 담당 역할: PM | Product Engineer
> 최종 검토일: 2026-11-29
> 적용 범위: BOAZ-website 조직의 모든 저장소
> 상태: 확정

# AI 도구 사용 규칙

코드, 문서, 이슈, PR 작성에 AI 도구를 쓸 때 모든 저장소에 같이 적용하는 규칙. PM 결정(2026-11-29, `decisions/0006-repo-rule-keeper-v2-and-repo-standards.md`)

## 규칙

| 항목 | 규칙 |
|---|---|
| 책임 | AI가 만든 변경도 책임은 PR 작성자에게 있음. 리뷰어는 AI가 만들었는지와 관계없이 같은 기준으로 리뷰함 |
| PR 본문 "확인" | 직접 실행하거나 확인한 내용만 적음. 실행하지 않은 검증을 했다고 적지 않음 |
| 외부 AI 도구에 넣지 않는 것 | 시크릿, 개인정보(지원자 정보 등), 비공개 명세(backend-docs) |
| AI 생성 표기 | 커밋 메시지, PR·이슈 본문, 코드 주석에 AI 공동 작성자나 생성 도구 표기(`Co-Authored-By: <AI>`, `Generated with ...`, 🤖 등)를 넣지 않음. 도구가 자동으로 붙이면 지우고 올림 |
| 이슈 생성 | AI로 이슈를 만들 때는 `tools/new-issue.sh`를 씀(필수 6값을 한 번에 지정, `conventions/issue-pr.md` "이슈") |
| 저장소 AI 지침 파일 | `AGENTS.md`, `CLAUDE.md`에 playbook 포인터를 둠(견본은 `conventions/repos.md` "저장소 쪽 안내 문구 견본") |

- 이유: AI가 쓴 코드와 설명은 그럴듯해도 틀릴 수 있어 작성자가 직접 확인해야 함. 확인하지 않은 내용을 확인했다고 적으면 리뷰어가 검증 범위를 잘못 판단함
- 이유: 외부 AI 도구에 넣은 값은 회수하기 어려움. 저장소가 공개이거나 개인정보가 걸린 자료는 처음부터 넣지 않음
- 시크릿 규칙은 `conventions/doc-writing.md` "공개 저장소에 적지 않는 것"과 `conventions/repos.md` "룰셋 표준"의 "보안 설정"을 따름
- AI에게 문서 작성을 맡길 때도 `conventions/doc-writing.md`를 따르게 함

## 미결

| 질문 | 결정 필요 주체 | 필요 시점 |
|---|---|---|
| 없음 | | |
