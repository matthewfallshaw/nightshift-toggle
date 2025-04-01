# nightshift-toggle

A command-line tool for controlling macOS Night Shift from the terminal or scripts. Perfect for automation with AppleScript, Shortcuts, cron jobs, or any other scripting environment.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- Toggle Night Shift on or off
- Check current Night Shift status
- Control via command line, AppleScript, or automation tools
- Follows Unix command-line conventions
- Restores the system to original state after testing

## Installation

### From Source

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/nightshift-toggle.git
   cd nightshift-toggle
   ```

2. Build and install:
   ```bash
   chmod +x build_and_install.sh
   ./build_and_install.sh
   ```

This will compile the tool and install it to `/usr/local/bin/nightshift-toggle`.

### Using Pre-built Binary

```bash
# Download the latest release
curl -L https://github.com/yourusername/nightshift-toggle/releases/download/v1.0.0/nightshift-toggle -o nightshift-toggle

# Make it executable
chmod +x nightshift-toggle

# Move to /usr/local/bin (may require sudo)
sudo mv nightshift-toggle /usr/local/bin/
```

## Usage

### Command Line

```bash
# Show help
nightshift-toggle --help

# Toggle Night Shift (if on, turn off; if off, turn on)
nightshift-toggle

# Turn Night Shift on
nightshift-toggle on

# Turn Night Shift off
nightshift-toggle off

# Show current Night Shift status
nightshift-toggle status

# Show version information
nightshift-toggle --version
```

### AppleScript

```applescript
-- Toggle Night Shift
do shell script "/usr/local/bin/nightshift-toggle"

-- Turn Night Shift on
do shell script "/usr/local/bin/nightshift-toggle on"

-- Turn Night Shift off
do shell script "/usr/local/bin/nightshift-toggle off"

-- Get status
set nightShiftStatus to do shell script "/usr/local/bin/nightshift-toggle status"
```

### Shortcuts App

#### Basic Integration

1. Add a "Run Shell Script" action
2. Enter `/usr/local/bin/nightshift-toggle on` (or your desired command)
3. Set "Pass Input" to "as arguments"

Example shortcuts:
```
# Toggle Night Shift shortcut
/usr/local/bin/nightshift-toggle

# Check Night Shift status and speak result
STATUS=$(/usr/local/bin/nightshift-toggle status | head -1)
echo $STATUS  # This becomes the output of the shortcut

# Turn Night Shift on at 50% screen brightness
/usr/local/bin/nightshift-toggle on
brightness 0.5
```

#### Advanced Integration

For rich Shortcuts integration with custom actions and UI, check out [Shifty](https://github.com/thompsonate/Shifty), which provides a full-featured Intents extension.

### Cron Jobs

Add to your crontab to schedule Night Shift changes:

```bash
# Turn Night Shift on at 8pm every day
0 20 * * * /usr/local/bin/nightshift-toggle on

# Turn Night Shift off at 7am every day
0 7 * * * /usr/local/bin/nightshift-toggle off
```

## Requirements

- macOS 10.12.4 (Sierra) or newer, which supports Night Shift
- Xcode Command Line Tools (for building from source)

## How It Works

`nightshift-toggle` uses the private `CBBlueLightClient` API from Apple's CoreBrightness framework to control Night Shift. Since this is a private API, it's not officially supported by Apple, but it works reliably across macOS versions.

## Troubleshooting

If you encounter permission issues:
- Make sure the binary is executable: `chmod +x /usr/local/bin/nightshift-toggle`
- You may need to allow Terminal to control your computer in System Preferences/Settings > Security & Privacy > Privacy > Accessibility

## Testing

Run the test script to verify functionality:

```bash
./build_and_test.sh
```

This will test all operations and restore your system to its original state.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

This tool was inspired by the [Shifty](https://github.com/thompsonate/Shifty) app which also uses the CoreBrightness private API to control Night Shift.