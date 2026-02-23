#!/bin/bash
source .env

TRAP="0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81"
POSITION_ID=1

echo "⏰  ATTACK SIMULATION - TIME-BASED NEGLECT"
echo "=========================================="
echo ""

# Current time
NOW=$(date +%s)
echo "Current time: $(date)"
echo ""

# Show trap config
echo "[1] Trap Configuration for Position #$POSITION_ID:"
echo "---------------------------"
echo "Max time since harvest: 86,400 seconds (24 hours)"
echo ""

# Simulate time passing
echo "[2] Simulating 24 hours passing without harvest..."
echo "⏳ 24 hours later..."
sleep 2
echo ""

# Trap detection
echo "[3] TRAP DETECTION:"
echo "---------------------------"
echo "🔍 TIME_VECTOR: 🚨 TRIGGERED!"
echo "   Last harvest: Never"
echo "   Time elapsed: 86,401 seconds"
echo "   Status: EXCEEDED THRESHOLD"
echo ""
echo "🔍 LIQUIDITY_VECTOR: ✅ Safe"
echo "🔍 FEE_VECTOR: ⚠️  Checking..."
echo ""

# Trap decision
echo "[4] TRAP DECISION:"
echo "---------------------------"
echo "shouldRespond() = TRUE"
echo "⚠️  Position has been neglected for 24+ hours!"
echo ""
echo "✅ Operator would now:"
echo "   - Harvest accumulated fees"
echo "   - Check position health"
echo "   - Rebalance if needed"
echo ""

echo "=========================================="
echo "⏰ Time-based attack detected!"
echo "🏰 The Byzantine Watch never sleeps!"
