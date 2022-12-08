dl() {
  [[ -z $1 ]] && echo "Usage:\n$ dl https://xxx.xxx/xxx [filename]" >&2 && return 2

  filename=${2:-./$(basename $1)}
  curl -fSL $1 -o $filename && echo "\n→ $filename" || echo "\n Fatal: Download Failed" >&2
}

# * ----------------------------------------------------------------

# https://bookfere.com/post/1020.html
function fixgoogle() {
  sudo bash -c "$(curl -skL https://gist.githubusercontent.com/bookfere/f92d58fcbe22897aacfb1225b362a140/raw/88670cfad05d14e8fe59c1b7fe5878bcc577d7c2/fix-google-translate-cn.sh)"
}
