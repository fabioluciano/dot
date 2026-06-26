#!/usr/bin/env bash
# Configure Touch ID for sudo and battery percentage.
# Safe to re-run.

set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || exit 0

# Touch ID for sudo.
if [[ -f /usr/lib/pam/pam_terminate.so ]]; then
    if ! grep -q "pam_terminate.so" /etc/pam.d/sudo 2>/dev/null; then
        sudo sed -i '' '1s/^/auth       sufficient     pam_terminate.so\n/' /etc/pam.d/sudo
        echo "Touch ID configured for sudo"
    fi
fi

# Show battery percentage.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

killall SystemUIServer >/dev/null 2>&1 || true
