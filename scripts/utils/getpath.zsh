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

# * --------------------------------


getpath() {

  # * ---------------- help

  while getopts ":h" opt; do
    [[ $opt == 'h' ]] && echo "
Enhanced realpath by unwrapping alias and symlink

$ getpath ls
  /bin/ls

$ getpath ls g
  /bin/ls
  /opt/homebrew/Cellar/git/2.38.1/bin/git

$ getpath ~/.zshrc
  /Users/lc/.zshrc
" && return
  done

  # * ---------------- empty argument will get current dir

  if [[ -z $1 ]]; then
    _getpath_single .
    return 0
  fi

  # * ---------------- at least one argument

  local exit_flag=0

  for opt in $@; do
    _getpath_single $opt || exit_flag=2
  done

  return $exit_flag

}

# * --------------------------------

_getpath_single() {

  # unwrap alias recursively
  local normalized_path=$1
  while [[ -n $(alias $normalized_path) ]]; do
    normalized_path=$(alias $normalized_path | rg -oP "((?<==)|(?<==[\"']))\w+?\b")

    # check in each loop (in case of alias "l='ls -lah'" "ls='ls -G'")
    local bin_path=$(type -p $normalized_path | rg -oP "(?<=is\s)/.*")
    [[ -n $bin_path ]] && echo $(realpath $bin_path) && return 0
  done

  # file exist in pwd
  [[ -e $normalized_path ]] && echo $(realpath $normalized_path) && return 0

  # try parse as an executable file
  local bin_path=$(type -p $normalized_path | rg -oP "(?<=is\s)/.*")
  [[ -n $bin_path ]] && echo $(realpath $bin_path) && return 0

  echo "getpath: $1: Not a file, see 'type $1'" >&2 && return 2
}
