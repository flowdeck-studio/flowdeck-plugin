# FlowDeck Plugin for Claude Code

This plugin teaches Claude Code how to use [FlowDeck CLI](https://flowdeck.studio) for iOS/macOS development and debugging.

## What This Plugin Does

- **Skill**: Teaches Claude when and how to use FlowDeck commands for building, running, testing, UI automation (`flowdeck ui simulator`), and debugging iOS/macOS apps
- **Hook**: Blocks direct use of Apple CLI tools (xcodebuild, xcrun simctl, xcrun devicectl) and suggests FlowDeck equivalents

## Prerequisites

You need FlowDeck CLI installed:

```bash
curl -sSL https://flowdeck.studio/install.sh | sh
```

See [flowdeck.studio](https://flowdeck.studio) for more details.

## Installation

1. Add the marketplace:
```
/plugin marketplace add flowdeck-studio/flowdeck-plugin
```

2. Install the plugin:
```
/plugin install flowdeck@flowdeck-plugins/flowdeck
```

## What Gets Installed

```
~/.claude/plugins/flowdeck/
├── skills/flowdeck/SKILL.md    # Teaches Claude about FlowDeck
├── hooks/hooks.json            # Hook configuration
└── scripts/flowdeck-guard.sh   # Blocks Apple CLI tools
```

## Usage

Once installed, Claude will automatically:

1. Use `flowdeck` commands instead of xcodebuild, xcrun simctl, etc.
2. Follow the FlowDeck debug loop (run app, attach logs, capture screenshots)
3. Block attempts to use Apple CLI tools directly

Example prompts that will use FlowDeck:

- "Build and run my iOS app"
- "Run the tests on iPhone 16 simulator"
- "Take a screenshot of the simulator"
- "Automate a login flow in the iOS simulator UI"
- "Find and tap an element via accessibility"
- "Debug why the login screen isn't working"

You can also ask for interactive mode workflows:

- "Open interactive mode and select a simulator"
- "Export the current project config from the TUI"

## Uninstallation

```
/plugin uninstall flowdeck
```

## License

MIT
