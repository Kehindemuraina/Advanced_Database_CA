BEGIN;

-- 1. Facilities
INSERT INTO facility (facility_name, facility_code, lga, address, contact_info) VALUES
('Alimosho Primary Healthcare Centre', 'PHC-ALM-001', 'Alimosho', '12 Council Road, Ikotun, Lagos', '+234-802-111-0001'),
('Surulere Comprehensive Health Centre', 'PHC-SUR-002', 'Surulere', 'Akerele Street, Surulere, Lagos', '+234-802-111-0002'),
('Ikeja Model Primary Healthcare Centre', 'PHC-IKJ-003', 'Ikeja', 'Wemimo Street, Ikeja, Lagos', '+234-802-111-0003'),
('Lagos Island Maternal & Child Centre', 'PHC-ISL-004', 'Lagos Island', 'Broad Street, Lagos Island, Lagos', '+234-802-111-0004'),
('Ikorodu Comprehensive PHC', 'PHC-IKD-005', 'Ikorodu', 'Ayangburen Road, Ikorodu, Lagos', '+234-802-111-0005'),
('Mushin Primary Healthcare Centre', 'PHC-MSH-006', 'Mushin', 'Palm Avenue, Mushin, Lagos', '+234-802-111-0006'),
('Kosofe Primary Healthcare Centre', 'PHC-KOS-007', 'Kosofe', 'Ogudu Road, Ojota, Lagos', '+234-802-111-0007'),
('Eti-Osa Primary Health Centre', 'PHC-ETI-008', 'Eti-Osa', 'Ajah Junction, Lekki-Epe Exp, Lagos', '+234-802-111-0008');

-- 2. Healthcare Workers
INSERT INTO healthcare_worker (staff_name, professional_cadre, designation, facility_id, user_role) VALUES
('Dr. Babatunde Fashola', 'Medical Officer', 'Principal Medical Officer', 1, 'Clinician'),
('Nurse Folashade Adeleke', 'Nurse', 'Chief Nursing Officer', 1, 'Clinician'),
('Dr. Chioma Okonkwo', 'Medical Officer', 'Senior Medical Officer', 2, 'Clinician'),
('Pharm. Kelechi Nwosu', 'Pharmacist', 'Lead Pharmacist', 2, 'Pharmacist'),
('Dr. Olumide Bakare', 'Medical Officer', 'Medical Officer', 3, 'Clinician'),
('CHEW Fatima Garba', 'CHEW', 'Community Health Supervisor', 3, 'Clinician'),
('Dr. Amina Danjuma', 'Medical Officer', 'Senior Medical Officer', 4, 'Clinician'),
('Nurse Yetunde Balogun', 'Nurse', 'Senior Nursing Officer', 5, 'Clinician'),
('Dr. Emeka Eze', 'Medical Officer', 'Medical Officer', 6, 'Clinician'),
('CHEW Segun Oladipo', 'CHEW', 'Community Health Extension Worker', 7, 'Clinician');

