export OPENCODE_PROVIDER="$(awk -F: '/^provider:/{print $2; exit}' "${HOME}/.config/opencode/.active_provider" 2>/dev/null || echo xiaomi)"
export OPENCODE_PROVIDER="${OPENCODE_PROVIDER:-xiaomi}"
