# * ---------------- get current dir

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
# https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
# ? unsafe
export ZSH_LC=$(cd -- "$(dirname -- "$0")" &>/dev/null && pwd)

# * ---------------- add bin to path

# export PATH="$ZSH_LC/bin:$PATH"

# * ---------------- source all files

# fd -gp "$ZSH_LC/scripts/**/*.zsh"
for file in $(find $ZSH_LC/scripts/**/*.zsh); do
  source $file
done

for file in $ZSH_LC/unsync/*; do
  source $file
done

# * ----------------

alias reload='omz reload'
