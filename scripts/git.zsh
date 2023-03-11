# * ---------------------------------------------------------------- short commands

# git ignore
# gi node >> .gitignore
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@; }

# git user commits statistics
alias gua='git shortlog -sne --all'

alias li="license-generator install MIT -n 'Seognil LC'"

# * ---------------------------------------------------------------- config switcher

# https://stackoverflow.com/questions/8801729/is-it-possible-to-have-different-git-configuration-for-different-projects

# * ---------------------------------------------------------------- ginit

# init a git repository with basic startup actions
ginit() (

  # quit if has at least one commit
  if [[ -n $(git rev-parse --all 2>/dev/null) ]]; then
    echo "Git repository already initialized"
    exit 1
  fi

  # * ----------------

  git_init_action() {
    # maybe already git inited but maybe no commits, so don't quit
    [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] || git init

    touch .gitignore
    git add .gitignore
    git commit -m "feat(init): initial commit"
    git tag init
  }

  # * ----------------

  # ensure an empty '.gitignore' file for the initial commit
  if [[ -f .gitignore ]]; then
    TMP_FILE=$(mktemp)
    mv .gitignore $TMP_FILE

    git_init_action

    mv $TMP_FILE .gitignore
  else
    git_init_action
  fi
)

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
