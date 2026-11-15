# Portfolio 2: Query Processing & Optimisation
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Lagos State Primary Health Care Board (LSPHCB) Electronic Medical Records System  
**Target RDBMS:** PostgreSQL 16+

---

## 1. Overview & Realistic Clinical Scope

In primary healthcare facilities across Lagos State (such as Alimosho PHC, Surulere Health Centre, and Kosofe PHC), **Malaria (Plasmodium falciparum, ICD-10: B54)** is the single most prevalent endemic presentation, comprising over 50% to 65% of all daily outpatient consultations. 

Every public PHC operates under guidelines from the Lagos State Ministry of Health and the Lagos State Malaria Elimination Programme (SMEP):
1. **Clinical Triage:** Patients present with acute pyrexia (body temperature > 38.5°C), rigors, severe headaches, bitter taste, and body aches.
2. **Laboratory Confirmation:** Before antimalarials are dispensed, clinicians must perform a **Malaria Rapid Diagnostic Test (mRDT)** (detecting *P. falciparum* histidine-rich protein 2 - HRP2) or a **Blood Film for Malaria Parasites (BF for MP)** microscopy.
3. **Evidence-Based Prescriptions:** Confirmed cases are treated with first-line **Artemisinin-based Combination Therapy (ACT)** (Artemether 80mg / Lumefantrine 480mg) and antipyretics (Paracetamol).
4. **Complications & Referrals:** Severe malaria cases presenting with extreme anemia (PCV < 20%), prostration, or dark urine are rapidly stabilized and referred to secondary General Hospitals.

In this portfolio component, we:
1. Implemented an advanced clinical surveillance query tracking **Quarterly Malaria Outbreak Cases (`ICD-10: B54`)** across Lagos PHCs using multi-table joins, CTEs, and window functions.
2. Formulated a multi-district aggregation query utilizing `GROUP BY` to monitor monthly child immunization vaccine batches across all Lagos LGAs.
3. Conducted `EXPLAIN (ANALYZE, BUFFERS)` execution plan profiling, identified sequential scan bottlenecks, built partial and composite B-tree indexes, and proved significant latency reductions.

---

## 2. Task 1: Endemic Malaria Surveillance Analytical Query (Fiscal Q1 2024)

### SQL Implementation (`Muraina_Kehinde_Portfolio_2_Malaria_Quarterly_Cases.sql`)
```sql
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
```

### Query Breakdown & Logic
1. **Multi-Table Relational Integration:** Gathers patient identification, triage vitals, doctor in charge, diagnosis, and facility location through standard `JOIN` operations.
2. **CTEs for 1-to-Many Relationships:** A patient encounter can have multiple lab tests (e.g. mRDT and PCV) or multiple prescribed medications. If joined naively, it duplicates patient rows. The CTEs pre-aggregate lab evidence and ACT prescriptions cleanly into single strings using `STRING_AGG()`.
3. **Window Functions vs GROUP BY:**
   - `ROW_NUMBER() OVER (PARTITION BY f.facility_id ...)`: Tells the Medical Officer in Charge at Alimosho PHC whether this patient was the 1st, 2nd, or 10th malaria case seen this quarter.
   - `COUNT(*) OVER (PARTITION BY f.lga)`: Displays the total district malaria load directly on every row for instant comparative epidemiological context.
   - `DENSE_RANK() OVER (ORDER BY e.visit_date)`: Assigns consecutive calendar ranks to encounter dates across the fiscal quarter.

---

## 3. Task 2: Monthly Immunization Aggregation Across LGAs

### SQL Implementation (`Muraina_Kehinde_Portfolio_2_Immunization_Aggregates.sql`)
```sql
SELECT 
    f.lga AS local_government_area,
    TO_CHAR(i.administration_date, 'YYYY-MM') AS administration_month,
    i.vaccine_name,
    i.batch_number,
    COUNT(i.immunization_id) AS total_doses_administered,
    COUNT(DISTINCT i.patient_id) AS unique_children_vaccinated,
    MIN(i.administration_date) AS first_dose_date,
    MAX(i.administration_date) AS last_dose_date
FROM immunization i
JOIN encounter e ON i.encounter_id = e.encounter_id
JOIN facility f ON e.facility_id = f.facility_id
GROUP BY 
    f.lga, 
    TO_CHAR(i.administration_date, 'YYYY-MM'),
    i.vaccine_name, 
    i.batch_number
ORDER BY 
    f.lga, 
    administration_month, 
    total_doses_administered DESC,
    i.vaccine_name;
```

### Operational Value in Lagos Health Logistics
- Enables the Lagos State cold-chain logistics team to track vaccine batch depletion per LGA.
- Comparing `COUNT(i.immunization_id)` with `COUNT(DISTINCT i.patient_id)` highlights immunization completion and multi-dose dropout rates (e.g., Pentavalent 1 to 3).

---

## 4. Task 3: Query Profiling, Bottlenecks & Indexing Optimization

### The Sequential Scan Bottleneck
When filtering large clinical databases on diagnosis codes (`d.icd10_code = 'B54'`) and date ranges without indexes, the database engine must inspect every table block sequentially (`Seq Scan`), checking every row and discarding non-matching entries.

### Targeted Indexing Strategies:

1. **Partial B-Tree Index on Predominant Diagnosis (Malaria ICD-10: B54):**
   ```sql
   CREATE INDEX idx_diagnosis_icd10_partial 
   ON diagnosis (encounter_id, icd10_code) 
   WHERE icd10_code = 'B54';
   ```
   *Why Partial?* Since malaria represents over 50% of acute cases, creating an index that only indexes `B54` keeps the index size minuscule, fits entirely into RAM, and incurs zero write-penalty when recording routine antenatal or dental encounters.

2. **Composite B-Tree Index on Encounter Date & Facility:**
   ```sql
   CREATE INDEX idx_encounter_date_facility 
   ON encounter (visit_date, facility_id);
   ```

3. **Foreign Key Indexes:**
   ```sql
   CREATE INDEX idx_diagnosis_encounter_id ON diagnosis (encounter_id);
   CREATE INDEX idx_immunization_encounter_id ON immunization (encounter_id);
   ```

### Execution Plan Comparison (`EXPLAIN ANALYZE`):
- **Unindexed Query:** Relies on sequential scans and nested loops across diagnosis and encounter tables, examining unneeded records.
- **Indexed Query:** PostgreSQL query planner transitions to a coordinated **Bitmap Index Scan** on `idx_encounter_date_facility` and `idx_diagnosis_icd10_partial`, slashing execution time and memory bus contention.

---

## 5. How to Run
```bash
./portfolio-2-query-optimisation/Muraina_Kehinde_Portfolio_2_Runner.sh
```
