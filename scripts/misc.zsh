# * ---------------------------------------------------------------- fix

# turn off Low Process Priority Throttling, speed up timemachines
[[ -n $(sysctl debug.lowpri_throttle_enabled | grep 1) ]] && sudo sysctl debug.lowpri_throttle_enabled=0

# fix ssh-agent not start. Error connecting to agent: No such file or directory
# [[ -z $(ps -p $SSH_AGENT_PID 2>/dev/null) ]] && eval $(ssh-agent -s) &>/dev/null
[[ -z $(ssh-add -l 2>/dev/null) ]] && eval $(ssh-agent -s) &>/dev/null

# * ---------------------------------------------------------------- setting

# * https://github.com/sharkdp/fd#using-fd-with-fzf
# export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore --color=always'
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--ansi"

# * ---------------------------------------------------------------- keymap

# capslock -> f16 https://hidutil-generator.netlify.app/
# ! deprecated, use karabiner-elements instead

# [[ -z $(hidutil property --get UserKeyMapping | grep HIDKeyboardModifierMappingSrc) ]] && hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc": 0x700000039,"HIDKeyboardModifierMappingDst": 0x70000006B}]}'
# hidutil property --set '{"UserKeyMapping":[]}'
# hidutil property --get UserKeyMapping

# * ---------------------------------------------------------------- alias

# * ------------------------------------------------ brew

# https://stackoverflow.com/questions/41029842/easy-way-to-have-homebrew-list-all-package-dependencies
alias bb='brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'

alias bout='brew update; brew outdated'
alias bup='brew upgrade'

alias bs='brew search'
alias bi='brew install'
alias bri='brew reinstall'
alias bui='brew uninstall'
alias bf='brew info'
alias bclean='brew autoremove; brew cleanup'

# * ------------------------------------------------ time machine

alias tmlist='tmutil listbackups -t'

alias tmthin='tmutil thinlocalsnapshots / 21474836480 4'

alias tmstart='tmutil startbackup'

alias tmstatus='tmutil status'

# * ------------------------------------------------ override

alias l="eza -lah"

alias rm='trash'

alias du="du -h"
alias fd="fd --hidden --no-ignore"

alias hsi='history | fzf --tac --no-sort --exact'
alias hsg='history | rg -P --color=always'

alias scc="scc --no-cocomo --no-size"

alias daisy="open -a DaisyDisk"
alias iterm="open -a iterm"

alias DDD='date -u +"// TODO // Seognil LC %Y/%m/%d"'

# * ---------------------------------------------------------------- alias function

# * ------------------------------------------------ download

dl() {
  [[ -z $1 ]] && echo "Usage:\n$ dl https://xxx.xxx/xxx [filename]" >&2 && return 2

  filename=${2:-./$(basename $1)}
  curl -fSL $1 -o $filename && echo "\n→ $filename" || echo "\n Fatal: Download Failed" >&2
}

# * ------------------------------------------------ mas

# https://osxdaily.com/2013/09/28/list-mac-app-store-apps-terminal/
# https://github.com/mas-cli/mas

masList() {
  find /Applications \
    -path '*Contents/_MASReceipt/receipt' \
    -maxdepth 4 -print |
    sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
}
