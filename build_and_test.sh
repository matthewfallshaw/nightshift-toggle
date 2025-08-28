#!/bin/bash

# Detect if we're running in an interactive shell
if [ -t 0 ]; then
  # Terminal is interactive
  INTERACTIVE=true
else
  # Terminal is non-interactive
  INTERACTIVE=false
  echo "WARNING: Running in non-interactive mode. Tests will run automatically without pauses."
  echo "         Display settings may not actually change in this mode."
fi

# Create test build directory if it doesn't exist
mkdir -p build/tests

echo "Building nightshift-toggle for testing..."
if ! swiftc -import-objc-header CoreBrightness-Bridging-Header.h \
  -F /System/Library/PrivateFrameworks \
  -framework CoreBrightness \
  -o build/tests/nightshift-toggle NightShiftToggle.swift; then
    echo "Compilation failed!"
    exit 1
fi

echo "Making executable..."
chmod +x build/tests/nightshift-toggle

# Function to check if Night Shift is enabled
get_status() {
    STATUS_OUTPUT=$(build/tests/nightshift-toggle status)
    if echo "$STATUS_OUTPUT" | grep -q "Night Shift is currently ON"; then
        echo "ON"
    elif echo "$STATUS_OUTPUT" | grep -q "Night Shift is currently OFF"; then
        echo "OFF"
    else
        echo "UNKNOWN"
    fi
}

echo "===== COMPREHENSIVE NIGHT SHIFT TESTS ====="
echo

echo "TEST 1: Current status check"
echo "Checking current Night Shift status..."
build/tests/nightshift-toggle status
CURRENT_STATUS=$(get_status)
echo "→ Current status detected as: $CURRENT_STATUS"
echo "Test complete!"
echo

echo "TEST 2: Toggle test"
echo "Current status is: $CURRENT_STATUS"
echo "Will now toggle Night Shift. Expected new status: $([ "$CURRENT_STATUS" == "ON" ] && echo "OFF" || echo "ON")"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue (or Ctrl+C to cancel)..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle
NEW_STATUS=$(get_status)
echo "→ New status is: $NEW_STATUS"
if [ "$CURRENT_STATUS" == "ON" ] && [ "$NEW_STATUS" == "OFF" ]; then
    echo "✅ Toggle ON→OFF worked correctly!"
elif [ "$CURRENT_STATUS" == "OFF" ] && [ "$NEW_STATUS" == "ON" ]; then
    echo "✅ Toggle OFF→ON worked correctly!"
else
    echo "❌ Toggle test failed! Status did not change as expected."
fi
echo "Test complete!"
echo

echo "TEST 3: Explicit OFF command"
echo "Will now explicitly turn Night Shift OFF. Expected status: OFF"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle off
OFF_STATUS=$(get_status)
echo "→ Status after 'off' command: $OFF_STATUS"
if [ "$OFF_STATUS" == "OFF" ]; then
    echo "✅ Explicit OFF command worked correctly!"
else
    echo "❌ Explicit OFF command failed! Status is not OFF."
fi
echo "Test complete!"
echo

echo "TEST 4: OFF→OFF transition"
echo "Current status is: $OFF_STATUS (should be OFF)"
echo "Will attempt OFF→OFF transition. Expected status: should remain OFF"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle off
OFF_OFF_STATUS=$(get_status)
echo "→ Status after second 'off' command: $OFF_OFF_STATUS"
if [ "$OFF_OFF_STATUS" == "OFF" ]; then
    echo "✅ OFF→OFF transition handled correctly!"
else
    echo "❌ OFF→OFF transition test failed! Status changed unexpectedly."
fi
echo "Test complete!"
echo

echo "TEST 5: Explicit ON command"
echo "Will now explicitly turn Night Shift ON. Expected status: ON"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle on
ON_STATUS=$(get_status)
echo "→ Status after 'on' command: $ON_STATUS"
if [ "$ON_STATUS" == "ON" ]; then
    echo "✅ Explicit ON command worked correctly!"
else
    echo "❌ Explicit ON command failed! Status is not ON."
