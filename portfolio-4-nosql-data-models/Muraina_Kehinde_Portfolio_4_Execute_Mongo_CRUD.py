#!/usr/bin/env python3
"""MongoDB Document Store CRUD simulation in native Python."""

import json
from datetime import datetime

# Simulated in-memory collection for demonstration
mongodb_collection = []

def run_portfolio_4_demonstration():
    print("--- Portfolio 4: NoSQL Document Model (Patient Health Profile) ---")

    # 1. Create: Insert patient health profile document
    print("\n[Step 1] Inserting initial Patient Health Profile document...")
    patient_doc = {
        "patient_id": 101,
        "demographics": {
            "first_name": "Amina",
            "last_name": "Bello",
            "dob": "2023-04-10",
            "sex": "F",
            "phone": "08034567890",
            "address": "15 Ikotun Road, Alimosho",
            "lga": "Alimosho",
            "primary_facility_code": "PHC-ALM-001"
        },
        "medical_history": {
            "blood_group": "O+",
            "genotype": "AA",
            "allergies": ["Penicillin"],
            "chronic_conditions": [],
            "surgical_history": []
        },
        "longitudinal_encounters": [
            {
                "encounter_id": 501,
                "visit_date": "2023-05-22",
                "facility_name": "Alimosho Primary Healthcare Centre",
                "facility_lga": "Alimosho",
                "clinician_name": "Dr. Babatunde Fashola",
                "chief_complaint": "6-week routine well-baby intake",
                "vital_signs": {
                    "blood_pressure": "85/55",
                    "temperature": 36.6,
                    "pulse_rate": 115,
                    "respiratory_rate": 28,
                    "spo2": 99.0,
                    "weight_kg": 4.5,
                    "height_cm": 55.0,
                    "bmi": 14.88
                },
                "diagnoses": [
                    {"icd10_code": "Z23", "description": "Routine Child Immunization", "diagnosis_type": "Final"}
                ],
                "lab_investigations": []
            }
        ],
        "active_prescriptions": [],
        "immunization_history": [
            {
                "vaccine_name": "BCG",
                "dose": "Birth Dose",
                "batch_number": "BCG-2023-091",
                "administration_date": "2023-04-12",
                "administering_facility": "Alimosho PHC"
            },
            {
                "vaccine_name": "Oral Polio (OPV)",
                "dose": "Dose 0",
                "batch_number": "OPV-2023-014",
                "administration_date": "2023-04-12",
                "administering_facility": "Alimosho PHC"
            }
        ]
    }
    mongodb_collection.append(patient_doc)
    print(f"Document inserted successfully! ID: {patient_doc['patient_id']}")
    print(f"Initial encounters count: {len(patient_doc['longitudinal_encounters'])}")
    print(f"Initial immunizations count: {len(patient_doc['immunization_history'])}")

    # 2. Read: Single document fetch without joins
    print("\n[Step 2] Querying complete patient timeline in a single fetch...")
    queried = next((p for p in mongodb_collection if p["patient_id"] == 101), None)
    if queried:
        demo = queried["demographics"]
        print(f"Patient: {demo['first_name']} {demo['last_name']} (DOB: {demo['dob']}, LGA: {demo['lga']})")
        print(f"Allergies: {queried['medical_history']['allergies']}")
        print(f"Immunization count: {len(queried['immunization_history'])}")

    # 3. Update: Atomic updates to timeline ($push and $set)
    print("\n[Step 3] Appending new vaccination and encounter via $push...")
    # Simulate $push to immunization_history
    queried["immunization_history"].append({
        "vaccine_name": "Pentavalent",
        "dose": "Dose 1",
        "batch_number": "PENTA-2023-088",
        "administration_date": "2023-06-19",
        "administering_facility": "Alimosho Primary Healthcare Centre"
    })
    print("-> Appended Pentavalent Dose 1 to immunization_history.")

    # Simulate $push of new encounter + active prescription
    new_encounter = {
        "encounter_id": 502,
        "visit_date": "2023-08-15",
        "facility_name": "Alimosho Primary Healthcare Centre",
        "facility_lga": "Alimosho",
        "clinician_name": "Nurse Folashade Adeleke",
        "chief_complaint": "High temperature and irritability for 2 days",
        "vital_signs": {
            "blood_pressure": "88/56",
            "temperature": 38.9,
            "pulse_rate": 128,
            "respiratory_rate": 32,
            "spo2": 98.0,
            "weight_kg": 5.8,
            "height_cm": 61.0,
            "bmi": 15.59
        },
        "diagnoses": [
            {"icd10_code": "B54", "description": "Uncomplicated Malaria", "diagnosis_type": "Final"}
        ],
        "lab_investigations": [
            {"test_name": "Malaria RDT", "specimen": "Blood", "result": "Positive (P. falciparum)", "result_date": "2023-08-15"}
        ]
    }
    queried["longitudinal_encounters"].append(new_encounter)
    queried["active_prescriptions"].append({
        "medication_name": "Artemether-Lumefantrine Dispersible",
        "dosage": "1 tablet (20/120mg)",
        "frequency": "Twice daily",
        "duration": "3 days",
        "prescribed_date": "2023-08-15",
        "is_active": True
    })
    print("-> Appended Encounter 502 with Malaria RDT and ACT prescription.")

    # 4. Aggregation & timeline view
    print("\n[Step 4] Longitudinal Timeline Summary for Patient 101:")
    for enc in queried["longitudinal_encounters"]:
        diag_str = ", ".join([d["description"] for d in enc["diagnoses"]])
        print(f"Date: {enc['visit_date']} | Facility: {enc['facility_name']}")
        print(f"  Vitals: Temp {enc['vital_signs']['temperature']}C, BP {enc['vital_signs']['blood_pressure']}, Weight {enc['vital_signs']['weight_kg']}kg")
        print(f"  Diagnosis: {diag_str}")
    
    print("\nVaccinations Administered:")
    for imm in queried["immunization_history"]:
        print(f"  - {imm['administration_date']}: {imm['vaccine_name']} ({imm['dose']}) [Batch: {imm['batch_number']}]")

    print("\n--- Portfolio 4 completed successfully ---")

if __name__ == "__main__":
    run_portfolio_4_demonstration()
