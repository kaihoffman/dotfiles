# Use `window_title xyz` to show a custom tab title
function window_title {
    echo -ne "\033]0;"$*"\007"
}

# Add Krew binary path to PATH to make sure it works as intended
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# added by travis gem
[ -f /Users/kai/.travis/travis.sh ] && source /Users/kai/.travis/travis.sh
