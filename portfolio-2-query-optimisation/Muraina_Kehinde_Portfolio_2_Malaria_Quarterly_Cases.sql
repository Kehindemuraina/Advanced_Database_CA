-- Active: 1794340814463@@127.0.0.1@5432@clinic@public
--Query 1 - Endemic Malaria Case Surveillance & Outbreak Analytics

/*
Clinical Context:
In Lagos State Primary Health Care Centres (PHCs), Plasmodium falciparum 
malaria accounts for over 50-65% of daily outpatient consultations. 
The Lagos State Ministry of Health & Lagos State Malaria Elimination Programme 
(SMEP) requires quarterly surveillance reports integrating mRDT laboratory 
confirmation, triage vitals, and ACT medication tracking.

Query Features:
1. Multi-Table Joins across 6 relational entities.
2. Common Table Expressions (CTEs) aggregating mRDT & Blood Film lab results.
3. Window functions:
   ROW_NUMBER() partitioning by facility
   COUNT(*) partitioning by LGA
   DENSE_RANK() ordering by visit date across the fiscal quarter
4. Ordered by visit date and time.
*/

WITH confirmed_malaria_labs AS (
    -- Subquery / CTE: Aggregates Rapid Diagnostic Tests (mRDT) and microscopy
    SELECT 
        encounter_id,
        STRING_AGG(CONCAT(test_name, ': ', test_result), ' | ') AS lab_evidence
    FROM lab_investigation
    WHERE test_name ILIKE '%mRDT%' 
       OR test_name ILIKE '%Malaria%' 
       OR test_name ILIKE '%Blood Film%'
    GROUP BY encounter_id
),
act_prescriptions AS (
    -- Subquery / CTE: Identifies first-line Artemisinin Combination Therapy (ACT) dispensed
    SELECT 
        pr.encounter_id,
        STRING_AGG(CONCAT(m.medication_name, ' (', pr.dosage, ', ', pr.duration, ')'), '; ') AS act_regimen
    FROM prescription pr
    JOIN medication m ON pr.medication_id = m.medication_id
    WHERE m.category ILIKE '%Antimalarial%' 
       OR m.medication_name ILIKE '%Artemether%'
    GROUP BY pr.encounter_id
)
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.dob,
    p.sex,
    p.category AS patient_category,
    f.facility_name,
    f.lga AS facility_lga,
    hw.staff_name AS attending_clinician,
    e.encounter_id,
    e.visit_date,
    e.visit_time,
    d.icd10_code,
    d.diagnosis_description,
    vs.temperature AS body_temp_c,
    vs.systolic_bp || '/' || vs.diastolic_bp AS bp_reading,
    COALESCE(cml.lab_evidence, 'Clinical Diagnosis / Pending mRDT') AS mrdt_lab_confirmation,
    COALESCE(act.act_regimen, 'No Antimalarial Prescribed') AS antimalarial_treatment,
    -- Window Function 1: Rank presentation sequence inside each facility
    ROW_NUMBER() OVER (
        PARTITION BY f.facility_id 
        ORDER BY e.visit_date, e.visit_time
    ) AS facility_quarterly_case_seq,
    -- Window Function 2: Total malaria burden in this LGA during the fiscal quarter
    COUNT(*) OVER (
        PARTITION BY f.lga
    ) AS total_lga_quarterly_malaria_burden,
    -- Window Function 3: Chronological calendar day rank across the entire state
    DENSE_RANK() OVER (
        ORDER BY e.visit_date
    ) AS fiscal_quarter_day_rank
FROM encounter e
JOIN patient p ON e.patient_id = p.patient_id
JOIN facility f ON e.facility_id = f.facility_id
JOIN healthcare_worker hw ON e.staff_id = hw.staff_id
JOIN diagnosis d ON e.encounter_id = d.encounter_id
LEFT JOIN vital_signs vs ON e.encounter_id = vs.encounter_id
LEFT JOIN confirmed_malaria_labs cml ON e.encounter_id = cml.encounter_id
LEFT JOIN act_prescriptions act ON e.encounter_id = act.encounter_id
WHERE (d.icd10_code = 'B54' OR d.diagnosis_description ILIKE '%Malaria%')
  AND e.visit_date >= '2024-01-01' 
  AND e.visit_date <= '2024-03-31'
ORDER BY e.visit_date, e.visit_time;
