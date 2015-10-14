# ~/.profile

export JAVA_HOME="$(/usr/libexec/java_home)"
export AWS_RDS_HOME=$HOME/dl/RDSCli-1.15.001
export PATH=$PATH:$AWS_RDS_HOME/bin

export EDITOR=vi
# "/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
export PGDATA=/usr/local/var/postgres
export PATH=~/bin:$PATH


export AWSRB=pry

export AWS_CREDENTIAL_FILE=$HOME/.aws-credentials
source $AWS_CREDENTIAL_FILE
export AWS_ACCESS_KEY_ID=$AWSAccessKeyId
export AWS_SECRET_ACCESS_KEY=$AWSSecretKey
unset AWSAccessKeyId
unset AWSSecretKey

# rspec will squelch output from tests unless you do this
export SILENCE_STDOUT=false
export SILENCE_STDERR=false

# Set a good prompt
export PS1=": "

# useful: history -c; history -r  #reload history; yours is already written; no loss - just gaining what others have done.
# also: history -n; history -w  #re-write history w/ latest from everyone no de-dup?
# also: history -w  # will de-dup any commands you've run.  Will lose changes from other shells since this shell launched.
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%d/%m/%y %T "


# Aliases
alias ll='ls -la'
alias lockscreen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd......='cd ../../../../..'
# Load RVM

[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion


# from: http://superuser.com/questions/292652/change-iterm2-window-and-tab-titles-in-zsh
# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
# echo works in bash & zsh
setTerminalText() {
  local mode=$1 ; shift
  echo -ne "\033]$mode;$@\007"
}

stt_both() { setTerminalText 0 $@; }
stt_tab() { setTerminalText 1 $@; }
stt_title() { setTerminalText 2 $@; }

rvm-prompt() {
   local RVM_PROMPT=`$HOME/.rvm/bin/rvm-prompt`
   if [ -n "$RVM_PROMPT" ]; then
     echo "($RVM_PROMPT) "
   fi
}

git-prompt() {
 if [ -e /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
   . /usr/local/etc/bash_completion.d/git-prompt.sh
   echo "$(__git_ps1 " (%s)")"
 fi
}

tjm-short-date() {
  date | sed -e s/^....//  -e "s/\(......\) /\1@/" -e "s/ //g" -e "s/E.T201.//"
}

tjm-rvm-short-prompt() {
   local RVM_PROMPT=r`$HOME/.rvm/bin/rvm-prompt`
   local RVM_PROMPT=r`$HOME/.rvm/bin/rvm-prompt i v g`
   if [ -n "$RVM_PROMPT" ]; then
     echo "($RVM_PROMPT) "
   fi
}


tjm-git-short-prompt() {
 if [ -e /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
   . /usr/local/etc/bash_completion.d/git-prompt.sh
   echo "$(__git_ps1 " (%s)")" | sed "s/-\([a-z]\).*-/-\1...-/"
 fi
}


source ~/.git-completion.sh

alias ssh_forward='pkill -f "ssh -f -N tools1"; ssh -f -N tools1'

export LANG=C

source ~/.preexec.bash

preexec_impl() {
#  stt_title `tjm-short-date`
  stt_title `history 1 | sed "s/^ *[0-9]* //"`@`tjm-short-date`
  stt_tab `history 1 | sed "s/^ *[0-9]* //"`@`tjm-short-date`
}

preexec() { preexec_impl; }

#original
export PS1="\$(rvm-prompt)\w\$(git-prompt)$PS1"
#trevor's shorter version
export PS1="\[$(tput setaf 3)\]\$(tjm-short-date) \$(rvm-prompt)\$(git-prompt)\[$(tput sgr0)\]"

# useful info on colors: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# from: http://www.maketecheasier.com/8-useful-and-interesting-bash-prompts/
# /u - username
# /h - host
# This includes the \!, which I've decided is useless
#   export PS1="$PS1\n[\w] \[\e[32;1m\](\[\[\e[37;1m\]!\!\[\e[32;1m\])\[\e[0m\] $ "
# Trimmed up
export PS1="$PS1\n[\w] $ "

export PROMPT_COMMAND='preexec() { true ; } && stt_tab "`pwd` `tjm-short-date`" && stt_title `tjm-short-date` && preexec() { preexec_impl ; }'
#export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

complete -W "$(sed -e "s/[ ,].*//g" ~/.ssh/known_hosts)" ssh scp

# from: https://github.com/fiksu/freemyapps-android-app/wiki/Development-Environment-Setup
export ANDROID_HOME=/sdk # for Bundle installs, must be the /sdk subdir
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools
# keystore password needed by build.rb for production build mode
export FMA_ANDROID_KEYSTORE_PASSWD=dummy_password


#from: http://blog.tersmitten.nl/how-to-enable-syntax-highlighting-in-less.html
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -R '

# my own little helper
complete -o default -W "uninstall install com.fiksu.fma.android" adb

complete -W "$(brew list)" brew

alias chrome='open -a "Google Chrome"'
alias TRAVIS_ENDPOINT="--pro"

FMA_LAST_TIME=$(date +%s)
alias timer='date;echo $(($(date +%s)-$FMA_LAST_TIME)) seconds elapsed.;FMA_LAST_TIME=$(date +%s)'

GREP_OPTIONS=--line-buffered

complete -W 'alerts metrics' dogwatch

alias be="bundle exec"
alias bex="bundle exec"

source ~/.profile.local


alias start-fake-dynamo='pushd ~/work/infrastructure; bundle exec fake_dynamo --port 4567 > /dev/null 2>&1 &; popd'
alias start-fake-s3='pushd ~/work/aso-data-processor > /dev/null; (bex fakes3 --port 4569 --root /tmp/fakes3_root >> /tmp/fakes3.log 2>&1 &); popd>/dev/null'
alias start-fake-sqs='pushd ~/work/aso-data-processor > /dev/null; (bex fake_sqs >> /tmp/fakesqs.log 2>&1 &); popd>/dev/null'


alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
#add the other applications to your path
#PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH

alias em=emacs

#for ls color:
export CLICOLOR=1
#export LS_COLORS=1

source $HOME/.psql-shortcuts

function tjm-pg-whack-logs() {
  pushd /usr/local/var/postgres/pg_log
  rm postgresql-20*.log
  tjm-pg-rotate-logfile-test
}

# screencapture -iW ~/Desktop/screen.jpg

function rbgrep() {
  grep -r "$@" * --include=*.rb --include=*.erb ;
}

alias agl='ag --pager="less -r"'

. ~/.profile.local

function cfm() {
  cfstager show | grep $USER | sed "s/   */  /g" | sed "s/ *$//"
}

function apimap ()
{
  knife ssh -x $USER -a fqdn "chef_environment:data_api_production AND tags:data_api" "$@"
}

alias cddar="cd ~/work/data-api-ruby"
alias cdda="cd ~/work/data-api"
alias cdaa="cd ~/work/analytics_api"
alias cda="cd ~/work/aso-data-processor"
alias cdad="cd ~/work/rtb-p13n-data-processor"

function rr_cmd()
{
ruby -e "require 'active_support'; require 'active_support/core_ext'; puts ARGV[0].split('/')[-2..-1].map(&:camelize).join('::').gsub(/[.]rb$/,'') << '.run'" "$@"
}

function rr()
{
  echo bundle exec rails runner $(rr_cmd "$@")
  bundle exec rails runner $(rr_cmd "$@")
}


alias wf="time \wf"
# alias rr="rake rubocop"
