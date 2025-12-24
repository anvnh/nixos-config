if [ -z "$1" ]; then
    echo "Usage: $0 <keyword>"
    echo "Example: $0 Helium   (Finds Helium.desktop, Helium Browser.desktop, etc.)"
    exit 1
fi

KEYWORD="$1"

SEARCH_DIRS=(
    "$HOME/.local/share/applications"
    "/run/current-system/sw/share/applications"
    "$HOME/.nix-profile/share/applications"
    "/etc/profiles/per-user/$USER/share/applications"
    "/usr/share/applications"
)

echo "Searching for desktop file matching '$KEYWORD'..."

# Find matching .desktop files
FOUND_FILES=$(find "${SEARCH_DIRS[@]}" -maxdepth 1 -name "*.desktop" 2>/dev/null | grep -i "$KEYWORD" | awk -F/ '{print $NF}' | sort | uniq)

COUNT=$(echo "$FOUND_FILES" | grep -c .)

if [ "$COUNT" -eq 0 ]; then
    echo "❌ No desktop file found matching '$KEYWORD'."
    exit 1
elif [ "$COUNT" -gt 1 ]; then
    echo "AMBIGOUS! Found multiple matches:"
    echo "$FOUND_FILES"
    echo "-------------------------------------"
    echo "Please be more specific (e.g., copy the exact name from above)."
    exit 1
fi

TARGET_DESKTOP=$(echo "$FOUND_FILES" | head -n 1)

echo "Found target: $TARGET_DESKTOP"
echo "Setting as default browser..."

# Set default
xdg-mime default "$TARGET_DESKTOP" x-scheme-handler/http
xdg-mime default "$TARGET_DESKTOP" x-scheme-handler/https
xdg-mime default "$TARGET_DESKTOP" x-scheme-handler/about
xdg-mime default "$TARGET_DESKTOP" x-scheme-handler/unknown
xdg-mime default "$TARGET_DESKTOP" text/html

# Verify
CURRENT=$(xdg-mime query default x-scheme-handler/https)
if [ "$CURRENT" == "$TARGET_DESKTOP" ]; then
    echo "Success! Default is now: $CURRENT"
else
    echo "Something went wrong. Current default is: $CURRENT"
fi