-- 3. Patients
INSERT INTO patient (first_name, last_name, dob, sex, address, phone, category, next_of_kin) VALUES
('Adebayo', 'Ogundipe', '1988-04-12', 'M', '14 Iyana Ipaja Road, Alimosho', '08031234567', 'General', 'Wife: Funke Ogundipe, 08031234568'),
('Blessing', 'Okafor', '1995-09-23', 'F', '28 Bode Thomas, Surulere', '08029876543', 'Antenatal', 'Husband: Emeka Okafor, 08029876544'),
('Kazeem', 'Sanusi', '2022-06-15', 'M', '5 Allen Avenue, Ikeja', '08055551234', 'Under-5', 'Mother: Halimat Sanusi, 08055551235'),
('Grace', 'Eze', '1958-11-03', 'F', '12 Marina Road, Lagos Island', '07012344321', 'Elderly', 'Son: Chukwuma Eze, 07012344322'),
('Tunde', 'Adeyemi', '1991-02-18', 'M', '45 Ikorodu Road, Ikorodu', '08123456789', 'General', 'Brother: Seyi Adeyemi, 08123456780'),
('Zainab', 'Mohammed', '2023-01-10', 'F', '19 Agege Motor Road, Mushin', '08098765432', 'Under-5', 'Father: Usman Mohammed, 08098765433'),
('Folake', 'Ajayi', '1982-08-30', 'F', '8 Ogudu GRA, Kosofe', '08033334444', 'General', 'Husband: Kunle Ajayi, 08033334445'),
('Chinedu', 'Obi', '1990-12-05', 'M', '7 Chevron Drive, Eti-Osa', '08077778888', 'General', 'Sister: Amaka Obi, 08077778889'),
('Morayo', 'Bankole', '2021-03-25', 'F', '33 Egbeda Road, Alimosho', '08022223333', 'Under-5', 'Mother: Ronke Bankole, 08022223334'),
('Ibrahim', 'Lawal', '1975-07-14', 'M', '16 Lawanson Street, Surulere', '08066665555', 'General', 'Wife: Maryam Lawal, 08066665556');

-- 4. Medical History
INSERT INTO medical_history (patient_id, previous_illnesses, chronic_conditions, surgical_history, allergies, family_history) VALUES
(1, 'Malaria, Bronchitis', 'None', 'Appendectomy (2015)', 'No known drug allergies', 'Mother has Hypertension'),
(2, 'Malaria', 'None', 'None', 'Penicillin', 'None reported'),
(3, 'Neonatal Jaundice', 'None', 'None', 'None', 'None'),
(4, 'Pneumonia', 'Hypertension, Osteoarthritis', 'Cataract surgery (2018)', 'Sulfa drugs', 'Both parents hypertensive'),
(5, 'Typhoid (2020)', 'None', 'None', 'None', 'Father has Type 2 Diabetes'),
(6, 'None', 'None', 'None', 'None', 'None'),
(7, 'Peptic Ulcer Disease', 'None', 'None', 'NSAIDs (Ibuprofen)', 'Mother has Asthma'),
(8, 'Malaria', 'None', 'None', 'None', 'None'),
(9, 'Measles (mild, 2022)', 'None', 'None', 'None', 'None'),
(10, 'Frequent headaches', 'Hypertension (Stage 1)', 'None', 'None', 'Father died of stroke');

-- 5. Medications
INSERT INTO medication (medication_name, strength, formulation, category) VALUES
('Ciprofloxacin', '500mg', 'Tablet', 'Antibiotic'),
('Artemether / Lumefantrine (ACT)', '80/480mg', 'Tablet', 'Antimalarial'),
('Paracetamol', '500mg', 'Tablet', 'Analgesic / Antipyretic'),
('Amoxicillin / Clavulanate', '625mg', 'Tablet', 'Antibiotic'),
('Amlodipine', '5mg', 'Tablet', 'Antihypertensive'),
('Oral Rehydration Salts (ORS)', '20.5g sachet', 'Powder for Solution', 'Rehydration'),
('Zinc Sulfate', '20mg', 'Dispersible Tablet', 'Nutritional Supplement'),
('Azithromycin', '500mg', 'Tablet', 'Antibiotic'),
('Folic Acid', '5mg', 'Tablet', 'Hematinic'),
('Metformin', '500mg', 'Tablet', 'Antidiabetic');

