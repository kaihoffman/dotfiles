# Add Krew binary path to PATH to make sure it works as intended
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:$HOME/go/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source <(civo completion bash)
