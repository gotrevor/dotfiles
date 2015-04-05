# from top comment here: http://superuser.com/questions/175799/does-bash-have-a-hook-that-is-run-before-executing-a-command
# note that the more complete answers he references didn't work for me on first blush.

preexec () { :; }
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG
