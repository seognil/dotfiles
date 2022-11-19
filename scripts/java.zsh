# * ================================================================================ jabba

# export JABBA_HOME="$HOME/.jabba"
# function jabba() {
#   local TempFile="$HOME/.jabba/JABBA-TEMP-FLIE"
#   (JABBA_SHELL_INTEGRATION=ON $HOME/.jabba/bin/jabba "$@" 3>|$TempFile)
#   eval $(cat $TempFile)
# }
# [ ! -z $(jabba alias default) ] && jabba use default

# * ================================================================================ jv java version switcher

# brew install zulu17

: "
  personal usage

  jv -> (print current java version)
  jv env -> prepare, jv use default (silent)
  jv ls -> ()
  jv use 17 -> set $_JV_CURRENT=17, set $JAVA_HOME and $PATH
  jv use default -> set $_JV_CURRENT=default, set $JAVA_HOME and $PATH
  jv default -> (print current default version)
  jv default 17 -> set $_JV_RC=17, check if re-active

  default: write ~/.jvrc
  $_JV_CURRENT: flag
  $JAVA_HOME: shell usage
"

# * ----------------------------------------------------------------

local _JV_RC="$HOME/.jvrc"

# * ---------------------------------------------------------------- jv use

_jv_use() {

  # * ---------------- check version

  local NEW_VER=$1
  [[ $NEW_VER == "default" ]] && NEW_VER=$(cat $_JV_RC)

  local NEW_BIN="/Library/Java/JavaVirtualMachines/zulu-$NEW_VER.jdk/Contents/Home/bin/"
  (! [[ -d $NEW_BIN ]]) && echo "Not a valid java version" && return 1

  # * ---------------- prepare $JAVA_HOME (at first run)

  if [[ -z $JAVA_HOME ]]; then
    local CACHE_DIR="$HOME/Library/Caches/zulu_multishells/$(gdate +%s%N)_$RANDOM"
    mkdir -p $CACHE_DIR

    export JAVA_HOME="$CACHE_DIR/bin"
    export PATH="$JAVA_HOME:$PATH"
  fi

  # * ---------------- link new version

  # clear previous $JAVA_HOME link
  [[ -L $JAVA_HOME ]] && unlink $JAVA_HOME

  ln -s $NEW_BIN $JAVA_HOME
  export PATH="$PATH"

  # * ---------------- log

  local SILENT=$2
  [[ -z $SILENT ]] && _jv_echo

}

# * ---------------------------------------------------------------- jv default

_jv_default() {
  # * ---------------- if no args, print value

  [[ -z $1 ]] && cat $_JV_RC && return

  # * ---------------- set default

  local NEW_VER=$1

  local NEW_BIN="/Library/Java/JavaVirtualMachines/zulu-$NEW_VER.jdk/Contents/Home/bin/"
  (! [[ -d $NEW_BIN ]]) && echo "Not a valid version" && return 1

  echo $NEW_VER >$_JV_RC

  # * ---------------- check if re-active

  [[ $_JV_CURRENT == "default" ]] && _jv_use default
}

# * ----------------------------------------------------------------

_jv_echo() {
  which java
  java -version
}

# * ---------------------------------------------------------------- main function

jv() {

  case "$1" in

  env)
    touch $_JV_RC
    export _JV_CURRENT="default"
    _jv_use default silent
    ;;

  ls | list)
    # ! no error check
    echo /Library/Java/JavaVirtualMachines/zulu-* | grep -Eo '(\d+\.)*\d+' | sort --numeric-sort
    ;;

  use]) _jv_use $2 ;;

  default) _jv_default $2 ;;

  *) _jv_echo ;;

  esac

}

# * ---------------------------------------------------------------- for zshrc init

jv env
