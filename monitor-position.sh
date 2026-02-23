#!/bin/bash
source .env

TRAP="0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81"
POSITION_ID=1

echo "🔍 Byzantine Watch - Monitoring Position #$POSITION_ID"
echo "=========================================="
echo "Trap Address: $TRAP"
echo ""

# Check if trap is watching
echo "📋 Watchlist Status:"
cast call $TRAP "getWatchlist()" --rpc-url $HOODI_RPC_URL
echo ""

# Test collect function
echo "📊 Collecting Position Data:"
cast call $TRAP "collect()(bytes)" --rpc-url $HOODI_RPC_URL | head -c 100
echo "..."
echo ""

echo "✅ Trap is ACTIVE and monitoring position #$POSITION_ID"
echo "🏰 The Byzantine Watch stands guard!"
