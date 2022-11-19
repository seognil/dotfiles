# turn off Low Process Priority Throttling
[[ -n $(sysctl debug.lowpri_throttle_enabled | grep 1) ]] && sudo sysctl debug.lowpri_throttle_enabled=0

# fix ssh-agent not start. Error connecting to agent: No such file or directory
# [[ -z $(ps -p $SSH_AGENT_PID 2>/dev/null) ]] && eval $(ssh-agent -s) &>/dev/null
[[ -z $(ssh-add -l 2>/dev/null) ]] && eval $(ssh-agent -s) &>/dev/null
