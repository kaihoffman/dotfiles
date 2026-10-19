paths=(
  "$HOME/go/bin"
  "${KREW_ROOT:-$HOME/.krew}/bin"
  "$HOME/.codeium/windsurf/bin"
  "$HOME/.local/bin"
)

if [[ "$(uname -s)" == "Darwin" ]]; then
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
  if command -v brew >/dev/null 2>&1; then
    paths+=(
      "$HOMEBREW_PREFIX/opt/mysql@5.7/bin"
      "$HOMEBREW_PREFIX/opt/python/libexec/bin"
    )
  else
    echo "Homebrew not found. Install it at https://brew.sh"
  fi
fi

for p in "${paths[@]}"; do
  export PATH="$p:$PATH"
done
unset paths p

source ~/.orbstack/shell/init.bash 2>/dev/null || :

# ls colours (BSD ls)
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
