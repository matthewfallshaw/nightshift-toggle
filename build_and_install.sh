#!/bin/bash

# Create build directory if it doesn't exist
mkdir -p build

# Compile the Swift file
echo "Compiling nightshift-toggle..."
if ! swiftc -import-objc-header CoreBrightness-Bridging-Header.h \
  -F /System/Library/PrivateFrameworks \
  -framework CoreBrightness \
  -o build/nightshift-toggle NightShiftToggle.swift; then
    echo "Compilation failed!"
    exit 1
fi

# Copy to /usr/local/bin for easy access
echo "Installing to /usr/local/bin/nightshift-toggle..."
sudo cp build/nightshift-toggle /usr/local/bin/

# Make it executable
sudo chmod +x /usr/local/bin/nightshift-toggle

echo "Installation complete!"
echo "Usage:"
echo "  nightshift-toggle         # Toggle Night Shift on/off"
echo "  nightshift-toggle on      # Turn Night Shift on"
echo "  nightshift-toggle off     # Turn Night Shift off"
echo "  nightshift-toggle status  # Show current Night Shift status"
echo "  nightshift-toggle --help  # Display help information"
echo ""
echo "AppleScript example:"
echo "  do shell script \"/usr/local/bin/nightshift-toggle on\""