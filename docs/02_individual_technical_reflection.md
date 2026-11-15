# Individual Technical Reflection
**Course:** MIT 8103 – Advanced Database Systems  
**Project:** Lagos State Primary Health Care Board (LSPHCB) EMR System  
**Author:** Kehinde Muraina  
**Role:** Software Developer / Database Systems Engineer

---

## 1. Introduction & Context

Building an Electronic Medical Records (EMR) system for primary healthcare in Lagos State is not merely an abstract academic exercise—it is a study in designing software that must operate reliably under real-world infrastructure constraints. In Lagos, power supply is intermittent, fiber cables get sliced during road expansions, and PHC clinics range from bustling multi-story facilities in Alimosho to remote riverine clinics in Epe and Badagry.

Coming into this project with standard application-level SQL experience, my primary goal was to move beyond basic CRUD queries and dive into the mechanics of database internals—indexing behavior, concurrency anomalies, document modeling trade-offs, and distributed reliability.

---

## 2. Key Lessons Learned

### A. The Reality of Progression from Raw Data to 3NF Normalization
Prior to this project, I often viewed 3NF normalization as a textbook academic checklist. However, when drafting the initial flat clinic registers (UNF), the dangers of unnormalized data became glaringly obvious:
- In UNF, vitals were trapped in single text strings like `"BP: 120/80, Temp: 39.2C"`. We could not query patients by temperature thresholds or calculate physiological BMI without breaking the data down into atomic attributes (1NF).
- In 1NF, expanding multi-valued prescriptions resulted in massive partial functional dependencies where patient address and phone number were duplicated across every prescribed medicine row.
- In 2NF, we separated tables by primary keys, but still suffered from transitive dependencies: drug strength and clinic LGA depended on non-key attributes (`medication_name` and `facility_name`), creating severe update and deletion anomalies.
- Reaching 3NF by extracting independent `medication` and `facility` catalogs taught me that database schema design is the foundation of patient safety.

### B. Grounding Queries in Authentic Clinical Scope: From Typhoid to Malaria
A crucial realization during this project was ensuring the analytical queries reflected real clinical practice in Lagos State. While academic briefs often cite enteric typhoid fever, in real Lagos PHCs, true typhoid with blood cultures is virtually nonexistent due to laboratory equipment limitations. Instead, **Malaria (Plasmodium falciparum, ICD-10: B54)** constitutes over 50–65% of daily acute consultations. 
Restructuring Portfolio 2 around **mRDT (Malaria Rapid Diagnostic Test) confirmation, fever triage, and ACT (Artemether-Lumefantrine) dispensing** transformed the project into a genuinely realistic Lagos State Primary Health Care Board epidemiological system.

### C. Demystifying Query Optimization & the PostgreSQL Query Planner
One of the most rewarding breakthroughs in this portfolio was moving beyond simply writing SQL queries to actively profiling them with `EXPLAIN (ANALYZE, BUFFERS)`. 
- Seeing the PostgreSQL engine scan thousands of diagnosis rows sequentially made the abstract concept of "I/O cost" tangible.
- Creating a **Partial B-Tree Index** specifically targeting endemic malaria (`B54`) was an eye-opener. I learned that you don't need to index every row in a table; targeting high-frequency operational subsets saves immense disk space and keeps write operations fast. Slashing execution time and buffer reads proved the immense value of targeted indexing.

### D. Concurrency Is Subtle and Dangerous
Before implementing the concurrency tests in Portfolio 3, I assumed that putting statements between `BEGIN` and `COMMIT` was enough to guarantee safety. Running live concurrent sessions in `test_isolation.sh` revealed how default `READ COMMITTED` isolation allows **Phantom Reads**—a clinician can check available appointment slots, see that 1 slot is open, yet have another transaction take it before they commit. 

Similarly, reproducing an authentic PostgreSQL **deadlock** in `test_deadlock.sh` and seeing `ERROR: deadlock detected` in terminal output showed me how reverse-order locks can bring a high-volume dispensary to a halt. Learning to enforce **Deterministic Ascending Key Ordering** (`ORDER BY inventory_id ASC FOR UPDATE`) gave me a reliable engineering pattern to prevent deadlocks completely.

### E. CAP Theorem Is a Clinical Decision, Not Just a Tech Decision
Studying distributed topologies and the CAP theorem in the context of Lagos public health showed me that choosing between Consistency (C) and Availability (A) is fundamentally a medical decision. If an emergency obstetric patient is bleeding at 2:00 AM in a clinic with no cellular network, the database cannot freeze waiting for central Alausa datacenter confirmation. The system **must prioritize Availability (AP)** to save lives, while reconciling data asynchronously. Conversely, Master Patient Index identity and opioid drug quotas must enforce strict **Consistency (CP)** to prevent identity fraud and overdose risks.

---

## 3. Engineering Trade-Offs Encountered

| Engineering Choice | Alternative Considered | Trade-Off Decision |
| :--- | :--- | :--- |
| **Relational Schema (PostgreSQL) as Core** | Pure NoSQL (MongoDB) throughout | Chose PostgreSQL for the core system because medical record auditing, foreign key constraints, and multi-table ACID compliance are non-negotiable for legal and clinical accountability. |
| **Partial Indexes over Full Table Indexes** | Full B-Tree index on `(encounter_id, icd10_code)` | Chose Partial Index (`WHERE icd10_code = 'B54'`) to preserve fast write performance on everyday routine clinical visits while optimizing epidemic reporting. |
| **Declarative Table Partitioning by LGA Zone** | Application-level sharding | Chose native PostgreSQL declarative partitioning because it allows partition pruning directly within the query optimizer without complicating the application codebase. |
| **Polyglot Persistence for Bedside Tablets** | Purely relational joins for bedside views | Designed an asynchronous document cache in MongoDB to allow nurses on rounds to retrieve a complete patient health timeline in a single fetch without 7-table join latency. |

---

## 4. Personal Reflection & Next Steps

This portfolio has fundamentally transformed how I write and reason about databases. I no longer write queries blindly; I think in terms of disk page buffers, index selectivity, isolation snapshot visibility, and network partition resilience.

Moving forward, I intend to explore:
1. Automated change data capture (CDC) pipelines using Debezium and Kafka to sync PostgreSQL relational writes into MongoDB document profiles in near real time.
2. Load-testing Patroni automated failover clusters under simulated regional network drops.
3. Integrating spatial indexes (PostGIS) to map travel times between referring PHCs and secondary general hospitals across Lagos traffic corridors.
