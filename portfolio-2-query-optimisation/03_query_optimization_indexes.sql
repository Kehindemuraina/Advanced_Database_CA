-- Indexing Strategies & Execution Plan Optimization

/*
 Description:
 Demonstrates execution plan analysis (EXPLAIN ANALYZE) before and after
 index creation, highlighting bottleneck resolution from sequential table scans
 to high-efficiency Index and Bitmap Index scans.
 Focus: Endemic Malaria (ICD-10: B54), the primary outpatient presentation in Lagos PHCs.
*/

-- Step 1: Explain plan BEFORE indexes
-- (Notice sequential scan on diagnosis filtering thousands of records)
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    e.encounter_id,
    e.visit_date,
    f.facility_name,
    d.icd10_code,
    d.diagnosis_description
FROM encounter e
JOIN facility f ON e.facility_id = f.facility_id
JOIN diagnosis d ON e.encounter_id = d.encounter_id
WHERE d.icd10_code = 'B54'
  AND e.visit_date >= '2024-01-01' 
  AND e.visit_date <= '2024-03-31'
ORDER BY e.visit_date;

-- Step 2: Create Targeted Indexing Strategies

-- Index A: Partial B-Tree index on Endemic Malaria (ICD-10: B54)
-- In Lagos Primary Healthcare, Malaria accounts for >50% of acute presentations.
-- A partial index on B54 provides lightning-fast lookups while keeping the index compact.
DROP INDEX IF EXISTS idx_diagnosis_icd10_partial;
CREATE INDEX idx_diagnosis_icd10_partial 
ON diagnosis (encounter_id, icd10_code) 
WHERE icd10_code = 'B54';

-- Index B: Composite B-Tree index on Encounter Date and Facility
-- Accelerates date-range queries joined with facility groupings.
DROP INDEX IF EXISTS idx_encounter_date_facility;
CREATE INDEX idx_encounter_date_facility 
ON encounter (visit_date, facility_id);

-- Index C: Foreign Key indexes on high-frequency join columns
DROP INDEX IF EXISTS idx_diagnosis_encounter_id;
CREATE INDEX idx_diagnosis_encounter_id 
ON diagnosis (encounter_id);

DROP INDEX IF EXISTS idx_immunization_encounter_id;
CREATE INDEX idx_immunization_encounter_id 
ON immunization (encounter_id);

-- Update statistics for the PostgreSQL query planner
ANALYZE encounter;
ANALYZE diagnosis;
ANALYZE immunization;

-- Step 3: Explain plan AFTER indexes
-- (Notice planner switches to Bitmap Index Scan and Index Scan, slashing cost)
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    e.encounter_id,
    e.visit_date,
    f.facility_name,
    d.icd10_code,
    d.diagnosis_description
FROM encounter e
JOIN facility f ON e.facility_id = f.facility_id
JOIN diagnosis d ON e.encounter_id = d.encounter_id
WHERE d.icd10_code = 'B54'
  AND e.visit_date >= '2024-01-01' 
  AND e.visit_date <= '2024-03-31'
ORDER BY e.visit_date;