-- 6. Insert
INSERT INTO encounter (patient_id, facility_id, staff_id, visit_date, visit_time, encounter_type, chief_complaint, presenting_symptoms, status) VALUES
-- Encounter 1: Patient 1 at Alimosho (Q1 2024) - Malaria Case
(1, 1, 1, '2024-02-10', '09:30:00', 'Outpatient', 'High fever, severe chills and body pain for 3 days', 'Intermittent high fever, rigors, headache, bitter taste in mouth, general malaise', 'Completed'),
-- Encounter 2: Patient 2 at Surulere (Q1 2024) - Antenatal Care
(2, 2, 3, '2024-02-15', '10:15:00', 'Antenatal', 'Routine 24-week antenatal checkup', 'Mild lower back pain, no bleeding, fetal movement active', 'Completed'),
-- Encounter 3: Patient 3 at Ikeja (Q1 2024) - Immunization
(3, 3, 6, '2024-03-02', '08:45:00', 'Immunization', 'Routine 9-month immunization', 'No complaints, child alert and feeding well', 'Completed'),
-- Encounter 4: Patient 4 at Lagos Island (Q1 2024) - Hypertension
(4, 4, 7, '2024-03-18', '11:00:00', 'Outpatient', 'Dizziness and occasional palpitations', 'Elevated BP readings at home, mild headache', 'Completed'),
-- Encounter 5: Patient 5 at Alimosho (Q1 2024) - Malaria Case
(5, 1, 1, '2024-03-25', '14:20:00', 'Outpatient', 'Severe shaking chills followed by profuse sweating', 'Fever, extreme joint pain, loss of appetite, dark urine', 'Completed'),
-- Encounter 6: Patient 6 at Mushin (Q2 2024) - Under-5 Diarrhea
(6, 6, 9, '2024-04-05', '10:00:00', 'Emergency', 'Watery stool and vomiting for 24 hours', 'Frequent watery stool, lethargy, sunken eyes', 'Completed'),
-- Encounter 7: Patient 7 at Kosofe (Q1 2024) - Malaria Case
(7, 7, 10, '2024-01-20', '09:00:00', 'Outpatient', 'High fever, vomiting and generalized body ache', 'Fever spike at night, chills, nausea, bitter mouth taste', 'Completed'),
-- Encounter 8: Patient 8 at Eti-Osa (Q1 2024) - Malaria Case
(8, 8, 3, '2024-02-28', '12:30:00', 'Outpatient', 'Persistent intermittent fever unresolved by paracetamol', 'Severe headache, fatigue, chills, body temperature 39.4C', 'Completed'),
-- Encounter 9: Patient 10 at Surulere (Q1 2024) - Severe Complicated Malaria Case
(10, 2, 3, '2024-03-12', '15:10:00', 'Outpatient', 'High fever, marked pallor, dizziness and extreme weakness', 'Hyperpyrexia 39.8C, severe anemia, prostration, dark coca-cola urine', 'Referred'),
-- Encounter 10: Patient 1 at Alimosho (Q2 2024) - Follow-up Malaria
(1, 1, 1, '2024-05-10', '10:30:00', 'Outpatient', 'Chills and body heat', 'Intermittent fever, joint pain, bitter taste in mouth', 'Completed'),
-- Encounter 11: Patient 9 at Alimosho (Q2 2024) - Immunization
(9, 1, 2, '2024-05-18', '09:00:00', 'Immunization', 'Routine childhood booster', 'Healthy, thriving child', 'Completed'),
-- Encounter 12: Patient 5 at Ikorodu (Q2 2024) - Checkup
(5, 5, 8, '2024-06-02', '11:45:00', 'Outpatient', 'Mild cough and catarrh', 'Runny nose, mild sore throat', 'Completed'),
-- Additional Immunization Encounters across Lagos LGAs
(6, 6, 9, '2024-01-18', '08:30:00', 'Immunization', 'Routine 6-week immunization', 'Child well and alert', 'Completed'), -- Enc 13 (Mushin)
(9, 1, 2, '2024-01-20', '09:15:00', 'Immunization', 'Birth dose BCG and Polio', 'Normal newborn check', 'Completed'), -- Enc 14 (Alimosho)
(3, 3, 6, '2024-01-15', '09:00:00', 'Immunization', 'Childhood immunization', 'Well infant', 'Completed'), -- Enc 15 (Ikeja)
(3, 3, 6, '2024-02-15', '08:45:00', 'Immunization', 'Childhood immunization 10 weeks', 'Normal development', 'Completed'), -- Enc 16 (Ikeja)
(6, 6, 9, '2024-02-20', '09:30:00', 'Immunization', 'Childhood immunization 10 weeks', 'Feeding well', 'Completed'), -- Enc 17 (Mushin)
(9, 1, 2, '2024-02-22', '09:00:00', 'Immunization', 'Routine immunization 6 weeks', 'Growing normally', 'Completed'), -- Enc 18 (Alimosho)
(6, 6, 9, '2024-03-15', '08:30:00', 'Immunization', 'Childhood immunization 14 weeks', 'Healthy infant', 'Completed'), -- Enc 19 (Mushin)
(9, 1, 2, '2024-03-20', '10:00:00', 'Immunization', 'Childhood immunization 10 weeks', 'Normal milestones', 'Completed'), -- Enc 20 (Alimosho)
(3, 3, 6, '2024-03-25', '09:15:00', 'Immunization', 'Childhood immunization 14 weeks', 'Healthy child', 'Completed'), -- Enc 21 (Ikeja)
(9, 1, 2, '2024-04-12', '08:45:00', 'Immunization', 'Measles 9-month dose', 'Active and thriving', 'Completed'), -- Enc 22 (Alimosho)
(3, 3, 6, '2024-04-18', '11:00:00', 'Immunization', 'Yellow fever vaccination', 'Healthy infant', 'Completed'), -- Enc 23 (Ikeja)
(6, 6, 9, '2024-05-22', '09:30:00', 'Immunization', 'Measles vaccine', 'Good nutritional state', 'Completed'), -- Enc 24 (Mushin)
(3, 3, 6, '2024-05-25', '10:15:00', 'Immunization', 'Vitamin A supplementation', 'Child alert', 'Completed'); -- Enc 25 (Ikeja)

