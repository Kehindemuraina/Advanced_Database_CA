# LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
## ADVANCED DATABASE SYSTEMS PORTFOLIO (MIT 8103)

### 1. Background & Overview
My name is Kehinde Muraina, a software developer based in Lagos, and for this Advanced Database Systems portfolio (MIT 8103), I am focusing on the Lagos State Primary Health Care Board (LSPHCB) Electronic Medical Records (EMR) system. 

As you know, managing primary healthcare across Lagos is serious business. LSPHCB coordinates primary healthcare services across public Primary Healthcare (PHC) facilities in Lagos State, handling everything from maternal and child health and routine immunizations to disease prevention and treatment. To make things smooth, the Lagos State Government introduced the Talamus EMR system to digitize operations across 100 PHC facilities, with plans to scale up to all 326 facilities in the state. 

### 2. The Core Problem Statement
Right now, managing patient information across multiple PHC facilities without a rock-solid, integrated database creates serious bottlenecks. We are talking about duplicated patient records, fragmented medical histories, wahala when trying to retrieve previous consultations, inconsistent documentation, and frustrating delays for patients. 

When a patient moves from a PHC in Alimosho to another one in Surulere or Ikeja, their medical history shouldn't get lost in translation. We need an optimized, relational database structure that ensures fast retrieval, rock-solid data integrity, secure access, and smooth information exchange across all facilities without crashing or lagging.

### 3. Existing System Summary
The current Talamus EMR platform captures patient and facility info across multiple operational modules, but the growing volume of data demands a superior database design to handle longitudinal patient records and multi-facility coordination. The major data areas captured include:
* Patient Registration Records: ID, registration date, full name, DOB, sex, address, phone number, category, and next of kin details.
* Patient Medical History: Previous illnesses, chronic conditions, surgical history, known allergies, hospital admissions, and family medical history.
* Visit & Clinical Encounters: Encounter ID, visit date/time, encounter type, facility, attending health worker, chief complaint, symptoms, examination findings, and ICD-10 diagnosis codes.
* Vital Signs: Blood pressure, temperature, pulse rate, respiratory rate, oxygen saturation (SpO2), weight, height, and BMI.
* Prescriptions & Pharmacy: Medication name, strength, dosage, frequency, duration, route, prescribing officer, and date.
* Laboratory & Diagnostics: Tests requested, specimen type, results, investigation dates, and imaging findings.
* Facility & Staff: Facility ID, name, LGA, address, staff ID, cadre, designation, and user access roles.
* Immunizations & Treatments: Vaccine name, dose, batch number, administration date, procedures performed, and outcomes.
* Referrals & Discharges: Referral ID, reasons, referring/receiving facilities, dates, discharge status, and follow-up instructions.

### 4. Proposed Optimized Relational Database Schema
To solve these challenges, our optimized relational database will organize information into clean, interconnected tables linked via proper primary and foreign keys:
1. Patient Table (`PatientID`, `RegistrationDate`, `FirstName`, `LastName`, `DOB`, `Sex`, `Address`, `Phone`, `Category`, `NextOfKin`)
2. Facility Table (`FacilityID`, `FacilityName`, `FacilityCode`, `LGA`, `Address`, `ContactInfo`)
3. Healthcare Worker Table (`StaffID`, `StaffName`, `ProfessionalCadre`, `Designation`, `FacilityID`, `UserRole`)
4. Medical History Table (`MedicalHistoryID`, `PatientID`, `PreviousIllnesses`, `ChronicConditions`, `SurgicalHistory`, `Allergies`, `FamilyHistory`)
5. Encounter Table (`EncounterID`, `PatientID`, `FacilityID`, `StaffID`, `VisitDate`, `VisitTime`, `EncounterType`, `ChiefComplaint`, `PresentingSymptoms`)
6. Vital Signs Table (`VitalSignsID`, `EncounterID`, `BP`, `Temperature`, `PulseRate`, `RespiratoryRate`, `SpO2`, `Weight`, `Height`, `BMI`)
7. Diagnosis Table (`DiagnosisID`, `EncounterID`, `DiagnosisDescription`, `ICD10Code`, `DiagnosisType`)
8. Prescription Table (`PrescriptionID`, `EncounterID`, `StaffID`, `PrescriptionDate`, `MedicationDetails`)
9. Medication Table (`MedicationID`, `MedicationName`, `Strength`, `Formulation`)
10. Laboratory Investigation Table (`InvestigationID`, `EncounterID`, `TestName`, `SpecimenType`, `TestResult`, `RequestDate`, `ResultDate`)
11. Immunization Table (`ImmunizationID`, `PatientID`, `EncounterID`, `VaccineName`, `Dose`, `BatchNumber`, `AdministrationDate`)
12. Referral Table (`ReferralID`, `EncounterID`, `ReferringFacility`, `ReceivingFacility`, `ReferralReason`, `ReferralDate`, `ReferralOutcome`)
13. Treatment and Procedure Table (`ProcedureID`, `EncounterID`, `ProcedurePerformed`, `TreatmentAdministered`, `DatePerformed`, `Outcome`)
14. Discharge Table (`DischargeID`, `EncounterID`, `DischargeDate`, `DischargeStatus`, `ClinicalOutcome`, `PatientDisposition`, `FollowUpInstructions`)

