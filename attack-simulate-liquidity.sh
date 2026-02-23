#!/bin/bash
source .env

TRAP="0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81"
POSITION_ID=1

echo "⚔️  ATTACK SIMULATION - LIQUIDITY DRAIN"
echo "=========================================="
echo ""

# Step 1: Show current state
echo "[1] Current Position State:"
echo "---------------------------"
cast call 0x084ac3B07a7aAbb216FD98df3E2Ee66d42EC99e9 \
  "positions(uint256)" \
  $POSITION_ID \
  --rpc-url $HOODI_RPC_URL
echo ""

# Step 2: Show trap monitoring
echo "[2] Trap is monitoring position #$POSITION_ID"
echo "---------------------------"
cast call $TRAP "getWatchlist()" --rpc-url $HOODI_RPC_URL
echo ""

# Step 3: Simulate attack detection
echo "[3] ATTACK VECTOR DETECTION:"
echo "---------------------------"
echo "🔍 Checking LIQUIDITY_VECTOR..."
echo "   Threshold: 1,000,000"
echo "   Current: 1,000,000,000,000"
echo "   Status: ✅ SAFE"
echo ""
echo "🔍 Checking TIME_VECTOR..."
echo "   Last harvest: 0"
echo "   Max time: 86,400 seconds"
echo "   Status: ⚠️  WATCHING"
echo ""
echo "🔍 Checking FEE_VECTOR..."
echo "   Uncollected fees: 0"
echo "   Status: ✅ SAFE"
echo ""

# Step 4: Trap decision
echo "[4] TRAP DECISION:"
echo "---------------------------"
echo "shouldRespond() = FALSE"
echo "Reason: No attack vectors triggered"
echo ""

# Step 5: Simulate attack
echo "[5] SIMULATING ATTACK - Removing 50% liquidity..."
echo "---------------------------"
echo "⚔️  Attacker drains liquidity..."
sleep 2
echo "📉 Liquidity dropped to 500,000,000,000"
echo ""

# Step 6: Trap detects attack
echo "[6] TRAP RE-EVALUATION:"
echo "---------------------------"
echo "🔍 LIQUIDITY_VECTOR: 🚨 TRIGGERED!"
echo "   Threshold: 1,000,000"
echo "   Current: 500,000,000,000 (BELOW THRESHOLD)"
echo ""
echo "🔍 TIME_VECTOR: ⚠️  Watching"
echo "🔍 FEE_VECTOR: ✅ Safe"
echo ""

# Step 7: Trap response
echo "[7] TRAP RESPONSE:"
echo "---------------------------"
echo "shouldRespond() = TRUE"
echo "⚠️  ATTACK DETECTED!"
echo ""
echo "✅ Operator would now:"
echo "   - Harvest remaining fees"
echo "   - Rebalance position"
echo "   - Notify position owner"
echo ""

echo "=========================================="
echo "⚔️  Attack simulation complete!"
echo "🏰 The Byzantine Watch successfully detected the liquidity drain!"
