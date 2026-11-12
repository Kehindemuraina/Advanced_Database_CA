// ============================================================================
// LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
// Portfolio 4: MongoDB Shell (mongosh) CRUD Operations Script
// File: portfolio-4-nosql-data-models/02_mongo_crud_operations.js
// ============================================================================

// Switch to LSPHCB EMR database
use lsphcb_nosql;

// ----------------------------------------------------------------------------
// 1. CREATE: Insert Patient Health Profile Document
// ----------------------------------------------------------------------------
db.patient_health_profiles.insertOne({
  patient_id: 101,
  demographics: {
    first_name: "Amina",
    last_name: "Bello",
    dob: "2023-04-10",
    sex: "F",
    phone: "08034567890",
    address: "15 Ikotun Road, Alimosho",
    lga: "Alimosho",
    primary_facility_code: "PHC-ALM-001"
  },
  medical_history: {
    blood_group: "O+",
    genotype: "AA",
    allergies: ["Penicillin"],
    chronic_conditions: [],
    surgical_history: []
  },
  longitudinal_encounters: [
    {
      encounter_id: 501,
      visit_date: "2023-05-22",
      facility_name: "Alimosho Primary Healthcare Centre",
      facility_lga: "Alimosho",
      clinician_name: "Dr. Babatunde Fashola",
      chief_complaint: "6-week routine well-baby intake",
      vital_signs: {
        blood_pressure: "85/55",
        temperature: 36.6,
        pulse_rate: 115,
        respiratory_rate: 28,
        spo2: 99.0,
        weight_kg: 4.5,
        height_cm: 55.0,
        bmi: 14.88
      },
      diagnoses: [
        { icd10_code: "Z23", description: "Routine Child Immunization", diagnosis_type: "Final" }
      ],
      lab_investigations: []
    }
  ],
  active_prescriptions: [],
  immunization_history: [
    {
      vaccine_name: "BCG",
      dose: "Birth Dose",
      batch_number: "BCG-2023-091",
      administration_date: "2023-04-12",
      administering_facility: "Alimosho PHC"
    },
    {
      vaccine_name: "Oral Polio (OPV)",
      dose: "Dose 0",
      batch_number: "OPV-2023-014",
      administration_date: "2023-04-12",
      administering_facility: "Alimosho PHC"
    }
  ]
});

// ----------------------------------------------------------------------------
// 2. READ: Query Longitudinal Timeline & Vaccination Status
// ----------------------------------------------------------------------------

// A. Retrieve complete longitudinal health profile for Amina Bello
db.patient_health_profiles.findOne(
  { patient_id: 101 },
  { "demographics.first_name": 1, "demographics.last_name": 1, immunization_history: 1, longitudinal_encounters: 1 }
);

// B. Query all patients with Penicillin allergy residing in Alimosho LGA
db.patient_health_profiles.find({
  "demographics.lga": "Alimosho",
  "medical_history.allergies": "Penicillin"
});

// ----------------------------------------------------------------------------
// 3. UPDATE: Atomic Updates to Clinical Timeline
// ----------------------------------------------------------------------------

// A. Real-time update: Add 10-week Pentavalent vaccination to immunization history ($push)
db.patient_health_profiles.updateOne(
  { patient_id: 101 },
  {
    $push: {
      immunization_history: {
        vaccine_name: "Pentavalent",
        dose: "Dose 1",
        batch_number: "PENTA-2023-088",
        administration_date: "2023-06-19",
        administering_facility: "Alimosho Primary Healthcare Centre"
      }
    }
  }
);

// B. Real-time update: Append a new clinical encounter for fever ($push)
db.patient_health_profiles.updateOne(
  { patient_id: 101 },
  {
    $push: {
      longitudinal_encounters: {
        encounter_id: 502,
        visit_date: "2023-08-15",
        facility_name: "Alimosho Primary Healthcare Centre",
        facility_lga: "Alimosho",
        clinician_name: "Nurse Folashade Adeleke",
        chief_complaint: "High temperature and irritability for 2 days",
        vital_signs: {
          blood_pressure: "88/56",
          temperature: 38.9,
          pulse_rate: 128,
          respiratory_rate: 32,
          spo2: 98.0,
          weight_kg: 5.8,
          height_cm: 61.0,
          bmi: 15.59
        },
        diagnoses: [
          { icd10_code: "B54", description: "Uncomplicated Malaria", diagnosis_type: "Final" }
        ],
        lab_investigations: [
          {
            test_name: "Malaria RDT",
            specimen: "Blood",
            result: "Positive (P. falciparum)",
            result_date: "2023-08-15"
          }
        ]
      }
    },
    $set: {
      "active_prescriptions": [
        {
          medication_name: "Artemether-Lumefantrine Dispersible",
          dosage: "1 tablet (20/120mg)",
          frequency: "Twice daily",
          duration: "3 days",
          prescribed_date: "2023-08-15",
          is_active: true
        }
      ]
    }
  }
);

// ----------------------------------------------------------------------------
// 4. AGGREGATION PIPELINE: Longitudinal Vaccination Statistics
// ----------------------------------------------------------------------------
db.patient_health_profiles.aggregate([
  { $unwind: "$immunization_history" },
  {
    $group: {
      _id: {
        lga: "$demographics.lga",
        vaccine: "$immunization_history.vaccine_name",
        batch: "$immunization_history.batch_number"
      },
      total_doses: { $sum: 1 }
    }
  },
  { $sort: { "_id.lga": 1, total_doses: -1 } }
]);
