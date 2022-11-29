# * ---------------------------------------------------------------- getpath

: "
Cases

'' => ''
unexist => ''
./lnfile => '/xxx/xxx'
g => /opt/homebrew/Cellar/git/2.38.1/bin/git # alias g=git
ls => /bin/ls # alias ls='ls -G'
hsi => '' # alias hsi='history | grep -i' history=omz_history
"

_getpath_single() {

  # unwrap alias recursively
  local normalized_path=$1
  while [[ -n $(alias $normalized_path) ]]; do
    normalized_path=$(alias $normalized_path | ggrep -oP "((?<==)|(?<==[\"']))\w+?\b")

    # check in each loop (in case of alias "l='ls -lah'" "ls='ls -G'")
    local bin_path=$(type -p $normalized_path | ggrep -oP "(?<=is\s)/.*")
    [[ -n $bin_path ]] && echo $(realpath $bin_path) && return 0
  done

  # file exist in pwd
  [[ -e $normalized_path ]] && echo $(realpath $normalized_path) && return 0

  # try parse as an executable file
  local bin_path=$(type -p $normalized_path | ggrep -oP "(?<=is\s)/.*")
  [[ -n $bin_path ]] && echo $(realpath $bin_path) && return 0

  echo "getpath: $1: Not a file, see 'type $1'" >&2 && return 2
}

getpath() {

  # * ---------------- help

  while getopts ":h" opt; do
    [[ $opt == 'h' ]] && echo "
Enhanced realpath by unwrapping alias and symlink

$ getpath g
  /opt/homebrew/Cellar/git/2.38.1/bin/git

$ getpath ls
  /bin/ls
" && return
  done

  # * ---------------- empty argument

  [[ -z $1 ]] && echo "getpath: : Empty input, try 'getpath ls'" >&2 && return 2

  # * ---------------- at least one argument

  local exit_flag=0

  for opt in $@; do
    _getpath_single $opt || exit_flag=2
  done

  return $exit_flag

}

# * ---------------------------------------------------------------- duc

_duc_single() {
  local the_path=$(getpath $1)
  [[ -n $the_path ]] && du -h $the_path || return 2
}

duc() {
  # * ---------------- help

  while getopts ":h" opt; do
    [[ $opt == 'h' ]] && echo "
Disk usage of the realpath of an executable file

$ duc ls
  40K    /bin/ls

$ duc git
  3.2M    /opt/homebrew/Cellar/git/2.38.1/bin/git
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
