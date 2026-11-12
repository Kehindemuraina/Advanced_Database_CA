#!/usr/bin/env bash
# ============================================================================
# LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
# Portfolio 3: Transactions and Concurrency Master Runner
# ============================================================================

set -e

echo "======================================================================"
echo "RUNNING PORTFOLIO 3: TRANSACTIONS AND CONCURRENCY SUITE"
echo "======================================================================"

echo ""
echo "[1/3] Executing Task 1: Atomic Multi-Step Patient Referral & Rollback..."
psql -d lsphcb_emr -f portfolio-3-transactions-concurrency/01_atomic_referral_transaction.sql

echo ""
echo "[2/3] Executing Task 2: Isolation Levels & Race Conditions (Read Committed vs Repeatable Read)..."
./portfolio-3-transactions-concurrency/test_isolation.sh

echo ""
echo "[3/3] Executing Task 3: Row Locks, Deadlock Triggering & Ordered Resolution..."
./portfolio-3-transactions-concurrency/test_deadlock.sh

echo ""
echo "Portfolio 3 completed successfully."