---

### 5. Portfolio Components & Deliverables Mapping

#### Portfolio 1: Database Design and Modelling (7 Marks)
* **Expected Deliverables:** Case study description, ER diagram, relational schema, keys, constraints, and normalisation explanation up to 3NF.
* **Explicit Tasks:**
  1. Build a complete ER diagram capturing entities like `Patient`, `Facility`, `HealthcareWorker`, `Encounter`, `VitalSigns`, `Diagnosis`, `Prescription`, and `LabInvestigation` with accurate cardinality.
  2. Map out a fully normalized relational schema, ensuring atomic attributes (1NF), removing partial dependencies (2NF), and eliminating transitive dependencies (3NF).
  3. Write SQL DDL scripts to create all tables with correct data types, primary keys, foreign keys (`ON DELETE CASCADE` / `RESTRICT`), and check constraints (e.g., ensuring `BMI > 0` and positive blood pressure values).

#### Portfolio 2: Query Processing and Optimisation (7 Marks)
* **Expected Deliverables:** Complex SQL queries, query results, execution plans, indexing strategies, and performance analysis.
* **Explicit Tasks:**
  1. Write an advanced SQL query using multi-table joins, subqueries, and window functions to **fetch all patient records diagnosed with typhoid illness across multiple PHC facilities within a specific fiscal quarter**, ordered by visit date.
  2. Implement a query utilizing `GROUP BY` and aggregate functions to **calculate the monthly total number of immunization doses administered per vaccine batch across all Lagos State local government areas (LGAs)**.
  3. Generate and analyze execution plans (`EXPLAIN ANALYZE`) for high-cost queries, spot sequential scan bottlenecks, and build composite B-tree or partial indexes to speed up data retrieval.

#### Portfolio 3: Transactions and Concurrency (7 Marks)
* **Expected Deliverables:** Transaction scripts showing explicit `COMMIT` and `ROLLBACK`, isolation level tests, concurrency control analysis, and output screenshots.
* **Explicit Tasks:**
  1. Write a transaction script simulating an **atomic multi-step patient referral process** (simultaneously inserting a referral record in the `Referral` table, updating the patient's `Encounter` discharge status, and logging resource transfer), executing a `ROLLBACK` if any step fails.
  2. Demonstrate isolation levels (e.g., Read Committed vs. Repeatable Read) by running concurrent transactions to prevent race conditions like **phantom reads when two medical personnel simultaneously query available daily slots for a specialist appointment**.
  3. Analyze locking mechanisms and deadlock scenarios when updating shared facility inventory or high-frequency patient records.

#### Portfolio 4: NoSQL and Advanced Data Models (7 Marks)
* **Expected Deliverables:** NoSQL data model based on the EMR case study (document store), implementation evidence, and a comparative architectural suitability explanation.
* **Explicit Tasks:**
  1. Design a JSON/BSON document schema in MongoDB for a **Patient Health Profile** that embeds historical vital signs, active prescriptions, and lab results within a single document to avoid deep JOIN overhead.
  2. Implement CRUD operations in MongoDB to **query and update a patient's longitudinal clinical timeline and vaccination history** in real time.
  3. Provide a comparative architectural analysis weighing when to use relational databases (for strict ACID compliance in medical billing and records) versus NoSQL models (for flexible semi-structured clinical notes or real-time telemetry).

#### Portfolio 5: Distributed and Cloud Database Exercise (6 Marks)
* **Expected Deliverables:** Distributed or cloud database design, covering replication, sharding, high availability, consistency models, or deployment evidence.
* **Explicit Tasks:**
  1. Design a distributed database topology for LSPHCB to synchronize records across 100+ PHC facilities, using **database replication (primary-replica architecture)** to guarantee high availability during regional network downtimes.
  2. Configure horizontal partitioning (**sharding**) strategies based on facility location or LGA to distribute heavy query loads across regional cloud database nodes.
  3. Discuss CAP theorem trade-offs for the EMR system, specifically balancing consistency (making sure lab results are identical everywhere) with availability during emergency medical interventions across remote centers.

#### Final Documentation & Technical Reflection (6 Marks)
* **Expected Deliverables:** A 3-page technical summary, GitHub repository link (`advanced-database-portfolio/`), screenshots, individual technical reflection, and an AI-use declaration.
* **Explicit Tasks:**
  1. Organize and populate the GitHub repository with clean folders (`portfolio-1-database-design/` through `portfolio-5-distributed-cloud/`) containing clean SQL scripts, NoSQL JSON schemas, and configuration logs.
  2. Draft a comprehensive 3-page technical report summarizing design choices, indexing strategies, concurrency handling, and cloud deployment challenges.
  3. Write a personal technical reflection detailing lessons learned, performance trade-offs encountered, and a signed AI-use declaration showing how auxiliary tools were vetted.
