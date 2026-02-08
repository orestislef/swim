#!/bin/bash

# Swim College - Start Script
# Binds to 0.0.0.0 for network access
# Compatible with macOS and Linux

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

# Get IP address (macOS compatible)
if [[ "$OSTYPE" == "darwin"* ]]; then
    IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "localhost")
else
    IP_ADDR=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")
fi

# Start the server
echo "🚀 Starting Swim College..."
npm start

echo ""
echo "✅ Swim College is now accessible at:"
echo "   http://${IP_ADDR}:3000"
echo ""
echo "   Or locally: http://localhost:3000"
