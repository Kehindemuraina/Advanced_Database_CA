-- LSPHCB EMR System - Portfolio 3: Transactions & Concurrency
-- Task 1: Atomic Multi-Step Patient Referral Process
-- Demonstrates atomicity: all steps commit together or roll back on error.

-- Scenario A: Successful atomic referral
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

-- Scenario B: Simulated constraint failure and rollback
-- Attempting illegal self-referral (violates chk_referral_facilities)
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


-- Task 2: Schema and seed data for appointment slot isolation tests

DROP TABLE IF EXISTS appointment_slot CASCADE;

CREATE TABLE appointment_slot (
    slot_id SERIAL PRIMARY KEY,
    facility_id INT NOT NULL REFERENCES facility(facility_id),
    clinic_type VARCHAR(60) NOT NULL,              -- e.g., 'Obstetric Ultrasound', 'Dental Specialist'
    appointment_date DATE NOT NULL,
    slot_number INT NOT NULL,
    patient_id INT NOT NULL REFERENCES patient(patient_id),
    booked_by_staff_id INT NOT NULL REFERENCES healthcare_worker(staff_id),
    booked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_facility_date_slot UNIQUE (facility_id, clinic_type, appointment_date, slot_number),
    CONSTRAINT chk_slot_limit CHECK (slot_number >= 1 AND slot_number <= 5)
);

-- Seed initial bookings for Ikeja Model PHC on 2024-07-01:
-- Capacity is 5 slots. Currently 4 slots are booked (Slots 1, 2, 3, 4).
INSERT INTO appointment_slot (facility_id, clinic_type, appointment_date, slot_number, patient_id, booked_by_staff_id)
VALUES 
(3, 'Obstetric Ultrasound', '2024-07-01', 1, 1, 5),
(3, 'Obstetric Ultrasound', '2024-07-01', 2, 2, 5),
(3, 'Obstetric Ultrasound', '2024-07-01', 3, 4, 6),
(3, 'Obstetric Ultrasound', '2024-07-01', 4, 7, 6);


-- Task 3: Clinic drug inventory setup for deadlock tests

DROP TABLE IF EXISTS facility_inventory CASCADE;

CREATE TABLE facility_inventory (
    inventory_id SERIAL PRIMARY KEY,
    facility_id INT NOT NULL REFERENCES facility(facility_id),
    medication_id INT NOT NULL REFERENCES medication(medication_id),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    reorder_level INT NOT NULL DEFAULT 50,
    last_restocked TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_facility_med UNIQUE (facility_id, medication_id)
);

-- Seed stock at Alimosho PHC (Facility 1):
-- Inventory Item 1: Ciprofloxacin 500mg (Medication 1)
-- Inventory Item 2: ACT Antimalarial (Medication 2)
INSERT INTO facility_inventory (facility_id, medication_id, stock_quantity, reorder_level)
VALUES 
(1, 1, 100, 20),
(1, 2, 150, 30);
