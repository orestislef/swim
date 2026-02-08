#!/bin/bash

# Swim College - Start Script
# Binds to 0.0.0.0 for network access

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Set host to 0.0.0.0 for network access
export HOST=0.0.0.0
export PORT=3000

# Check if already running
if pgrep -f "node.*server.js" > /dev/null; then
    echo "⚠️  Swim College is already running!"
    echo "   Stop it first: ./stop.sh"
    exit 1
fi

# Start the server
echo "🚀 Starting Swim College..."
npm start

echo "✅ Swim College is now accessible at:"
echo "   http://$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost"}):3000"
