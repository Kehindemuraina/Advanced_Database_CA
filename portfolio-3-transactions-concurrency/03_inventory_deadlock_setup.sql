-- ============================================================================
-- LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
-- Portfolio 3: Task 3 - Shared Facility Inventory Setup for Deadlock Testing
-- File: portfolio-3-transactions-concurrency/03_inventory_deadlock_setup.sql
-- ============================================================================

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
