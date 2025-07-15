#!/bin/sh

echo "Starting Google Calendar MCP Server..."

# First time setup - build the project if needed
if [ ! -d "/app/build" ]; then
  echo "First run detected, building project..."
  cd /app
  npm install
  npm run build
fi

# Check tokens...
if [ -f "/app/config/tokens.json" ]; then
  echo "✅ Tokens found in volume..."
  cp /app/config/tokens.json /home/nodejs/.config/google-calendar-mcp/tokens.json
fi

# Start server
cd /app
exec node build/index.js --transport sse --port 8001