-- 7. Vital Signs
INSERT INTO vital_signs (encounter_id, systolic_bp, diastolic_bp, temperature, pulse_rate, respiratory_rate, spo2, weight, height, bmi) VALUES
(1, 118, 76, 39.2, 78, 20, 97.5, 72.0, 175.0, 23.51),
(2, 110, 70, 36.6, 82, 18, 99.0, 68.0, 162.0, 25.91),
(3, 95,  60, 36.8, 105, 26, 98.5, 9.2,   74.0, 16.80),
(4, 165, 98, 36.7, 88, 19, 96.0, 81.5, 158.0, 32.65),
(5, 122, 78, 39.5, 82, 22, 98.0, 65.0, 170.0, 22.49),
(6, 90,  55, 38.4, 120, 30, 97.0, 11.5,  82.0, 17.10),
(7, 120, 80, 39.0, 84, 20, 98.0, 58.0, 160.0, 22.66),
(8, 125, 82, 39.4, 76, 21, 97.0, 76.0, 178.0, 24.00),
(9, 130, 85, 39.8, 74, 22, 96.5, 74.0, 172.0, 25.01),
(10, 115, 75, 38.6, 92, 19, 98.0, 71.5, 175.0, 23.35),
(11, 92,  58, 36.6, 98, 24, 99.0, 13.0,  88.0, 16.79),
(12, 120, 78, 36.9, 75, 18, 98.5, 65.0, 170.0, 22.49),
(13, 90,  55, 36.5, 110, 28, 99.0, 4.8,   58.0, 14.27),
(14, 88,  54, 36.7, 115, 30, 98.5, 3.4,   50.0, 13.60),
(15, 92,  56, 36.8, 112, 28, 99.0, 4.6,   56.0, 14.67),
(16, 94,  58, 36.6, 108, 26, 98.5, 6.2,   62.0, 16.13),
(17, 92,  56, 36.7, 110, 28, 99.0, 6.0,   61.0, 16.12),
(18, 90,  55, 36.5, 112, 28, 98.5, 5.1,   58.0, 15.16),
(19, 94,  58, 36.6, 106, 26, 99.0, 7.3,   66.0, 16.76),
(20, 92,  56, 36.8, 108, 26, 98.5, 6.4,   63.0, 16.12),
(21, 95,  58, 36.7, 105, 25, 99.0, 7.5,   67.0, 16.71),
(22, 96,  60, 36.6, 102, 24, 98.5, 8.8,   72.0, 16.98),
(23, 95,  60, 36.8, 104, 25, 99.0, 8.9,   73.0, 16.70),
(24, 96,  58, 36.5, 100, 24, 98.5, 9.4,   75.0, 16.71),
(25, 95,  58, 36.6, 102, 24, 99.0, 9.6,   76.0, 16.62);

