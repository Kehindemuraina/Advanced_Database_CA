#!/usr/bin/env bash
# Deadlock test: Out-of-order locking vs deterministic ascending lock ordering

set -e

DB_NAME="lsphcb_emr"

echo "--- Demo 1: Triggering deadlock with out-of-order locks ---"

# Reset inventory table
psql -d "$DB_NAME" -f portfolio-3-transactions-concurrency/03_inventory_deadlock_setup.sql > /dev/null

# Session A locks Item 1, waits 1.5s, attempts to lock Item 2
# Session B locks Item 2, waits 1.5s, attempts to lock Item 1
# This creates a circular lock wait dependency.

(
    echo "--- Session A: Locking Item 1, then requesting Item 2 ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
SELECT 'Session A locked Item 1' AS log, inventory_id, stock_quantity 
FROM facility_inventory WHERE inventory_id = 1 FOR UPDATE;

SELECT pg_sleep(1.5);

SELECT 'Session A requesting Item 2...' AS log;
SELECT inventory_id, stock_quantity 
FROM facility_inventory WHERE inventory_id = 2 FOR UPDATE;

UPDATE facility_inventory SET stock_quantity = stock_quantity - 5 WHERE inventory_id IN (1, 2);
COMMIT;
SELECT 'Session A successfully finished' AS result;
EOF
) &
SESSION_A_PID=$!

sleep 0.5

(
    echo "--- Session B: Locking Item 2, then requesting Item 1 ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
SELECT 'Session B locked Item 2' AS log, inventory_id, stock_quantity 
FROM facility_inventory WHERE inventory_id = 2 FOR UPDATE;

SELECT pg_sleep(1.5);

SELECT 'Session B requesting Item 1...' AS log;
SELECT inventory_id, stock_quantity 
FROM facility_inventory WHERE inventory_id = 1 FOR UPDATE;

UPDATE facility_inventory SET stock_quantity = stock_quantity - 2 WHERE inventory_id IN (1, 2);
COMMIT;
SELECT 'Session B successfully finished' AS result;
EOF
) &
SESSION_B_PID=$!

# Wait for both sessions (one will fail with ERROR: deadlock detected)
wait $SESSION_A_PID || true
wait $SESSION_B_PID || true

echo ""
echo "--- Demo 2: Deadlock resolution with ordered locks (inventory_id ASC) ---"

# Reset inventory table
psql -d "$DB_NAME" -f portfolio-3-transactions-concurrency/03_inventory_deadlock_setup.sql > /dev/null

(
    echo "--- Session 1 (Dispensing Prescription): Locks Item 1 then Item 2 (ASC) ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
SELECT 'Session 1 acquiring locks in ascending order' AS log;
SELECT inventory_id, stock_quantity 
FROM facility_inventory 
WHERE inventory_id IN (1, 2) 
ORDER BY inventory_id ASC 
FOR UPDATE;

SELECT pg_sleep(1.5);

UPDATE facility_inventory SET stock_quantity = stock_quantity - 5 WHERE inventory_id = 1;
UPDATE facility_inventory SET stock_quantity = stock_quantity - 10 WHERE inventory_id = 2;
COMMIT;
SELECT 'Session 1 committed successfully' AS result;
EOF
) &
SESSION_1_PID=$!

sleep 0.5

(
    echo "--- Session 2 (Ward Replenishment): Also locks Item 1 then Item 2 (ASC) ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
SELECT 'Session 2 waiting smoothly in queue behind Session 1' AS log;
SELECT inventory_id, stock_quantity 
FROM facility_inventory 
WHERE inventory_id IN (1, 2) 
ORDER BY inventory_id ASC 
FOR UPDATE;

UPDATE facility_inventory SET stock_quantity = stock_quantity + 50 WHERE inventory_id = 1;
UPDATE facility_inventory SET stock_quantity = stock_quantity + 50 WHERE inventory_id = 2;
COMMIT;
SELECT 'Session 2 committed successfully without any deadlock' AS result;
EOF
) &
SESSION_2_PID=$!

wait $SESSION_1_PID
wait $SESSION_2_PID

echo ""
echo "Final inventory state after serialized safe execution:"
psql -d "$DB_NAME" -c "SELECT inventory_id, medication_id, stock_quantity, last_restocked FROM facility_inventory ORDER BY inventory_id;"

echo ""
echo "Deadlock demonstration completed."
