# export WSL_WINDOWS_HOST=$(cat /etc/resolv.conf | grep nameserver | cut -d ' ' -f 2)
# export ALL_PROXY="http://$WSL_WINDOWS_HOST:7890"

# https://everything.curl.dev/usingcurl/proxies/env

: "
proxy: terminal 普通 http 请求
.ssh/config: ssh 请求
"

# * ----------------------------------------------------------------

: "
$ proxy

$ proxy on

$ proxy off

$ proxy dead

$ proxy -p 7891

"

proxy() {
  local localproxy='http://127.0.0.1:7890'
  local deadproxy="http://a.deadlink/"

  # * ---------------- action

  _proxy_set() {
    export ALL_PROXY=$1
    export http_proxy=$1
    export https_proxy=$1
    export HTTP_PROXY=$1
    export HTTPS_PROXY=$1
  }

  _proxy_unset() {
    unset ALL_PROXY
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
  }

  # * ---------------- switch

  case "$1" in
    boot | on) _proxy_set $localproxy ;;
    off) _proxy_unset ;;
    -p) _proxy_set "${localproxy//7890/$2}" ;;
    dead) _proxy_set $deadproxy ;;
  esac

  # * ---------------- echo

  if [[ $1 == 'boot' ]]; then # boot log, dont show proxy url
    echo 'Proxy on'
  elif [[ -n $ALL_PROXY ]]; then # 如果非空
    echo "Proxy: $ALL_PROXY"
  else # 如果为空
    echo "Proxy off"
  fi
}

# * ----------------------------------------------------------------

alias cg="curl -I https://google.com; curl https://google.com"