-- 8. Diagnoses
INSERT INTO diagnosis (encounter_id, diagnosis_description, icd10_code, diagnosis_type) VALUES
(1, 'Acute Uncomplicated Plasmodium falciparum Malaria', 'B54', 'Final'),
(2, 'Normal Supervision of Pregnancy (Antenatal Care)', 'Z34.0', 'Final'),
(3, 'Routine Child Immunization', 'Z23', 'Final'),
(4, 'Essential (Primary) Hypertension', 'I10', 'Final'),
(5, 'Plasmodium falciparum Malaria with high pyrexia', 'B54', 'Final'),
(6, 'Acute Gastroenteritis with moderate dehydration', 'A09', 'Final'),
(7, 'Uncomplicated Malaria with acute gastritis', 'B54', 'Final'),
(8, 'Plasmodium falciparum Malaria', 'B54', 'Final'),
(9, 'Severe Complicated Malaria with severe anemia (Hb < 6g/dL)', 'B54', 'Final'),
(10, 'Plasmodium falciparum Malaria (Re-infection)', 'B54', 'Final'),
(11, 'Routine Child Immunization Follow-up', 'Z23', 'Final'),
(12, 'Acute Upper Respiratory Tract Infection', 'J06.9', 'Final'),
(13, 'Routine Infant Immunization (6 weeks)', 'Z23', 'Final'),
(14, 'Routine Neonatal Immunization (Birth)', 'Z23', 'Final'),
(15, 'Routine Infant Immunization (6 weeks)', 'Z23', 'Final'),
(16, 'Routine Infant Immunization (10 weeks)', 'Z23', 'Final'),
(17, 'Routine Infant Immunization (10 weeks)', 'Z23', 'Final'),
(18, 'Routine Infant Immunization (6 weeks)', 'Z23', 'Final'),
(19, 'Routine Infant Immunization (14 weeks)', 'Z23', 'Final'),
(20, 'Routine Infant Immunization (10 weeks)', 'Z23', 'Final'),
(21, 'Routine Infant Immunization (14 weeks)', 'Z23', 'Final'),
(22, 'Routine Measles Vaccination (9 months)', 'Z23', 'Final'),
(23, 'Routine Yellow Fever Vaccination (9 months)', 'Z23', 'Final'),
(24, 'Routine Measles Vaccination (9 months)', 'Z23', 'Final'),
(25, 'Childhood Vitamin A Supplementation', 'Z76.89', 'Final');

-- 9. Lab Investigations
INSERT INTO lab_investigation (encounter_id, test_name, specimen_type, test_result, request_date, result_date, status) VALUES
(1, 'Malaria Rapid Diagnostic Test (mRDT)', 'Blood', 'Positive (P. falciparum HRP2 antigen detected)', '2024-02-10', '2024-02-10', 'Completed'),
(1, 'Blood Film for Malaria Parasites (BF for MP)', 'Blood', 'P. falciparum trophozoites seen (+++, high parasitaemia)', '2024-02-10', '2024-02-10', 'Completed'),
(4, 'Serum Electrolytes, Urea, Creatinine', 'Blood', 'Creatinine 1.1 mg/dL, K+ 4.2 mmol/L', '2024-03-18', '2024-03-19', 'Completed'),
(5, 'Malaria Rapid Diagnostic Test (mRDT)', 'Blood', 'Positive (P. falciparum detected)', '2024-03-25', '2024-03-25', 'Completed'),
(6, 'Stool Microscopy and Culture', 'Stool', 'No ova or parasites, watery consistency', '2024-04-05', '2024-04-06', 'Completed'),
(7, 'Malaria Rapid Diagnostic Test (mRDT)', 'Blood', 'Positive (P. falciparum detected)', '2024-01-20', '2024-01-20', 'Completed'),
(8, 'Malaria Rapid Diagnostic Test (mRDT)', 'Blood', 'Positive (P. falciparum detected)', '2024-02-28', '2024-02-28', 'Completed'),
(9, 'mRDT and Packed Cell Volume (PCV)', 'Blood', 'mRDT: Strongly Positive; PCV: 18% (Severe Anemia)', '2024-03-12', '2024-03-12', 'Completed'),
(10, 'Malaria Rapid Diagnostic Test (mRDT)', 'Blood', 'Positive (P. falciparum)', '2024-05-10', '2024-05-10', 'Completed');

