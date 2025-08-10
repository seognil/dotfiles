# * ---------------------------------------------------------------- short commands

# git ignore
# gi node >> .gitignore
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@; }

# git user commits statistics
alias gua='git shortlog -sne --all'

alias grhh="git clean -fd && git reset --hard"

alias ta='tig --all'

alias li="license-generator install MIT -n 'Seognil LC'"

# * ---------------------------------------------------------------- config switcher

# https://stackoverflow.com/questions/8801729/is-it-possible-to-have-different-git-configuration-for-different-projects

# * ---------------------------------------------------------------- ginit

# 在当前目录快速初始化 git
ginit() {
  # 如果已有 commit 则退出
  git rev-parse --verify HEAD >/dev/null 2>&1 && {
    echo "git already initialized"
    return 1
  }

  # 如果非 git 仓库，则 init
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || git init

  # 检查是否已存在 .gitignore 文件
  local TMP_FILE=""
  [[ -f .gitignore ]] && {
    TMP_FILE=$(mktemp)
    mv .gitignore "$TMP_FILE"
  }

  # 创建初始 commit，包含空的 .gitignore
  touch .gitignore
  git add .gitignore
  git commit -m "feat(init): initial commit"
  git tag init

  # 恢复原始的 .gitignore 文件
  [[ -n $TMP_FILE ]] && mv "$TMP_FILE" .gitignore
}

# * ---------------------------------------------------------------- git weekly

function gw() (
  # check if not git repository
  ! $(git rev-parse --is-inside-work-tree) && return

  # * ----------------

  local author=${1:-$(git config user.name)}
  local firstCommitTime=$(git log --stat --author="$author" --reverse | rg -oP "(?<=Date:).*" | sd '\+[0-9]+' '' | head -n 1)
  local lastCommitTime=$(git log --stat --author="$author" -n 1 | rg -oP "(?<=Date:).*" | sd '\+[0-9]+' '')

  printf "%-12s : %s\n" "User" $author
  printf "%-12s : %s\n" "First Commit" "$(gdate -d "$firstCommitTime" +'%Y-%m-%d %H:%M:%S')"
  printf "%-12s : %s\n" "Last Commit" "$(gdate -d "$lastCommitTime" +'%Y-%m-%d %H:%M:%S')"

  # * ----------------

  gitTimeup() {
    local Label=$1
    local since=$2

    local gitArgs=(log --stat --author="$author" --no-merges)
    [[ -n $since ]] && gitArgs=($gitArgs --since="$since")
    local gitChanges=$(git $gitArgs | rg '\d+ files? changed')

    local commmits=$(echo $gitChanges | wc -l | sd ' *' '')
    local ins=$(echo $gitChanges | rg -oP '\d+(?= ins)' | awk '{val += $1} END {print val}')
    local del=$(echo $gitChanges | rg -oP '\d+(?= del)' | awk '{val += $1} END {print val}')

    printf "%-12s : %4s commits, %6s (+), %6s (-)\n" $Label $commmits ${ins-0} ${del-0}
  }

  gitTimeup All
  gitTimeup "Last Year" "1 year ago"
  gitTimeup "Last Month" "1 month ago"
  gitTimeup "Last Week" "1 week ago"

)

alias gitweekly="gw"

# * ---------------------------------------------------------------- tools

# commits time graph
function gt() {
  local author=${1:-$(git config user.name)}

  git log --author="$author" --date=iso | perl -nalE 'if (/^Date:\s+[\d-]{10}\s(\d{2})/) { say $1+0 }' | sort | uniq -c | perl -MList::Util=max -nalE '$h{$F[1]} = $F[0]; }{ $m = max values %h; foreach (0..23) { $h{$_} = 0 if not exists $h{$_} } foreach (sort {$a <=> $b } keys %h) { say sprintf "%02d - %4d %s", $_, $h{$_}, "*"x ($h{$_} / $m * 50); }'

  echo $author
}
