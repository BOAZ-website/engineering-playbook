#!/usr/bin/env bash
# 개발 작업 GitHub 이슈 생성(conventions/issue-pr.md "이슈")
# 필수 값 6개(Assignee, 작업 종류 라벨, Type, Priority, 보드 편입, Project)를 한 번에 지정함
# 값이 하나라도 빠지거나 틀리면 이슈를 만들지 않고 멈춤
#
# 사용:
#   tools/new-issue.sh -R backend -t "[Feat] 출결 조회 API" -T Feature -P High \
#     -j "관리자 페이지 개발" -b body.md [-a 로그인]
#   -R 저장소 이름(BOAZ-website 조직 안)   -t 제목([Type] 내용)
#   -T Feature|Bug|Task                    -P Urgent|High|Medium|Low(Notion 긴급·높음·중간·낮음)
#   -j 보드 Project 값                      -b 본문 파일(이슈 템플릿 형식)
#   -a 담당자(기본: 실행한 사람)
#   -p 상위 이슈(같은 저장소는 번호, 다른 저장소는 저장소#번호). 작업이 PR 여러 개로 나뉘면 하위 이슈로 만듦(PR 하나 = 이슈 하나)
# 필요: gh(project 권한: gh auth refresh -s project), jq
set -euo pipefail

ORG=BOAZ-website
BOARD_NUMBER=1
ASSIGNEE=@me
REPO= TITLE= TYPE= PRIORITY= PROJECT= BODY= PARENT=

while getopts "R:t:T:P:j:b:a:p:" o; do
  case $o in
    R) REPO=$OPTARG ;; t) TITLE=$OPTARG ;; T) TYPE=$OPTARG ;; P) PRIORITY=$OPTARG ;;
    j) PROJECT=$OPTARG ;; b) BODY=$OPTARG ;; a) ASSIGNEE=$OPTARG ;; p) PARENT=$OPTARG ;;
    *) echo "알 수 없는 옵션" >&2; exit 2 ;;
  esac
done

die() { echo "중단: $*" >&2; exit 1; }
for v in REPO TITLE TYPE PRIORITY PROJECT BODY; do [ -n "${!v}" ] || die "$v 값이 없음"; done
[ -f "$BODY" ] || die "본문 파일 없음: $BODY"

case $TYPE in Feature|Bug|Task) ;; *) die "Type은 Feature, Bug, Task 중 하나" ;; esac

# 제목 접두어 → 작업 종류 라벨(conventions/issue-pr.md "라벨")
prefix=$(printf '%s' "$TITLE" | sed -nE 's/^\[([A-Za-z]+)\].*/\1/p' | tr '[:upper:]' '[:lower:]')
case $prefix in
  feat) LABEL='⭐️ FEAT' ;; fix) LABEL='🐛 FIX' ;; hotfix) LABEL='🚑 HOTFIX' ;; docs) LABEL='✏️ DOCS' ;;
  refactor) LABEL='🛠️ REFACTOR' ;; style) LABEL='🧁 STYLE' ;; test) LABEL='🔎 TEST' ;;
  release) LABEL='🚀 RELEASE' ;; chore) LABEL='🧹 CHORE' ;;
  *) die "제목은 [Feat]·[Fix]·[Hotfix]·[Docs]·[Refactor]·[Style]·[Test]·[Release]·[Chore] 중 하나로 시작" ;;
esac

# 보드·필드 ID를 이름으로 찾음. 값이 틀리면 생성 전에 멈춤
meta=$(gh api graphql -f query='query($o:String!,$n:Int!){organization(login:$o){
  projectV2(number:$n){id title field(name:"Project"){... on ProjectV2SingleSelectField{id options{id name}}}}
  issueFields(first:20){nodes{... on IssueFieldSingleSelect{id name options{id name}}}}}}' \
  -f o=$ORG -F n=$BOARD_NUMBER)
board_id=$(jq -r '.data.organization.projectV2.id' <<<"$meta")
board_title=$(jq -r '.data.organization.projectV2.title' <<<"$meta")
proj_field=$(jq -r '.data.organization.projectV2.field.id' <<<"$meta")
proj_opt=$(jq -r --arg v "$PROJECT" '.data.organization.projectV2.field.options[]|select(.name==$v).id' <<<"$meta")
pri_field=$(jq -r '.data.organization.issueFields.nodes[]|select(.name=="Priority").id' <<<"$meta")
pri_opt=$(jq -r --arg v "$PRIORITY" '.data.organization.issueFields.nodes[]|select(.name=="Priority").options[]|select(.name==$v).id' <<<"$meta")
[ -n "$proj_opt" ] || die "Project 값이 보드에 없음: $PROJECT (옵션: $(jq -r '[.data.organization.projectV2.field.options[].name]|join(", ")' <<<"$meta"))"
[ -n "$pri_opt" ] || die "Priority는 Urgent, High, Medium, Low 중 하나"
parent_id=
if [ -n "$PARENT" ]; then
  p_repo=$REPO p_num=$PARENT
  case $PARENT in *#*) p_repo=${PARENT%#*}; p_num=${PARENT#*#} ;; esac
  parent_id=$(gh api "repos/$ORG/$p_repo/issues/$p_num" -q 'select(.pull_request==null)|.node_id // empty' 2>/dev/null) || parent_id=
  [[ $parent_id == I_* ]] || die "상위 이슈 없음: $p_repo#$p_num"
fi

url=$(gh issue create -R "$ORG/$REPO" --title "$TITLE" --body-file "$BODY" \
  --assignee "$ASSIGNEE" --label "$LABEL" --type "$TYPE" --project "$board_title")

# 생성 뒤 필드 지정. 실패하면 이슈 주소와 함께 알림(이슈는 남으므로 손으로 채움)
num=${url##*/}
issue_id=$(gh api "repos/$ORG/$REPO/issues/$num" -q .node_id)
item_id=$(gh api graphql -f query='mutation($p:ID!,$c:ID!){addProjectV2ItemById(input:{projectId:$p,contentId:$c}){item{id}}}' \
  -f p="$board_id" -f c="$issue_id" -q .data.addProjectV2ItemById.item.id) || die "$url 보드 편입 실패"
gh api graphql -f query='mutation($p:ID!,$i:ID!,$f:ID!,$o:String!){updateProjectV2ItemFieldValue(input:{projectId:$p,itemId:$i,fieldId:$f,value:{singleSelectOptionId:$o}}){clientMutationId}}' \
  -f p="$board_id" -f i="$item_id" -f f="$proj_field" -f o="$proj_opt" >/dev/null || die "$url Project 지정 실패"
gh api graphql -f query='mutation($i:ID!,$f:ID!,$o:ID!){setIssueFieldValue(input:{issueId:$i,issueFields:[{fieldId:$f,singleSelectOptionId:$o}]}){clientMutationId}}' \
  -f i="$issue_id" -f f="$pri_field" -f o="$pri_opt" >/dev/null || die "$url Priority 지정 실패"
if [ -n "$parent_id" ]; then
  gh api graphql -f query='mutation($p:ID!,$c:ID!){addSubIssue(input:{issueId:$p,subIssueId:$c}){clientMutationId}}' \
    -f p="$parent_id" -f c="$issue_id" >/dev/null || die "$url 상위 이슈 $PARENT 연결 실패"
fi

echo "$url"
echo "다음: Notion 티켓을 만들고 이 이슈 링크를 \"Github Issue\" 칸에 적음(Project·우선순위는 같은 값)"
