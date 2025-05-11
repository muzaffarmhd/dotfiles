#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo." >&2
  exit 1
fi

INSTALL_CMD=""
UPDATE_CMD=""
PACKAGES="rofi xdg-utils findutils" 

if command -v apt-get &> /dev/null; then
    echo "Detected apt-get package manager."
    UPDATE_CMD="apt-get update"
    INSTALL_CMD="apt-get install -y"
elif command -v dnf &> /dev/null; then
    echo "Detected dnf package manager."
    INSTALL_CMD="dnf install -y"
elif command -v yum &> /dev/null; then
    echo "Detected yum package manager."
    INSTALL_CMD="yum install -y"
elif command -v pacman &> /dev/null; then
    echo "Detected pacman package manager."
    UPDATE_CMD="pacman -Syu --noconfirm" 
    INSTALL_CMD="pacman -S --noconfirm"
elif command -v zypper &> /dev/null; then
    echo "Detected zypper package manager."
    UPDATE_CMD="zypper refresh"
    INSTALL_CMD="zypper install -y"
else
    echo "Unsupported package manager. Please install the following packages manually: $PACKAGES" >&2
fi

if [ -n "$INSTALL_CMD" ]; then
    if [ -n "$UPDATE_CMD" ]; then
        echo "Updating package lists..."
        $UPDATE_CMD
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to update package lists. Proceeding with installation attempt." >&2
        fi
    fi
    echo "Installing dependencies: $PACKAGES..."
    $INSTALL_CMD $PACKAGES
    if [ $? -ne 0 ]; then
        echo "Error installing dependencies. Please try installing them manually: $PACKAGES" >&2
    else
        echo "Dependencies installed successfully."
    fi
else
    echo "Proceeding without automatic dependency installation. Ensure $PACKAGES are installed."
fi

SEARCH_SCRIPT_SOURCE="./search.sh"
if [ ! -f "$SEARCH_SCRIPT_SOURCE" ]; then
    echo "Error: $SEARCH_SCRIPT_SOURCE not found in the current directory." >&2
    exit 1
fi

TARGET_SCRIPT_DIR="/usr/bin"
TARGET_SCRIPT_NAME="ffs"
TARGET_SCRIPT_PATH="$TARGET_SCRIPT_DIR/$TARGET_SCRIPT_NAME"

mkdir -p "$TARGET_SCRIPT_DIR"

echo "Copying $SEARCH_SCRIPT_SOURCE to $TARGET_SCRIPT_PATH..."
cp "$SEARCH_SCRIPT_SOURCE" "$TARGET_SCRIPT_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy $SEARCH_SCRIPT_SOURCE to $TARGET_SCRIPT_PATH." >&2
    echo "Please check permissions and if the target location is writable." >&2
    exit 1
fi

echo "Making $TARGET_SCRIPT_PATH executable..."
chmod +x "$TARGET_SCRIPT_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to make $TARGET_SCRIPT_PATH executable." >&2
    exit 1
fi

echo ""
echo "Installation complete!"
echo "You can now try running '$TARGET_SCRIPT_NAME' from your terminal."
echo "If you encounter issues, please ensure the following packages are installed: $PACKAGES"

exit 0