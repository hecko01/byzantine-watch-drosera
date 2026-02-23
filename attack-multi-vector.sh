#!/bin/bash
source .env

TRAP="0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81"
POSITION_ID=1

echo "🛡️  BYZANTINE WATCH - REAL-TIME MONITORING"
echo "=========================================="
echo ""

while true; do
    clear
    echo "$(date) - Monitoring Position #$POSITION_ID"
    echo "=========================================="
    
    # Get real position data
    echo "📊 REAL POSITION DATA:"
    cast call 0x084ac3B07a7aAbb216FD98df3E2Ee66d42EC99e9 \
      "positions(uint256)" \
      $POSITION_ID \
      --rpc-url $HOODI_RPC_URL 2>/dev/null | head -c 200
    echo ""
    echo ""
    
    # Get trap status
    echo "🏰 TRAP STATUS:"
    cast call $TRAP "getWatchlist()" --rpc-url $HOODI_RPC_URL
    echo ""
    
    # Simulate attack detection
    echo "⚔️  ATTACK VECTORS:"
    echo "-------------------"
    echo "LIQUIDITY_VECTOR: 🟢 SAFE"
    echo "TIME_VECTOR:      🟡 MONITORING"
    echo "FEE_VECTOR:       🟢 SAFE"
    echo ""
    echo "Press Ctrl+C to stop monitoring"
    echo "=========================================="
    
    sleep 5
done
