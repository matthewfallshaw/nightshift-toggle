import Foundation

// Application metadata
private let appName = "nightshift-toggle"
private let appVersion = "1.0.0"

/*
 nightshift-toggle - Control macOS Night Shift from the command line

 This tool uses the private CoreBrightness API to control Night Shift.

 Compile with:
 swiftc -import-objc-header CoreBrightness-Bridging-Header.h -o nightshift-toggle NightShiftToggle.swift

 Usage:
 ./nightshift-toggle           # Toggle Night Shift
 ./nightshift-toggle on        # Turn Night Shift on
 ./nightshift-toggle off       # Turn Night Shift off
 ./nightshift-toggle status    # Show current status
 ./nightshift-toggle --help    # Display help
 */

// Extension to CBBlueLightClient to match Shifty's approach
extension CBBlueLightClient {
    // Shared instance - just like Shifty uses
    static var shared: CBBlueLightClient = {
        let client = CBBlueLightClient()
        return client
    }()

    // Convenience property for checking if Night Shift is enabled
    var isNightShiftEnabled: Bool {
        var status = Status()
        let success = getBlueLightStatus(&status)
        return success ? status.enabled.boolValue : false
    }

    // Method to enable/disable Night Shift (matching Shifty's approach)
    func setNightShiftEnabled(_ enabled: Bool) {
        _ = setEnabled(enabled)
    }

    // Check if Night Shift is supported
    static var supportsNightShift: Bool {
        return CBBlueLightClient.supportsBlueLightReduction()
    }
}

// Main toggle function - simplified to match Shifty's approach
func toggleNightShift() -> Bool {
    guard CBBlueLightClient.supportsNightShift else {
        print("Error: Night Shift is not supported on this Mac")
        return false
    }

    let client = CBBlueLightClient.shared
    let currentState = client.isNightShiftEnabled

    // Toggle Night Shift
    let newState = !currentState
    client.setNightShiftEnabled(newState)

    print("Night Shift is now \(newState ? "ON" : "OFF")")
    return true
}

// Function to set Night Shift to a specific state - simplified
func setNightShift(enabled: Bool) -> Bool {
    guard CBBlueLightClient.supportsNightShift else {
        print("Error: Night Shift is not supported on this Mac")
        return false
    }

    let client = CBBlueLightClient.shared
    let currentState = client.isNightShiftEnabled

    // Check if already in requested state
    if currentState == enabled {
        print("Night Shift is already \(enabled ? "ON" : "OFF")")
        return true
    }

    // Set Night Shift state
    client.setNightShiftEnabled(enabled)

    print("Night Shift is now \(enabled ? "ON" : "OFF")")
    return true
}

// Function to get current Night Shift status - simplified
func getNightShiftStatus() -> Bool? {
    guard CBBlueLightClient.supportsNightShift else {
        print("Error: Night Shift is not supported on this Mac")
        return nil
    }

    let client = CBBlueLightClient.shared
    let isEnabled = client.isNightShiftEnabled

    print("Night Shift is currently \(isEnabled ? "ON" : "OFF")")

    // Get schedule information
    var status = Status()
    let success = client.getBlueLightStatus(&status)
    if success {
        switch status.mode {
        case 0:
            print("Night Shift schedule: OFF")
        case 1:
            print("Night Shift schedule: Sunset to Sunrise")
        case 2:
            let fromHour = status.schedule.fromTime.hour
            let fromMinute = status.schedule.fromTime.minute
            let toHour = status.schedule.toTime.hour
            let toMinute = status.schedule.toTime.minute
            print("Night Shift schedule: Custom (\(fromHour):\(String(format: "%02d", fromMinute)) to \(toHour):\(String(format: "%02d", toMinute)))")
        default:
            print("Night Shift schedule: Unknown")
        }
    }

    return isEnabled
}

// Print help information
func printHelp() {
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    print("Usage: \(executableName) [OPTION]")
    print("")
    print("Control macOS Night Shift from the command line")
    print("")
    print("Options:")
    print("  on                Turn Night Shift on")
    print("  off               Turn Night Shift off")
    print("  toggle            Toggle Night Shift (default if no arguments provided)")
    print("  status            Display current Night Shift status")
    print("  -h, --help        Display this help message")
    print("  -v, --version     Display version information")
    print("")
    print("Examples:")
    print("  \(executableName)           # Toggle Night Shift on/off")
    print("  \(executableName) on        # Turn Night Shift on")
    print("  \(executableName) off       # Turn Night Shift off")
    print("  \(executableName) status    # Show current Night Shift status")
    print("")
    print("For more information, visit: https://github.com/yourusername/nightshift-toggle")
}

// Print version information
func printVersion() {
    print("\(appName) v\(appVersion)")
    print("Copyright (c) 2025")
    print("License: MIT")
}

// Main function to handle command-line arguments
func main() {
    if CommandLine.arguments.count > 1 {
        let arg = CommandLine.arguments[1].lowercased()

        switch arg {
        case "on":
            _ = setNightShift(enabled: true)
        case "off":
            _ = setNightShift(enabled: false)
        case "toggle":
            _ = toggleNightShift()
        case "status":
            _ = getNightShiftStatus()
        case "-h", "--help":
            printHelp()
        case "-v", "--version":
            printVersion()
        default:
            print("Unknown argument: \(arg)")
            print("Use --help for usage information")
        }
    } else {
        // Toggle mode if no arguments
        _ = toggleNightShift()
    }
}

main()