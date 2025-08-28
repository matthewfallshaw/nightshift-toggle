#!/bin/bash

# Create build directory if it doesn't exist
mkdir -p build/release

# Compile the Swift file
echo "Compiling nightshift-toggle..."
if ! swiftc -import-objc-header CoreBrightness-Bridging-Header.h \
  -F /System/Library/PrivateFrameworks \
  -framework CoreBrightness \
  -o build/release/nightshift-toggle NightShiftToggle.swift; then
    echo "Compilation failed!"
    exit 1
fi

# Create symlink in /usr/local/bin for easy access
echo "Creating symlink at /usr/local/bin/nightshift-toggle..."
# Remove existing symlink or file if it exists
sudo rm -f /usr/local/bin/nightshift-toggle
# Create symlink to the built binary
sudo ln -sf "$(pwd)/build/release/nightshift-toggle" /usr/local/bin/nightshift-toggle

echo "Installation complete!"
echo "Usage:"
echo "  nightshift-toggle         # Toggle Night Shift on/off"
echo "  nightshift-toggle on      # Turn Night Shift on"
echo "  nightshift-toggle off     # Turn Night Shift off"
echo "  nightshift-toggle status  # Show current Night Shift status"
echo "  nightshift-toggle --help  # Display help information"
echo ""
echo "To find source location:"
echo "  readlink -f \$(which nightshift-toggle)"
echo "  ls -la \$(which nightshift-toggle)"
echo ""
echo "AppleScript example:"
echo "  do shell script \"/usr/local/bin/nightshift-toggle on\""