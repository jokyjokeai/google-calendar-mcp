#!/bin/sh

echo "Starting Google Calendar MCP Server..."

# Create config directory if needed
mkdir -p /home/nodejs/.config/google-calendar-mcp

# Check if credentials exist
if [ -f "/app/config/gcp-oauth.keys.json" ]; then
  echo "✅ Credentials found..."
  export GOOGLE_OAUTH_CREDENTIALS="/app/config/gcp-oauth.keys.json"
  
  # Check tokens
  if [ -f "/app/config/tokens.json" ]; then
    echo "✅ Tokens found, copying..."
    cp /app/config/tokens.json /home/nodejs/.config/google-calendar-mcp/tokens.json
  fi
  
  # Start the server WITHOUT transport argument (use default)
  echo "Starting server on port 8001..."
  cd /app
  exec node build/index.js --port 8001
  
else
  echo "⚠️ WARNING: No credentials found in /app/config/"
  echo "Waiting for credentials..."
  
  while true; do
    sleep 60
    if [ -f "/app/config/gcp-oauth.keys.json" ]; then
      echo "✅ Credentials detected! Restarting..."
      exec "$0"
    fi
  done
fi
