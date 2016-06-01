if [ -e ~/.profile ]; then
	source ~/.profile
fi

export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="/Users/tmorris/anaconda/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