-- 10. Prescriptions
INSERT INTO prescription (encounter_id, medication_id, staff_id, dosage, frequency, duration, route, instructions) VALUES
(1, 2, 1, '80/480mg', 'Twice daily with fatty meal', '3 days', 'Oral', 'Artemisinin-based combination therapy (ACT) complete course'),
(1, 3, 1, '1000mg', 'Three times daily (TDS)', '3 days', 'Oral', 'For fever and body pains as needed'),
(2, 9, 3, '5mg', 'Once daily', '30 days', 'Oral', 'Daily prenatal vitamin'),
(4, 5, 7, '5mg', 'Once daily in the morning', '30 days', 'Oral', 'Monitor blood pressure weekly'),
(5, 2, 1, '80/480mg', 'Twice daily with fatty meal', '3 days', 'Oral', 'Complete full ACT 3-day course'),
(6, 6, 9, '1 sachet in 1L water', 'Drink after each loose stool', '3 days', 'Oral', 'Oral rehydration therapy'),
(6, 7, 9, '20mg', 'Once daily', '14 days', 'Oral', 'Dissolve in clean water'),
(7, 2, 10, '80/480mg', 'Twice daily with meals', '3 days', 'Oral', 'First-line ACT antimalarial full regimen'),
(8, 2, 3, '80/480mg', 'Twice daily with meals', '3 days', 'Oral', 'Complete full course; drink plenty of water'),
(10, 2, 1, '80/480mg', 'Twice daily with meals', '3 days', 'Oral', 'Antimalarial ACT full course');

-- 11. Immunizations
INSERT INTO immunization (patient_id, encounter_id, vaccine_name, dose, batch_number, administration_date, site_administered) VALUES
-- January 2024
(3, 15, 'Pentavalent', 'Dose 1', 'PENTA-2024-001', '2024-01-15', 'Left anterolateral thigh'),
(6, 13, 'Pentavalent', 'Dose 1', 'PENTA-2024-001', '2024-01-18', 'Left anterolateral thigh'),
(9, 14, 'BCG', 'Single Dose', 'BCG-2024-001', '2024-01-20', 'Right upper arm'),
(3, 15, 'Oral Polio (OPV)', 'Dose 1', 'OPV-2024-001', '2024-01-15', 'Oral'),
-- February 2024
(3, 16, 'Pentavalent', 'Dose 2', 'PENTA-2024-001', '2024-02-15', 'Left anterolateral thigh'),
(6, 17, 'Pentavalent', 'Dose 2', 'PENTA-2024-001', '2024-02-20', 'Left anterolateral thigh'),
(9, 18, 'Pentavalent', 'Dose 1', 'PENTA-2024-002', '2024-02-22', 'Left anterolateral thigh'),
(3, 16, 'Oral Polio (OPV)', 'Dose 2', 'OPV-2024-001', '2024-02-15', 'Oral'),
(6, 17, 'Oral Polio (OPV)', 'Dose 2', 'OPV-2024-002', '2024-02-20', 'Oral'),
-- March 2024
(3, 3, 'Measles', 'Dose 1', 'MEASLES-2024-001', '2024-03-02', 'Left upper arm'),
(6, 19, 'Pentavalent', 'Dose 3', 'PENTA-2024-002', '2024-03-15', 'Left anterolateral thigh'),
(9, 20, 'Pentavalent', 'Dose 2', 'PENTA-2024-002', '2024-03-20', 'Left anterolateral thigh'),
(3, 21, 'Pentavalent', 'Dose 3', 'PENTA-2024-002', '2024-03-25', 'Left anterolateral thigh'),
-- April 2024
(6, 6, 'Rotavirus', 'Dose 1', 'ROTA-2024-001', '2024-04-05', 'Oral'),
(9, 22, 'Measles', 'Dose 1', 'MEASLES-2024-001', '2024-04-12', 'Left upper arm'),
(3, 23, 'Yellow Fever', 'Single Dose', 'YF-2024-001', '2024-04-18', 'Right upper arm'),
-- May 2024
(9, 11, 'Pentavalent', 'Dose 3', 'PENTA-2024-002', '2024-05-18', 'Left anterolateral thigh'),
(6, 24, 'Measles', 'Dose 1', 'MEASLES-2024-002', '2024-05-22', 'Left upper arm'),
(3, 25, 'Vitamin A', 'Dose 1', 'VITA-2024-001', '2024-05-25', 'Oral');

