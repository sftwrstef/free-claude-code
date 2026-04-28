#!/bin/bash

# Setup script for Claude Frankenstein Proxy
# This script configures the .zshrc and macOS LaunchAgent

PROXY_DIR=$(pwd)
USERNAME=$(whoami)
PLIST_NAME="com.$USERNAME.claudeproxy"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"

echo "Setting up Claude Frankenstein Proxy in $PROXY_DIR..."

# 1. Update .zshrc
if ! grep -q "ANTHROPIC_BASE_URL" ~/.zshrc; then
    echo "Adding environment variables to ~/.zshrc..."
    echo "" >> ~/.zshrc
    echo "# Claude Frankenstein Proxy Config" >> ~/.zshrc
    echo "export ANTHROPIC_BASE_URL=\"http://localhost:8088\"" >> ~/.zshrc
    echo "export ANTHROPIC_API_KEY=\"sk-ant-openrouter-REPLACE_ME_WITH_YOUR_KEY\"" >> ~/.zshrc
else
    echo ".zshrc already contains proxy config. Skipping."
fi

# 2. Create LaunchAgent plist from template
echo "Creating LaunchAgent at $PLIST_PATH..."
sed "s|{{PROXY_DIR}}|$PROXY_DIR|g; s|{{USERNAME}}|$USERNAME|g" deploy/com.claudeproxy.plist.template > "$PLIST_PATH"

# 3. Load LaunchAgent
echo "Loading LaunchAgent..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "Done! Restart your terminal and run 'claude' to start the monster."
