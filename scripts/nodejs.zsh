# * ----------------------------------------------------------------

alias pout='pnpm -g outdated'
alias pup='pnpm -g upgrade --registry https://registry.npmmirror.com/'

alias gpnpm='pnpm -g ls'
alias gnpm="npm -g list --depth 0; echo '/usr/local/lib/node_modules'"
alias gyarn="yarn global list; echo '~/.config/yarn/global/node_modules'"

alias tt='type-done -t pnpm'

alias re='release-it'
alias sv='standard-version'

# * ----------------------------------------------------------------

# TODO review // Seognil LC 2022/11/19

function fnpm() {
  find -E $(pwd) -type d -regex "^.*/(node_modules|\.cache|\.yarn)$" -prune -exec du -chs {} +
}

function unpm() {
  fnpm
  find -E $(pwd) -type d -regex "^.*/(node_modules|\.cache|\.yarn)$" -prune -exec trash {} +
}

function fylock() {
  find -E $(pwd) -type f -name "yarn.lock" -not -path '*/node_modules/*'
}

function uylock() {
  fylock
  find -E $(pwd) -type f -name "yarn.lock" -not -path '*/node_modules/*' -prune -exec trash {} +
}
