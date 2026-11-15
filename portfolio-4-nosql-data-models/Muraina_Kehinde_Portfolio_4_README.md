# Portfolio 4: NoSQL & Advanced Data Models
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Lagos State Primary Health Care Board (LSPHCB) Electronic Medical Records System  
**NoSQL Paradigm:** Document-Oriented Store (MongoDB / JSON Schema)

---

## 1. Overview & Document Model Rationale

In our relational database design (Portfolio 1), fetching a patient's complete longitudinal record requires joining up to 7 separate tables (`patient`, `medical_history`, `encounter`, `vital_signs`, `diagnosis`, `prescription`, `lab_investigation`, `immunization`). 

While relational normalization guarantees zero duplication and strict consistency, in an emergency ward or triage point at a busy clinic like Alimosho PHC, doctors need to pull up a patient's **entire medical history in a single sub-millisecond document lookup**.

By adopting a **Document-Oriented NoSQL model (MongoDB)**, we model the **Patient Health Profile** as a single hierarchical JSON/BSON document where historical vitals, encounter timelines, lab results, and immunizations are **embedded** directly inside the patient document.

---

## 2. Document Schema Design (`Muraina_Kehinde_Portfolio_4_Patient_Document_Schema.json`)

The document schema uses standard JSON Schema validation (`$jsonSchema`) to enforce structure while allowing flexible nested documents.

### Key Document Sections:
1. `demographics`: Core patient identification, LGA, and primary PHC code.
2. `medical_history`: Blood group, genotype, chronic conditions, and allergy arrays.
3. `longitudinal_encounters`: Embedded array where each encounter contains its own vitals, diagnoses (ICD-10), and laboratory results.
4. `active_prescriptions`: Array of currently active medication regimens.
5. `immunization_history`: Embedded array of all childhood and adult immunizations (vaccine, dose, batch number, date, facility).

### Sample Document Structure:
```json
{
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
      "vital_signs": {
        "blood_pressure": "85/55",
        "temperature": 36.6,
        "weight_kg": 4.5
      },
      "diagnoses": [
        { "icd10_code": "Z23", "description": "Routine Child Immunization" }
      ]
    }
  ],
  "immunization_history": [
    {
      "vaccine_name": "BCG",
      "dose": "Birth Dose",
      "batch_number": "BCG-2023-091",
      "administration_date": "2023-04-12"
    }
  ]
}
```

---

## 3. Real-Time MongoDB CRUD Operations (`Muraina_Kehinde_Portfolio_4_Mongo_CRUD_Operations.js`)

### 1. Single Fetch (No JOIN Overhead)
```javascript
db.patient_health_profiles.findOne(
  { patient_id: 101 },
  { "demographics.first_name": 1, "demographics.last_name": 1, immunization_history: 1, longitudinal_encounters: 1 }
);
```
*Result:* Returns the patient's entire clinical timeline in one network round-trip.

### 2. Real-Time Atomic Append (`$push`)
When a child receives a new vaccination at the clinic, we don't have to rewrite the document. MongoDB provides atomic array operators:
```javascript
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
```

### 3. Aggregation Pipeline Across Embedded Arrays
To calculate total doses administered by vaccine batch across LGAs:
```javascript
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
```

---

## 4. Comparative Architectural Analysis: Relational (PostgreSQL) vs NoSQL (MongoDB)

| Evaluation Dimension | Relational Database (PostgreSQL) | Document Store (MongoDB) | Architectural Recommendation for LSPHCB |
| :--- | :--- | :--- | :--- |
| **Data Integrity & Consistency** | **Strict ACID Compliance:** Immediate consistency across all tables; foreign key constraints disallow orphaned records. | **Document-Level ACID:** Multi-document transactions exist but have performance overhead; referential integrity between collections must be coded in the app layer. | **PostgreSQL** is strictly superior for Central Master Patient Index (MPI), staff authorization, inventory auditing, and billing. |
| **Schema Flexibility** | **Rigid DDL Schema:** Schema alterations (`ALTER TABLE`) require migrations and table locks. | **Dynamic / Flexible Schema:** Different facilities can record specialized clinical fields (e.g. antenatal ultrasound telemetry) without schema migrations. | **MongoDB** excels for semi-structured free-text clinician notes, research surveys, and high-frequency IoT vitals. |
| **Query Performance (Read Latency)** | Fast for normalized lookups; high join cost when assembling full longitudinal histories across 7+ tables. | **Sub-millisecond retrieval:** Single document read brings back entire clinical history with **zero JOIN cost**. | **MongoDB** provides a faster read-heavy bedside clinical view. |
| **Horizontal Scalability (Sharding)** | Traditionally vertical scaling; table partitioning supported, but multi-node sharding requires extensions (e.g. Citus). | **Native Auto-Sharding:** Transparent distribution across regional cluster nodes by shard key (e.g. `lga` or `patient_id`). | **MongoDB** is easier to scale horizontally across regional Lagos cloud zones. |
| **Storage Overhead** | Compact storage with atomic columns and shared foreign keys. | Redundant key names and field duplication across documents (BSON overhead). | **PostgreSQL** uses storage more efficiently over decades of records. |

### The Hybrid Architectural Recommendation (Polyglot Persistence)
For the Lagos State Primary Health Care Board:
1. **Core Relational Backbone (PostgreSQL):** Hosts master patient demographics, clinical encounters, diagnostic coding (ICD-10), pharmacy inventory, and referral governance where strict ACID transactions and foreign keys are legally mandatory.
2. **Read-Optimized Document Cache / Operational Data Store (MongoDB):** Consumes change streams from PostgreSQL to maintain denormalized `patient_health_profiles` documents. Doctors and mobile clinic nurses query this view instantly on tablets even under flaky network connections.

---

## 5. Verification & Execution
To execute and inspect the Python CRUD demonstration:
```bash
python3 portfolio-4-nosql-data-models/Muraina_Kehinde_Portfolio_4_Execute_Mongo_CRUD.py
```
