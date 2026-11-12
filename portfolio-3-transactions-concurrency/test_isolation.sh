#!/usr/bin/env bash
# ============================================================================
# LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
# Portfolio 3: Concurrency Isolation Level Test (Read Committed vs Repeatable Read)
# ============================================================================

set -e

DB_NAME="lsphcb_emr"

echo "======================================================================"
echo "TEST 1: CONCURRENT SESSIONS UNDER DEFAULT 'READ COMMITTED'"
echo "Demonstrating Phantom Read / Concurrent modification vulnerability"
echo "======================================================================"

# Reset appointment slots
psql -d "$DB_NAME" -f portfolio-3-transactions-concurrency/02_isolation_level_setup.sql > /dev/null

# Session 1 queries slots, sleeps 2 seconds, then queries again
# Concurrently, Session 2 inserts the 5th appointment slot after 1 second and commits.

(
    echo "--- [Session 1 (Clinician A)]: Starting READ COMMITTED transaction ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT 'Session 1 (First Read)' AS step, COUNT(*) AS booked_slots, (5 - COUNT(*)) AS available_slots
FROM appointment_slot 
WHERE facility_id = 3 AND clinic_type = 'Obstetric Ultrasound' AND appointment_date = '2024-07-01';

SELECT pg_sleep(2);

SELECT 'Session 1 (Second Read - After Session 2 committed)' AS step, COUNT(*) AS booked_slots, (5 - COUNT(*)) AS available_slots
FROM appointment_slot 
WHERE facility_id = 3 AND clinic_type = 'Obstetric Ultrasound' AND appointment_date = '2024-07-01';
COMMIT;
EOF
) &
SESSION_1_PID=$!

sleep 0.8

(
    echo "--- [Session 2 (Clinician B)]: Inserting 5th slot concurrently ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
INSERT INTO appointment_slot (facility_id, clinic_type, appointment_date, slot_number, patient_id, booked_by_staff_id)
VALUES (3, 'Obstetric Ultrasound', '2024-07-01', 5, 8, 5);
COMMIT;
SELECT 'Session 2: Successfully booked slot 5' AS status;
EOF
) &
SESSION_2_PID=$!

wait $SESSION_1_PID
wait $SESSION_2_PID

echo ""
echo "======================================================================"
echo "TEST 2: CONCURRENT SESSIONS UNDER 'REPEATABLE READ'"
echo "Demonstrating Snapshot Isolation preventing Phantom Reads"
echo "======================================================================"

# Reset appointment slots again
psql -d "$DB_NAME" -f portfolio-3-transactions-concurrency/02_isolation_level_setup.sql > /dev/null

(
    echo "--- [Session 1 (Clinician A)]: Starting REPEATABLE READ transaction ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT 'Session 1 (First Read)' AS step, COUNT(*) AS booked_slots, (5 - COUNT(*)) AS available_slots
FROM appointment_slot 
WHERE facility_id = 3 AND clinic_type = 'Obstetric Ultrasound' AND appointment_date = '2024-07-01';

SELECT pg_sleep(2);

SELECT 'Session 1 (Second Read - Snapshot Isolation preserved)' AS step, COUNT(*) AS booked_slots, (5 - COUNT(*)) AS available_slots
FROM appointment_slot 
WHERE facility_id = 3 AND clinic_type = 'Obstetric Ultrasound' AND appointment_date = '2024-07-01';
COMMIT;
EOF
) &
SESSION_1_PID=$!

sleep 0.8

(
    echo "--- [Session 2 (Clinician B)]: Inserting 5th slot concurrently ---"
    psql -d "$DB_NAME" << 'EOF'
BEGIN;
INSERT INTO appointment_slot (facility_id, clinic_type, appointment_date, slot_number, patient_id, booked_by_staff_id)
VALUES (3, 'Obstetric Ultrasound', '2024-07-01', 5, 8, 5);
COMMIT;
SELECT 'Session 2: Successfully booked slot 5' AS status;
EOF
) &
SESSION_2_PID=$!

wait $SESSION_1_PID
wait $SESSION_2_PID

echo ""
echo "Concurrency isolation test finished."
