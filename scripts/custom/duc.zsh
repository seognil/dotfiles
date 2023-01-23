# * ---------------------------------------------------------------- duc

duc() {
  # * ---------------- help

  while getopts ":h" opt; do
    [[ $opt == 'h' ]] && echo "
Disk usage for the realpath of an executable file
(Or simply act like the original 'du -f' if already passed a real path)
(Supports multiple arguments as well)

$ duc ls
  40K    /bin/ls

$ duc ls git
  40K    /bin/ls
  3.2M    /opt/homebrew/Cellar/git/2.38.1/bin/git

$ duc ~/.zshrc
  4.0K    /Users/lc/.zshrc

$ duc ~/.oh-my-zsh/
  14M    /Users/lc/.oh-my-zsh
" && return
  done

  # * ---------------- empty argument

  [[ -z $1 ]] && echo "duc: : Empty input, try 'duc git'" >&2 && return 2

  # * ---------------- at least one argument

  local exit_flag=0

  for opt in $@; do
    _duc_single $opt || exit_flag=2
  done

  return $exit_flag

}

# * --------------------------------

_duc_single() {
  local the_path=$(getpath $1)
  [[ -n $the_path ]] && du -h $the_path || return 2
}
