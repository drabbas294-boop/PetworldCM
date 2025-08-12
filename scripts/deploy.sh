#!/usr/bin/env bash
set -euo pipefail

# Deployment script for PetworldCM
# Installs dependencies, builds client, runs migrations, and restarts server.

CLIENT_DIR="${CLIENT_DIR:-client}"
SERVER_DIR="${SERVER_DIR:-server}"
PM2_APP_NAME="${PM2_APP_NAME:-petworld-server}"

echo "Starting deployment for PetworldCM"

if [ ! -d "$SERVER_DIR" ] || [ ! -d "$CLIENT_DIR" ]; then
  echo "Expected directories '$SERVER_DIR' and '$CLIENT_DIR' not found."
  echo "Customize CLIENT_DIR and SERVER_DIR or create these folders."
  echo "No actions were performed."
  exit 0
fi

# Install dependencies for server and client
npm --prefix "$SERVER_DIR" ci
npm --prefix "$CLIENT_DIR" ci

# Run database migrations if available
if npm --prefix "$SERVER_DIR" run | grep -q '^  migrate'; then
  npm --prefix "$SERVER_DIR" run migrate
else
  echo "No migrate script in server package.json; skipping migrations."
fi

# Build client and move build output to server/public
npm --prefix "$CLIENT_DIR" run build
rm -rf "$SERVER_DIR/public"
cp -R "$CLIENT_DIR/build" "$SERVER_DIR/public"

# Restart server using PM2 if available
if command -v pm2 >/dev/null 2>&1; then
  pm2 restart "$PM2_APP_NAME" || pm2 start "$SERVER_DIR" --name "$PM2_APP_NAME"
else
  echo "pm2 not installed; start your server manually."
fi

echo "Deployment completed."
