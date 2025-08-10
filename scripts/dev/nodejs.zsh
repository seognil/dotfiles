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

: "
TODO rust target/{debug,release}
"

# * delete node_modules recursively
function unpm() {
  file_paths=$(fd -g '{node_modules}' --prune)

  # * ---------------- empty retrun

  [[ -z "${file_paths}" ]] && echo 'node_modules not found' && return 0

  # * ---------------- log disk usage

  local -a file_path_arr=()
  echo $file_paths | while read -r line; do file_path_arr+=$line; done
  dua "${file_path_arr[@]}"

  # * ---------------- confirm

  echo "Delete these files? [Y/n]"
  read choice
  if [[ $choice == "n" ]]; then
    echo "Cancel"
    return 2
  fi

  # * ---------------- delete

  trash "${file_path_arr[@]}"
}

# * ----------------------------------------------------------------

: '
TODO 0Works legacy files clean

*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.pnpm-debug.log*

'

# * delete yarn related files: yarn.lock, yarn-error.log
function uyarn() {
  file_paths=$(fd -g '{yarn.lock,yarn-error.log}' --exclude 'node_modules' --prune --color=always | sort)

  # * empty retrun
  [[ -z "${file_paths}" ]] && echo 'yarn files not found' && return 0

  # * echo result
  echo $file_paths

  # * ---------------- confirm

  echo "Delete these files? [Y/n]"
  read choice
  if [[ $choice == "n" ]]; then
    echo "Cancel"
    return 2
  fi

  # * ---------------- delete

  fd -g '{yarn.lock,yarn-error.log}' --exclude 'node_modules' --prune --exec trash
}
