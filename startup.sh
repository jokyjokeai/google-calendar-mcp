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
  
  # Start the server with HTTP transport
  echo "Starting server on port 8001 with HTTP transport..."
  cd /app
  exec node build/index.js --transport http --port 8001 --host 0.0.0.0
  
else
  echo "⚠️ WARNING: No credentials found in /app/config/"
  echo "The server needs gcp-oauth.keys.json to start."
  echo "Please upload the credentials to the volume."
  echo ""
  echo "Keeping container alive for credential upload..."
  
  # Keep container running without crashing
  while true; do
    sleep 60
    echo "Waiting for credentials in /app/config/gcp-oauth.keys.json..."
    
    # Check if credentials appeared
    if [ -f "/app/config/gcp-oauth.keys.json" ]; then
      echo "✅ Credentials detected! Restarting..."
      exec "$0"
    fi
  done
fi
