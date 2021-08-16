# Use `window_title xyz` to show a custom tab title
function window_title {
    echo -ne "\033]0;"$*"\007"
}

# Add Krew binary path to PATH to make sure it works as intended
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

