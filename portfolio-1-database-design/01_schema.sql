-- Active: 1794340814463@@127.0.0.1@5432@clinic@public
-- Drop tables if exist (in reverse dependency order)
DROP TABLE IF EXISTS discharge CASCADE;
DROP TABLE IF EXISTS treatment_procedure CASCADE;
DROP TABLE IF EXISTS referral CASCADE;
DROP TABLE IF EXISTS immunization CASCADE;
DROP TABLE IF EXISTS lab_investigation CASCADE;
DROP TABLE IF EXISTS prescription CASCADE;
DROP TABLE IF EXISTS medication CASCADE;
DROP TABLE IF EXISTS diagnosis CASCADE;
DROP TABLE IF EXISTS vital_signs CASCADE;
DROP TABLE IF EXISTS encounter CASCADE;
DROP TABLE IF EXISTS medical_history CASCADE;
DROP TABLE IF EXISTS healthcare_worker CASCADE;
DROP TABLE IF EXISTS facility CASCADE;
DROP TABLE IF EXISTS patient CASCADE;

DROP TABLE IF EXISTS facility_transfer_audit CASCADE;

CREATE TABLE facility (
    facility_id SERIAL PRIMARY KEY,
    facility_name VARCHAR(150) NOT NULL,
    facility_code VARCHAR(20) NOT NULL UNIQUE,
    lga VARCHAR(80) NOT NULL,
    address TEXT NOT NULL,
    contact_info VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE healthcare_worker (
    staff_id SERIAL PRIMARY KEY,
    staff_name VARCHAR(120) NOT NULL,
    professional_cadre VARCHAR(80) NOT NULL,
    designation VARCHAR(80) NOT NULL,
    facility_id INT NOT NULL,
    user_role VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_worker_facility FOREIGN KEY (facility_id)
        REFERENCES facility (facility_id) ON DELETE RESTRICT
);

CREATE TABLE patient (
    patient_id SERIAL PRIMARY KEY,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    dob DATE NOT NULL,
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F', 'O')),
    address TEXT NOT NULL,
    phone VARCHAR(25) NOT NULL,
    category VARCHAR(50) NOT NULL DEFAULT 'General',
    next_of_kin TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_patient_dob CHECK (dob <= CURRENT_DATE)
);

CREATE TABLE medical_history (
    medical_history_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    previous_illnesses TEXT,
    chronic_conditions TEXT,
    surgical_history TEXT,
    allergies TEXT,
    family_history TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_history_patient FOREIGN KEY (patient_id)
        REFERENCES patient (patient_id) ON DELETE CASCADE
);

CREATE TABLE encounter (
    encounter_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    facility_id INT NOT NULL,
    staff_id INT NOT NULL,
    visit_date DATE NOT NULL DEFAULT CURRENT_DATE,
    visit_time TIME NOT NULL DEFAULT CURRENT_TIME,
    encounter_type VARCHAR(50) NOT NULL,
    chief_complaint TEXT NOT NULL,
    presenting_symptoms TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'In-Progress',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_encounter_patient FOREIGN KEY (patient_id)
        REFERENCES patient (patient_id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounter_facility FOREIGN KEY (facility_id)
        REFERENCES facility (facility_id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounter_staff FOREIGN KEY (staff_id)
        REFERENCES healthcare_worker (staff_id) ON DELETE RESTRICT
);

CREATE TABLE vital_signs (
    vital_signs_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    systolic_bp INT NOT NULL,
    diastolic_bp INT NOT NULL,
    temperature NUMERIC(4, 1) NOT NULL,
    pulse_rate INT NOT NULL,
    respiratory_rate INT NOT NULL,
    spo2 NUMERIC(4, 1) NOT NULL,
    weight NUMERIC(5, 2) NOT NULL,
    height NUMERIC(5, 2) NOT NULL,
    bmi NUMERIC(5, 2) NOT NULL, -- calculated: weight / (height / 100) ^ 2
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vitals_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE,
    -- Healthcare validity check constraints:
    CONSTRAINT chk_systolic_bp CHECK (systolic_bp > 40 AND systolic_bp < 300),
    CONSTRAINT chk_diastolic_bp CHECK (diastolic_bp > 20 AND diastolic_bp < 200),
    CONSTRAINT chk_temperature CHECK (temperature >= 30.0 AND temperature <= 45.0),
    CONSTRAINT chk_pulse_rate CHECK (pulse_rate > 20 AND pulse_rate < 250),
    CONSTRAINT chk_respiratory_rate CHECK (respiratory_rate > 5 AND respiratory_rate < 80),
    CONSTRAINT chk_spo2 CHECK (spo2 >= 0.0 AND spo2 <= 100.0),
    CONSTRAINT chk_weight CHECK (weight > 0.0),
    CONSTRAINT chk_height CHECK (height > 0.0),
    CONSTRAINT chk_bmi CHECK (bmi > 0.0)
);

CREATE TABLE diagnosis (
    diagnosis_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    diagnosis_description TEXT NOT NULL,
    icd10_code VARCHAR(20) NOT NULL,
    diagnosis_type VARCHAR(40) NOT NULL DEFAULT 'Provisional',
    diagnosed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_diagnosis_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE
);

CREATE TABLE medication (
    medication_id SERIAL PRIMARY KEY,
    medication_name VARCHAR(120) NOT NULL,
    strength VARCHAR(50) NOT NULL,
    formulation VARCHAR(50) NOT NULL,
    category VARCHAR(80) DEFAULT 'Essential Drug'
);

CREATE TABLE prescription (
    prescription_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    medication_id INT NOT NULL,
    staff_id INT NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    route VARCHAR(50) NOT NULL DEFAULT 'Oral',
    prescription_date DATE NOT NULL DEFAULT CURRENT_DATE,
    instructions TEXT,
    CONSTRAINT fk_prescription_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE,
    CONSTRAINT fk_prescription_medication FOREIGN KEY (medication_id)
        REFERENCES medication (medication_id) ON DELETE RESTRICT,
    CONSTRAINT fk_prescription_staff FOREIGN KEY (staff_id)
        REFERENCES healthcare_worker (staff_id) ON DELETE RESTRICT
);

CREATE TABLE lab_investigation (
    investigation_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    test_name VARCHAR(120) NOT NULL,
    specimen_type VARCHAR(60) NOT NULL,
    test_result TEXT,
    request_date DATE NOT NULL DEFAULT CURRENT_DATE,
    result_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_lab_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE,
    CONSTRAINT chk_lab_dates CHECK (result_date IS NULL OR result_date >= request_date)
);

CREATE TABLE immunization (
    immunization_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    encounter_id INT,
    vaccine_name VARCHAR(100) NOT NULL,
    dose VARCHAR(30) NOT NULL,
    batch_number VARCHAR(50) NOT NULL,
    administration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    site_administered VARCHAR(60),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_immunization_patient FOREIGN KEY (patient_id)
        REFERENCES patient (patient_id) ON DELETE RESTRICT,
    CONSTRAINT fk_immunization_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE SET NULL
);

CREATE TABLE referral (
    referral_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    referring_facility_id INT NOT NULL,
    receiving_facility_id INT NOT NULL,
    referral_reason TEXT NOT NULL,
    referral_date DATE NOT NULL DEFAULT CURRENT_DATE,
    referral_outcome VARCHAR(80) DEFAULT 'Referred to Secondary Facility',
    urgency_level VARCHAR(30) DEFAULT 'Routine',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_referral_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE RESTRICT,
    CONSTRAINT fk_referral_from_facility FOREIGN KEY (referring_facility_id)
        REFERENCES facility (facility_id) ON DELETE RESTRICT,
    CONSTRAINT fk_referral_to_facility FOREIGN KEY (receiving_facility_id)
        REFERENCES facility (facility_id) ON DELETE RESTRICT,
    CONSTRAINT chk_referral_facilities CHECK (referring_facility_id <> receiving_facility_id)
);

CREATE TABLE treatment_procedure (
    procedure_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL,
    procedure_performed VARCHAR(150) NOT NULL,
    treatment_administered TEXT NOT NULL,
    date_performed DATE NOT NULL DEFAULT CURRENT_DATE,
    outcome TEXT NOT NULL,
    CONSTRAINT fk_procedure_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE
);

CREATE TABLE discharge (
    discharge_id SERIAL PRIMARY KEY,
    encounter_id INT NOT NULL UNIQUE,              -- One discharge per encounter
    discharge_date DATE NOT NULL DEFAULT CURRENT_DATE,
    discharge_status VARCHAR(50) NOT NULL,         -- 'Discharged Home', 'Referred', 'Absconded'
    clinical_outcome TEXT NOT NULL,                -- e.g., 'Condition Improved', 'Stable'
    patient_disposition TEXT NOT NULL,
    follow_up_instructions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_discharge_encounter FOREIGN KEY (encounter_id)
        REFERENCES encounter (encounter_id) ON DELETE CASCADE
);

CREATE TABLE facility_transfer_audit (
    transfer_audit_id SERIAL PRIMARY KEY,
    referral_id INT NOT NULL,
    transfer_status VARCHAR(50) NOT NULL,          -- e.g., 'Initiated', 'Handed Over', 'Received'
    notes TEXT,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_referral FOREIGN KEY (referral_id)
        REFERENCES referral (referral_id) ON DELETE CASCADE
);
