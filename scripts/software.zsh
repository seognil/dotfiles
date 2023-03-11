# * ------------------------------------------------ brew

# https://stackoverflow.com/questions/41029842/easy-way-to-have-homebrew-list-all-package-dependencies
alias bb='brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'

alias bout='brew update; brew outdated'
alias bup='brew upgrade'

alias bs='brew search'
alias bi='brew install'
alias bri='brew reinstall'
alias bui='brew uninstall'
alias bf='brew info'

alias du="du -h"
alias fd="fd -HI"
alias l="exa -lah"
alias scc="scc --no-cocomo --no-size"

alias grhh="git clean -fd && git reset --hard"

helpme() {
  if [[ -z $1 ]]; then
    local helpnote='
ripgrep: grep, faster
sd: sed, faster
fd: find, colorful handful but slower
fzf:
exa: ls, colorful
tre: tree, colorful
dua: du, smart
bpytop/btop: htop, colorful
gping: ping, chart
'
    echo $helpnote
  elif [[ $1 == 'clean' ]]; then
    local helpnote='
brew cleanup
yarn cache clean
npm cache clean --force
pnpm store prune
  '
    echo $helpnote
  fi
}
alias \?='helpme'

alias hs='history | rg -P --color=always'

alias ta='tig --all'
alias rm='trash'

alias daisy="open -a DaisyDisk"
alias iterm="open -a iterm"

alias DDD='date -u +"// TODO // Seognil LC %Y/%m/%d"'
alias ydl='yt-dlp --proxy 127.0.0.1:7890 -o "%(title)s.%(resolution)s@%(fps)s.%(dynamic_range)s.%(ext)s"'

# * ------------------------------------------------ ver

function ver() (
  semver() {
    echo $($@) | rg -o '(\d+\.)*\d+'
  }

  echo "node   : $(semver node -v) $(node -p 'process.arch')"
  echo "npm    : $(semver npm -v)"
  echo "pnpm   : $(semver pnpm -v)"
  echo "ts     : $(semver tsc -v)"
  echo "python : $(semver python3 --version)"
  echo "java   : $(semver javac -version)"
)

# * ------------------------------------------------ mas

# https://osxdaily.com/2013/09/28/list-mac-app-store-apps-terminal/
# https://github.com/mas-cli/mas

masList() {
  find /Applications \
    -path '*Contents/_MASReceipt/receipt' \
    -maxdepth 4 -print |
    sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
}

# * ----------------------------------------------------------------

# TODO review // Seognil LC 2022/11/19

findAndTrash() {
  if [[ -n $1 ]]; then
    target=$1
    echo ""
    find . -name $target
    echo ""
    read REPLY\?"Press Enter to remove these."
    find . -name $target -prune -exec trash {} +
  fi
}
