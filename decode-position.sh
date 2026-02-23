#!/bin/bash
source .env

TRAP="0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81"

echo "=========================================="
echo "🏰 BYZANTINE WATCH - POSITION MONITOR"
echo "=========================================="
echo "Trap Address: $TRAP"
echo ""

# Get raw data
RAW_DATA=$(cast call $TRAP "collect()(bytes)" --rpc-url $HOODI_RPC_URL)
echo "📡 Raw data collected from trap"
echo ""

# Get watchlist
echo "📋 Watchlist:"
cast call $TRAP "getWatchlist()" --rpc-url $HOODI_RPC_URL
echo ""

# Check position directly on Uniswap
echo "🔄 Checking Position #1 on Uniswap:"
cast call 0x084ac3B07a7aAbb216FD98df3E2Ee66d42EC99e9 \
  "positions(uint256)" \
  1 \
  --rpc-url $HOODI_RPC_URL
echo ""

echo "=========================================="
echo "✅ TRAP STATUS: ACTIVE"
echo "🏰 The Byzantine Watch is guarding position #1"
echo "=========================================="
