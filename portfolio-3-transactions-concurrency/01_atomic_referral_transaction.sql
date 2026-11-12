-- ============================================================================
-- LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
-- Portfolio 3: Task 1 - Atomic Multi-Step Patient Referral Process
-- File: portfolio-3-transactions-concurrency/01_atomic_referral_transaction.sql
-- ============================================================================
-- Description:
-- Demonstrates transaction atomicity (ACID). When referring a patient:
-- 1. Insert referral record in `referral`
-- 2. Update patient's `encounter` status to 'Referred'
-- 3. Insert audit log in `facility_transfer_audit`
-- If any step fails, the entire transaction is rolled back with no partial writes.
-- ============================================================================

-- ============================================================================
-- SCENARIO A: SUCCESSFUL ATOMIC REFERRAL (COMMITTED)
-- ============================================================================
\echo '>>> SCENARIO A: Executing successful atomic referral transaction...'

BEGIN;

-- Check initial state
SELECT encounter_id, patient_id, facility_id, status 
FROM encounter 
WHERE encounter_id = 1;

-- Multi-step atomic execution using CTE to capture generated referral ID safely
WITH new_referral AS (
    INSERT INTO referral (
        encounter_id, 
        referring_facility_id, 
        receiving_facility_id, 
        referral_reason, 
        urgency_level
    )
    VALUES (
        1, 
        1,  -- Alimosho PHC
        3,  -- Ikeja Model PHC
        'Severe pyrexia unresponsive to oral antibiotics; transfer for inpatient observation', 
        'Urgent'
    )
    RETURNING referral_id
),
updated_encounter AS (
    UPDATE encounter
    SET status = 'Referred'
    WHERE encounter_id = 1
    RETURNING encounter_id
)
INSERT INTO facility_transfer_audit (referral_id, transfer_status, notes)
SELECT 
    referral_id, 
    'Ambulance Dispatched', 
    'LSPHCB Ambulance LAS-04 dispatched with nurse escort'
FROM new_referral;

-- Explicitly commit the transaction
COMMIT;

\echo '>>> Verified committed state:'
SELECT 
    e.encounter_id, 
    e.status AS encounter_status, 
    r.referral_id, 
    r.referring_facility_id, 
    r.receiving_facility_id, 
    r.urgency_level, 
    a.transfer_status, 
    a.notes
FROM encounter e
JOIN referral r ON e.encounter_id = r.encounter_id
JOIN facility_transfer_audit a ON r.referral_id = a.referral_id
WHERE e.encounter_id = 1;

-- ============================================================================
-- SCENARIO B: SIMULATED TRANSACTION FAILURE & ROLLBACK
-- Attempting illegal self-referral (violating chk_referral_facilities)
-- ============================================================================
\echo ''
\echo '>>> SCENARIO B: Demonstrating explicit rollback on constraint failure...'

-- Note encounter status before failed transaction
SELECT encounter_id, status FROM encounter WHERE encounter_id = 4;

BEGIN;

-- Step 1: Update encounter status in transaction buffer
UPDATE encounter 
SET status = 'Referred' 
WHERE encounter_id = 4;

-- Step 2: Attempt illegal referral to the same facility (Facility 4 to Facility 4)
-- This violates CHECK constraint: chk_referral_facilities (referring_facility_id <> receiving_facility_id)
SAVEPOINT before_illegal_referral;

INSERT INTO referral (
    encounter_id, 
    referring_facility_id, 
    receiving_facility_id, 
    referral_reason
)
VALUES (
    4, 
    4, 
    4, 
    'Illegal self-referral to same clinic'
);

-- In case of failure, roll back to preserve atomicity
ROLLBACK;

\echo '>>> State after ROLLBACK (encounter status remains intact):'
SELECT encounter_id, status 
FROM encounter 
WHERE encounter_id = 4;
