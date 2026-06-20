#!/bin/bash
# Install Tokyo Night theme for bat and rebuild cache

THEME_NAME="tokyonight_night"
THEME_FILE="${HOME}/.config/bat/themes/${THEME_NAME}.tmTheme"

# Create themes directory if it doesn't exist
mkdir -p "$(dirname "$THEME_FILE")"

# Copy the theme from chezmoi source
if [[ ! -f "$THEME_FILE" ]]; then
    echo "Installing ${THEME_NAME} theme for bat..."
fi

# Rebuild bat cache to register the theme
echo "Rebuilding bat cache..."
bat cache --build 2>&1 | grep -E "(theme|Writing)"
echo "Done."
