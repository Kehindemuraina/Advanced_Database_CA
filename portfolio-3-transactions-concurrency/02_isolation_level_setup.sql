-- ============================================================================
-- LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
-- Portfolio 3: Task 2 - Isolation Level Demonstration Schema & Data
-- File: portfolio-3-transactions-concurrency/02_isolation_level_setup.sql
-- ============================================================================

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