fi
echo "Test complete!"
echo

echo "TEST 6: ON→ON transition"
echo "Current status is: $ON_STATUS (should be ON)"
echo "Will attempt ON→ON transition. Expected status: should remain ON"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle on
ON_ON_STATUS=$(get_status)
echo "→ Status after second 'on' command: $ON_ON_STATUS"
if [ "$ON_ON_STATUS" == "ON" ]; then
    echo "✅ ON→ON transition handled correctly!"
else
    echo "❌ ON→ON transition test failed! Status changed unexpectedly."
fi
echo "Test complete!"
echo

echo "TEST 7: Toggle back"
echo "Current status is: $ON_ON_STATUS (should be ON)"
echo "Will now toggle Night Shift again. Expected status: OFF"
if [ "$INTERACTIVE" = true ]; then
    read -r -p "Press Enter to continue..."
else
    echo "Auto-continuing (non-interactive mode)..."
fi
build/tests/nightshift-toggle
FINAL_STATUS=$(get_status)
echo "→ Final status: $FINAL_STATUS"
if [ "$FINAL_STATUS" == "OFF" ]; then
    echo "✅ Final toggle ON→OFF worked correctly!"
else
    echo "❌ Final toggle test failed! Status is not OFF as expected."
fi
echo "Test complete!"
echo

# TEST 8: Restore original state
echo "TEST 8: Restoring original state"
echo "Initial Night Shift status was: $CURRENT_STATUS"
echo "Current status is: $FINAL_STATUS"
if [ "$CURRENT_STATUS" != "$FINAL_STATUS" ]; then
    echo "Restoring Night Shift to its original state ($CURRENT_STATUS)..."
    if [ "$INTERACTIVE" = true ]; then
        read -r -p "Press Enter to continue..."
    else
        echo "Auto-continuing (non-interactive mode)..."
    fi
    if [ "$CURRENT_STATUS" == "ON" ]; then
        build/tests/nightshift-toggle on
    else
        build/tests/nightshift-toggle off
    fi
    RESTORED_STATUS=$(get_status)
    echo "→ Status after restoration: $RESTORED_STATUS"
    if [ "$RESTORED_STATUS" == "$CURRENT_STATUS" ]; then
        echo "✅ Successfully restored Night Shift to its original state!"
    else
        echo "❌ Failed to restore Night Shift to its original state."
    fi
else
    echo "✅ Night Shift is already in its original state. No restoration needed."
fi
echo "Test complete!"
echo

# Print summary
echo "===== TEST SUMMARY ====="
echo "Initial status: $CURRENT_STATUS"
echo "After toggle: $NEW_STATUS"
echo "After explicit OFF: $OFF_STATUS"
echo "After OFF→OFF: $OFF_OFF_STATUS"
echo "After explicit ON: $ON_STATUS"
echo "After ON→ON: $ON_ON_STATUS"
echo "After final toggle: $FINAL_STATUS"
echo "Final restored status: ${RESTORED_STATUS:-$FINAL_STATUS}"
echo

# Check success conditions
if [ "$OFF_STATUS" == "OFF" ] && [ "$ON_STATUS" == "ON" ] && \
   [ "$OFF_OFF_STATUS" == "OFF" ] && [ "$ON_ON_STATUS" == "ON" ] && \
   [ "${RESTORED_STATUS:-$CURRENT_STATUS}" == "$CURRENT_STATUS" ]; then
    echo "✅ ALL TESTS PASSED! The tool appears to be functioning correctly."
    echo

    # Add note about non-interactive mode if applicable
    if [ "$INTERACTIVE" = false ]; then
        echo "NOTE: Tests ran in non-interactive mode. Only API calls were tested."
        echo "      For a full test including display changes, run this command:"
        echo "      cd $(pwd) && ./build_and_test.sh"
        echo
    fi

    echo "If you're satisfied with the test results, you can now run the build_and_install.sh script"
    echo "to install it to /usr/local/bin for system-wide use."
else
    echo "❌ SOME TESTS FAILED. Please review the results above before installing."
fi