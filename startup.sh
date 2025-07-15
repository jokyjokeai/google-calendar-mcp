#!/bin/sh

echo "Starting Google Calendar MCP Server..."

# Check if tokens exist in the config volume
if [ -f "/app/config/tokens.json" ]; then
  echo "✅ Tokens found in volume, copying to user directory..."
  # Copy to the expected location for the app
  cp /app/config/tokens.json /home/nodejs/.config/google-calendar-mcp/tokens.json
  echo "Tokens copied successfully!"
fi

# Check if credentials exist
if [ -f "/app/config/gcp-oauth.keys.json" ]; then
  echo "✅ Credentials found in volume..."
  export GOOGLE_OAUTH_CREDENTIALS="/app/config/gcp-oauth.keys.json"
else
  echo "⚠️ Warning: No credentials found in /app/config/"
fi

# Start the server with SSE transport
echo "Starting server on port 8000 with SSE transport..."
exec node /app/build/index.js --transport sse --port 8000
