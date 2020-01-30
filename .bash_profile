
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

GIT_SYMBOL="\xE2\x8E\x87"
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# The following function is from Chris Vermeulen's guide, modified to not error when no context is present
get_kubernetes_context()
{
  CONTEXT=$(kubectl config current-context 2>/dev/null)
  KUBE_SYMBOL=$'\xE2\x8E\x88 '
  if [ -n "$CONTEXT" ]; then
    NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    if [ -n "$NAMESPACE" ]; then
      echo "(${KUBE_SYMBOL} ${CONTEXT} :: ${NAMESPACE})"
    else
      echo "(${KUBE_SYMBOL} ${CONTEXT}:None)"
    fi
 fi
}

# Remove all colour attributes with 00m
NORMAL="\[\033[00m\]"

BLUE="\[\033[01;34m\]"
YELLOW="\[\e[1;33m\]"
GREEN="\[\e[1;32m\]"

PROMPT_DIRTRIM=2
export PS1='\[\033[01;32m\]\[\033[0m\033[0;32m\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $(parse_git_branch)$(get_kubernetes_context)$ '
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

HISTFILESIZE=1000000
HISTSIZE=1000
HISTIGNORE="ls:ps:cd:history:top:htop"

alias ll="ls -GFlh"
alias find="fd"
alias remindMe="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
