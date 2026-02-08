#!/bin/bash

# Swim College - Stop Script

echo "🛑 Stopping Swim College..."

# Find and kill the node process
if pgrep -f "node.*server.js" > /dev/null; then
    pkill -f "node.*server.js"
    echo "✅ Swim College stopped successfully!"
else
    echo "⚠️  Swim College was not running."
fi

# Also kill any process on port 3000
if lsof -ti:3000 > /dev/null 2>&1; then
    kill -9 $(lsof -ti:3000) 2>/dev/null
    echo "✅ Process on port 3000 terminated!"
fi
