# https://everything.curl.dev/usingcurl/proxies/env

# * ----------------------------------------------------------------

_proxy_set() {
  export ALL_PROXY=$1
  export http_proxy=$1
  export https_proxy=$1
  export HTTP_PROXY=$1
  export HTTPS_PROXY=$1
}

# * ----------------------------------------------------------------

_proxy_unset() {
  unset ALL_PROXY
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
}

# * ----------------------------------------------------------------

: "
$ proxy

$ proxy on

$ proxy off

$ proxy dead

"

proxy() {
  local localproxy='http://127.0.0.1:7890'
  local deadproxy="http://a.deadlink/"

  # * ---------------- switch

  case "$1" in
  boot | on) _proxy_set $localproxy ;;
  dead) _proxy_set $deadproxy ;;
  off) _proxy_unset ;;
  esac

  # * ---------------- echo

  if [[ $1 == 'boot' ]]; then
    echo 'Proxy on'
  elif [[ -n $ALL_PROXY ]]; then
    echo "Proxy: $ALL_PROXY"
  else
    echo "Proxy off"
  fi
}

# * ----------------------------------------------------------------

alias cg="curl google.com"
