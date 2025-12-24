# 1. Validation
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_appimage> <app_name>"
    exit 1
fi

SOURCE_FILE="$1"
APP_NAME="$2"
SOURCE_FILE=$(realpath "$SOURCE_FILE")

TARGET_DIR="$HOME/Applications"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons"
FILENAME=$(basename "$SOURCE_FILE")
TARGET_PATH="$TARGET_DIR/$FILENAME"

# 2. Preparation
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: File $SOURCE_FILE not found."
    exit 1
fi

mkdir -p "$TARGET_DIR" "$DESKTOP_DIR" "$ICON_DIR"
chmod +x "$SOURCE_FILE"

# 3. Icon Extraction Logic (Deep Search Mode)
echo "Searching for icon..."
rm -rf squashfs-root

# Step A: Try Standard .DirIcon
"$SOURCE_FILE" --appimage-extract .DirIcon > /dev/null 2>&1

REAL_ICON_PATH=""

if [ -e "squashfs-root/.DirIcon" ]; then
    if [ -L "squashfs-root/.DirIcon" ]; then
        LINK_TARGET=$(readlink "squashfs-root/.DirIcon")
        "$SOURCE_FILE" --appimage-extract "$LINK_TARGET" > /dev/null 2>&1
        REAL_ICON_PATH="squashfs-root/$LINK_TARGET"
    else
        REAL_ICON_PATH="squashfs-root/.DirIcon"
    fi
fi

# Step B: Brute force inside usr/share if standard failed
if [ ! -f "$REAL_ICON_PATH" ]; then
    echo "Standard icon not found. Digging deeper..."
    # Extract common icon folders
    "$SOURCE_FILE" --appimage-extract "usr/share/icons" > /dev/null 2>&1
    "$SOURCE_FILE" --appimage-extract "usr/share/pixmaps" > /dev/null 2>&1

    # Find the largest PNG or SVG file (usually the best icon)
    # This command finds all png/svg, lists detailed info, sorts by size (descending), picks top 1
    FOUND_ICON=$(find squashfs-root -type f \( -name "*.png" -o -name "*.svg" \) -printf "%s\t%p\n" | sort -rn | head -n 1 | cut -f2-)

    if [ ! -z "$FOUND_ICON" ]; then
        REAL_ICON_PATH="$FOUND_ICON"
    fi
fi

# Final processing
ICON_NAME="utilities-terminal"

if [ -f "$REAL_ICON_PATH" ]; then
    EXT="${REAL_ICON_PATH##*.}"
    DEST_ICON_NAME="${APP_NAME}.${EXT}"

    # Copy to icon dir
    cp "$REAL_ICON_PATH" "$ICON_DIR/$DEST_ICON_NAME"
    ICON_NAME="$APP_NAME"
    echo "Icon extracted to $ICON_DIR/$DEST_ICON_NAME"
else
    echo "Failed to extract any icon. Using default."
fi

# Cleanup extraction artifacts
rm -rf squashfs-root

# 4. Move AppImage (Only if source and target differ)
if [ "$SOURCE_FILE" != "$TARGET_PATH" ]; then
    mv "$SOURCE_FILE" "$TARGET_PATH"
    echo "AppImage moved to $TARGET_PATH"
else
    echo "AppImage already in target folder."
fi

# Check if we have appimage-run available
EXEC_CMD="$TARGET_PATH"
if command -v appimage-run &> /dev/null; then
    EXEC_CMD="appimage-run $TARGET_PATH"
fi

cat > "$DESKTOP_DIR/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$EXEC_CMD
Icon=$ICON_NAME
Terminal=false
Categories=Utility;
EOF

echo "Desktop entry created: $DESKTOP_DIR/$APP_NAME.desktop"
