[[ -s "$HOME/.profile" ]] && . "$HOME/.profile" # Load the default .profile

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

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

# kubectl bash completion
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion bash)

# Add thefuck typo fixing
command -v thefuck >/dev/null 2>&1 && eval $(thefuck --alias)

# rbenv
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# Remove all colour attributes with 00m
NORMAL="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\e[01;33m\]"
GREEN="\[\e[01;32m\]"

# Prompt setting

# Allow git branch status to be shown in prompt
GIT_SYMBOL=$'\xE2\x8E\x87 '
parse_git_branch() {
  echo "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(${GIT_SYMBOL} \1)/")"
}

PROMPT_DIRTRIM=2 # only show the last 2 directories in prompt
export PS1="[\A]${GREEN}\u@\h${NORMAL}:${BLUE}\w${NORMAL} $(parse_git_branch)$(get_kubernetes_context)$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Bash History file control
HISTFILESIZE=1000000
HISTSIZE=100000
HISTIGNORE="ls:ps:cd:history:top:htop:clear:exit:pwd:uptime:uname"
HISTCONTROL=ignoreboth:erasedups

# Aliases
alias ls="ls -F"
alias ll="ls -Glh"
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi
alias remindMe="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias kc="kubectl"

# PATH additions
paths=(
  "${KREW_ROOT:-$HOME/.krew}/bin"
  "$HOME/.codeium/windsurf/bin"
  "$HOME/.local/bin"
)

if [[ "$(uname -s)" == "Darwin" ]]; then
  if command -v brew >/dev/null 2>&1; then
    paths+=(
      "/opt/homebrew/opt/mysql@5.7/bin"
      "$(brew --prefix python)/libexec/bin"
    )
  else
    echo "Homebrew not found. Install it at https://brew.sh"
  fi
fi

for p in "${paths[@]}"; do
  export PATH="$p:$PATH"
done
