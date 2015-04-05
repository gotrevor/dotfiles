PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# added by travis gem
[ -f /Users/tmorris/.travis/travis.sh ] && source /Users/tmorris/.travis/travis.sh

PERL_MB_OPT="--install_base \"/Users/tmorris/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/tmorris/perl5"; export PERL_MM_OPT;

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"
