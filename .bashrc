# Interactive shell settings. Sourced by .bash_profile for login shells and read directly by
# non-login interactive shells (e.g. a nested `bash`). Environment/PATH lives in .profile.

# Nothing below is useful in a non-interactive shell
[[ $- == *i* ]] || return

# a function to shortcut whether a command exists
has() { command -v "$1" >/dev/null 2>&1; }

# Completions
[[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash_completion.sh" ]] && . "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash_completion.sh"
if has kubectl; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl kc
fi
# swamp shell completions (https://swamp.club)
has swamp && source <(swamp completions bash)

# Add thefuck typo fixing
has thefuck && eval "$(thefuck --alias)"

# rbenv
has rbenv && eval "$(rbenv init -)"

# Use `window_title xyz` to show a custom tab title
window_title() {
  echo -ne "\033]0;$*\007"
}

# Bash loops as per Petrus Repo's (@pre) dotfiles. The first loops until interrupted, the second loops until a success exit code is provided.
loop() {
  while sleep 1; do eval "$@"; done
}

luup() {
  while sleep 1; do eval "$@" && return; done
}

# Add a function to "extract filename" that figures out the right tool to use
extract() {
  case "$1" in
    *.tar.gz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *) echo "Don't know how to extract '$1'" ;;
  esac
}

# Prompt setting

# Remove all colour attributes with 00m
NORMAL="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\e[01;32m\]"

# The following function is from Chris Vermeulen's guide, modified to not error when no context is present
get_kubernetes_context() {
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

# Allow git branch status to be shown in prompt
GIT_SYMBOL=$'\xE2\x8E\x87 '
parse_git_branch() {
  echo "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(${GIT_SYMBOL} \1)/")"
}

PROMPT_DIRTRIM=2 # only show the last 2 directories in prompt
# \$(...) is escaped so the branch and kube context are re-evaluated on every prompt, not just at login
PS1="[\A]${GREEN}\u@\h${NORMAL}:${BLUE}\w${NORMAL} \$(parse_git_branch)\$(get_kubernetes_context)\$ "

# Bash History file control
HISTFILESIZE=1000000
HISTSIZE=100000
HISTIGNORE="ls:ps:cd:history:top:htop:clear:exit:pwd:uptime:uname"
HISTCONTROL=ignoreboth:erasedups

# Aliases
alias ls="ls -F"
alias ll="ls -Glh"
if has fd; then
  alias find='fd'
fi
alias remindMe="git remindme"
alias kc="kubectl"
