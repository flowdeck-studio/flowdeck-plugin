#!/bin/bash
# FlowDeck Guard - Claude Code Hook
# Prevents direct use of Apple CLI tools that FlowDeck replaces
#
# This hook blocks commands like xcodebuild, xcrun simctl, and xcrun devicectl
# and suggests the equivalent FlowDeck command instead.

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command from JSON
# Format: {"tool_input": {"command": "..."}}
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"//' | sed 's/"$//')

# If no command found, allow execution
if [ -z "$COMMAND" ]; then
    exit 0
fi

# Helper function to block with message
block_with_suggestion() {
    local blocked_cmd="$1"
    local suggestion="$2"
    echo "BLOCKED: $blocked_cmd" >&2
    echo "" >&2
    echo "FlowDeck provides this functionality. Use instead:" >&2
    echo "  $suggestion" >&2
    echo "" >&2
    echo "FlowDeck is your primary tool for iOS/macOS development." >&2
    echo "See 'flowdeck --help' for more commands." >&2
    exit 2
}

# ============================================================================
# xcodebuild commands
# FlowDeck replaces: -list, build, test, clean
# ============================================================================

# Block: xcodebuild -list → flowdeck context/scheme list
if echo "$COMMAND" | grep -qE 'xcodebuild\s+.*-list(\s|$)' || \
   echo "$COMMAND" | grep -qE 'xcodebuild\s+-list(\s|$)'; then
    block_with_suggestion "xcodebuild -list" "flowdeck context --json  OR  flowdeck scheme list"
fi

# Block: xcodebuild build → flowdeck build
if echo "$COMMAND" | grep -qE 'xcodebuild\s+.*\s+build(\s|$)' || \
   echo "$COMMAND" | grep -qE 'xcodebuild\s+build(\s|$)'; then
    block_with_suggestion "xcodebuild build" "flowdeck build"
fi

# Block: xcodebuild test → flowdeck test
if echo "$COMMAND" | grep -qE 'xcodebuild\s+.*\s+test(\s|$)' || \
   echo "$COMMAND" | grep -qE 'xcodebuild\s+test(\s|$)'; then
    block_with_suggestion "xcodebuild test" "flowdeck test"
fi

# Block: xcodebuild clean → flowdeck clean
if echo "$COMMAND" | grep -qE 'xcodebuild\s+.*\s+clean(\s|$)' || \
   echo "$COMMAND" | grep -qE 'xcodebuild\s+clean(\s|$)'; then
    block_with_suggestion "xcodebuild clean" "flowdeck clean"
fi

# ============================================================================
# xcrun simctl commands
# FlowDeck replaces: list, boot, shutdown, erase, create, delete, install,
#                    launch, io screenshot, terminate, uninstall
# ============================================================================

# Block: xcrun simctl list → flowdeck simulator list
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+list'; then
    block_with_suggestion "xcrun simctl list" "flowdeck simulator list [--json]"
fi

# Block: xcrun simctl boot → flowdeck simulator boot
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+boot'; then
    block_with_suggestion "xcrun simctl boot" "flowdeck simulator boot <udid>"
fi

# Block: xcrun simctl shutdown → flowdeck simulator shutdown
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+shutdown'; then
    block_with_suggestion "xcrun simctl shutdown" "flowdeck simulator shutdown <udid>"
fi

# Block: xcrun simctl erase → flowdeck simulator erase
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+erase'; then
    block_with_suggestion "xcrun simctl erase" "flowdeck simulator erase <udid>"
fi

# Block: xcrun simctl create → flowdeck simulator create
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+create'; then
    block_with_suggestion "xcrun simctl create" "flowdeck simulator create --name <name> --device-type <type> --runtime <runtime>"
fi

# Block: xcrun simctl delete → flowdeck simulator delete/prune
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+delete'; then
    block_with_suggestion "xcrun simctl delete" "flowdeck simulator delete <udid>  OR  flowdeck simulator prune"
fi

# Block: xcrun simctl install → flowdeck run
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+install'; then
    block_with_suggestion "xcrun simctl install" "flowdeck run (handles install automatically)"
fi

# Block: xcrun simctl launch → flowdeck run
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+launch'; then
    block_with_suggestion "xcrun simctl launch" "flowdeck run"
fi

# Block: xcrun simctl io screenshot → flowdeck simulator screenshot
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+io.*screenshot'; then
    block_with_suggestion "xcrun simctl io screenshot" "flowdeck simulator screenshot <udid> [--output <path>]"
fi

# Block: xcrun simctl terminate → flowdeck stop
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+terminate'; then
    block_with_suggestion "xcrun simctl terminate" "flowdeck stop"
fi

# Block: xcrun simctl uninstall → flowdeck stop
if echo "$COMMAND" | grep -qE 'xcrun\s+simctl\s+uninstall'; then
    block_with_suggestion "xcrun simctl uninstall" "flowdeck stop  (or reinstall with flowdeck run)"
fi

# ============================================================================
# xcrun devicectl commands (physical devices)
# FlowDeck replaces: list devices, device install/uninstall/launch/terminate
# ============================================================================

# Block: xcrun devicectl list devices → flowdeck device list
if echo "$COMMAND" | grep -qE 'xcrun\s+devicectl\s+list\s+devices'; then
    block_with_suggestion "xcrun devicectl list devices" "flowdeck device list [--json]"
fi

# Block: xcrun devicectl device install → flowdeck device install
if echo "$COMMAND" | grep -qE 'xcrun\s+devicectl\s+device\s+install'; then
    block_with_suggestion "xcrun devicectl device install" "flowdeck device install <udid> <app-path>"
fi

# Block: xcrun devicectl device uninstall → flowdeck device uninstall
if echo "$COMMAND" | grep -qE 'xcrun\s+devicectl\s+device\s+uninstall'; then
    block_with_suggestion "xcrun devicectl device uninstall" "flowdeck device uninstall <udid> <bundle-id>"
fi

# Block: xcrun devicectl device process launch → flowdeck device launch
if echo "$COMMAND" | grep -qE 'xcrun\s+devicectl\s+device\s+process\s+launch'; then
    block_with_suggestion "xcrun devicectl device process launch" "flowdeck device launch <udid> <bundle-id>"
fi

# Block: xcrun devicectl device process terminate → flowdeck stop
if echo "$COMMAND" | grep -qE 'xcrun\s+devicectl\s+device\s+process\s+terminate'; then
    block_with_suggestion "xcrun devicectl device process terminate" "flowdeck stop"
fi

# ============================================================================
# open command for built apps
# ============================================================================

# Block: open *.app from build products → flowdeck run
if echo "$COMMAND" | grep -qE 'open\s+.*\.app(/Contents)?(/MacOS)?(/[^/]+)?(\s|$)'; then
    if echo "$COMMAND" | grep -qE '(DerivedData|\.build).*\.app'; then
        block_with_suggestion "open <app>.app" "flowdeck run --simulator none  (for macOS apps)"
    fi
fi

# ============================================================================
# ALLOWED commands (explicitly not blocked)
# ============================================================================
# xcodebuild: -version, -showsdks, -showBuildSettings, -showDestinations
# xcodebuild: implicit builds (without explicit build/test/clean action)
# xcrun simctl: status_bar, openurl, spawn, privacy, push, keychain, addmedia
# xcrun devicectl: device info commands
# xcode-select, swift build/test/package, open -a Simulator

# If we reach here, the command is allowed
exit 0
