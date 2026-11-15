#!/usr/bin/env bash
# Runner for Portfolio 3 concurrency and transaction suite

set -e

echo "--- Running Portfolio 3: Transactions and Concurrency Suite ---"

echo ""
echo "[1/3] Executing Task 1: Atomic Multi-Step Patient Referral & Rollback..."
psql -d lsphcb_emr -f portfolio-3-transactions-concurrency/Muraina_Kehinde_Portfolio_3_Atomic_Referral.sql

echo ""
echo "[2/3] Executing Task 2: Isolation Levels & Race Conditions (Read Committed vs Repeatable Read)..."
./portfolio-3-transactions-concurrency/Muraina_Kehinde_Portfolio_3_Test_Isolation.sh

echo ""
echo "[3/3] Executing Task 3: Row Locks, Deadlock Triggering & Ordered Resolution..."
./portfolio-3-transactions-concurrency/Muraina_Kehinde_Portfolio_3_Test_Deadlock.sh

echo ""
echo "Portfolio 3 completed successfully."