-- 12. Referrals
INSERT INTO referral (encounter_id, referring_facility_id, receiving_facility_id, referral_reason, referral_date, referral_outcome, urgency_level) VALUES
(9, 2, 3, 'Severe complicated Plasmodium falciparum malaria with profound anemia (PCV 18%) requiring blood transfusion and secondary hospital admission', '2024-03-12', 'Transferred to General Hospital / Teaching Hospital', 'Emergency');

-- 13. Treatments and Procedures
INSERT INTO treatment_procedure (encounter_id, procedure_performed, treatment_administered, date_performed, outcome) VALUES
(1, 'Intravenous cannulation and fluid hydration', '500ml Normal Saline IV', '2024-02-10', 'Hydration status improved, vitals stable'),
(6, 'Oral Rehydration Therapy administration', 'ORS solution administered over 4 hours', '2024-04-05', 'Skin turgor normalized, vomiting subsided'),
(9, 'Emergency IV access and stabilization', 'IV Ceftriaxone 1g stat and Normal Saline bolus', '2024-03-12', 'Patient stabilized for emergency transport');

-- 14. Discharges
INSERT INTO discharge (encounter_id, discharge_date, discharge_status, clinical_outcome, patient_disposition, follow_up_instructions) VALUES
(1, '2024-02-10', 'Discharged Home', 'Stable, fever subsiding', 'Outpatient ambulatory', 'Return in 5 days for review or immediately if symptoms worsen'),
(2, '2024-02-15', 'Discharged Home', 'Healthy pregnancy progression', 'Outpatient ambulatory', 'Next ANC visit scheduled in 4 weeks'),
(3, '2024-03-02', 'Discharged Home', 'Immunization administered successfully', 'Discharged with guardian', 'Next vaccination due at 12 months'),
(4, '2024-03-18', 'Discharged Home', 'Blood pressure managed', 'Outpatient ambulatory', 'Follow up in 2 weeks for BP check with diary'),
(5, '2024-03-25', 'Discharged Home', 'Improved, tolerated oral medication', 'Outpatient ambulatory', 'Complete 10-day antibiotic course; review on day 7'),
(6, '2024-04-05', 'Discharged Home', 'Dehydration resolved', 'Discharged with mother', 'Continue zinc tablets for 14 days and ORS after loose stool'),
(7, '2024-01-20', 'Discharged Home', 'Condition improved', 'Outpatient ambulatory', 'Complete antibiotics; boil drinking water'),
(8, '2024-02-28', 'Discharged Home', 'Clinically stable', 'Outpatient ambulatory', 'Follow up in 1 week at PHC'),
(10, '2024-05-10', 'Discharged Home', 'Malaria treatment commenced', 'Outpatient ambulatory', 'Sleep under insecticide treated bed net');

COMMIT;
