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

  # * ---------------- transform search result into array

  # https://stackoverflow.com/questions/5051556/in-a-linux-shell-how-can-i-process-each-line-of-a-multiline-string

  declare -a file_path_arr

  file_paths=$(getpath "$@" 2>/dev/null)
  echo $file_paths | while read -r line; do file_path_arr+=$line; done

  # * ---------------- dua

  dua "${file_path_arr[@]}"
}
