-- AppleScript to toggle Night Shift
-- You can save this as an application or run it from Script Editor

on run
    try
        do shell script "/usr/local/bin/NightShiftToggle"
    on error errorMessage
        display dialog "Error toggling Night Shift: " & errorMessage buttons {"OK"} default button "OK" with icon stop
    end try
end run