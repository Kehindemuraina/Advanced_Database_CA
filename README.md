# Lagos State Primary Health Care Board (LSPHCB) EMR System
## Advanced Database Systems Portfolio (MIT 8103)
**Author:** Kehinde Muraina (Software Developer, Lagos, Nigeria)  
**Target Database Engines:** PostgreSQL 16+ (Relational Core) & MongoDB (Document Store)  
**Repository Architecture:** `advanced-database-portfolio/`

---

## 🏥 Executive Overview

The **Lagos State Primary Health Care Board (LSPHCB)** coordinates primary healthcare across all 20 Local Government Areas (LGAs) and 37 Local Council Development Areas (LCDAs) in Lagos State. Currently supporting over 100 digitized Primary Healthcare Centres (PHCs) and scaling to all 326 centers, the Board requires an integrated, resilient database architecture capable of handling longitudinal patient histories, real-time disease outbreak surveillance (e.g., Typhoid, Cholera), and multi-facility referrals without data loss or downtime.

This portfolio provides a complete, production-grade database systems solution, engineered to address the clinical and operational realities of primary care across Lagos State:
1. **Portfolio 1 (Database Design & Modelling):** Progression from raw entities/attributes (UNF) through 1NF, 2NF, and 3NF, accompanied by a 14-table relational schema with clinical & physiological check constraints (`BMI > 0`, BP ranges).
2. **Portfolio 2 (Query Processing & Optimisation):** Realistic endemic Malaria (`ICD-10: B54`) surveillance with mRDT lab confirmation and ACT prescriptions, LGA monthly immunization aggregates, and an order-of-magnitude query speedup using partial and composite B-tree indexes.
3. **Portfolio 3 (Transactions & Concurrency):** Atomic multi-step patient referrals with rollback protection, isolation level testing (preventing phantom reads), and deadlock resolution via deterministic lock ordering.
4. **Portfolio 4 (NoSQL & Advanced Data Models):** MongoDB Patient Health Profile document schema embedding longitudinal encounters and vitals, atomic CRUD scripts, and comparative architectural analysis.
5. **Portfolio 5 (Distributed & Cloud Database Architecture):** Primary-replica high availability topology, edge store-and-forward caching, PostgreSQL horizontal list partitioning by LGA with partition pruning, and CAP theorem trade-offs.
6. **Documentation & Reflections:** A formal 3-page technical report and an individual technical reflection on architectural trade-offs.

---

## 📂 Repository Directory Structure

```
.
├── detailed_problem_statement.md             # Complete project brief and grading rubric
├── docs/
│   ├── 01_technical_report.md                # 3-Page formal comprehensive technical summary
│   ├── 01_technical_report.pdf               # Rendered academic PDF publication
│   ├── 02_individual_technical_reflection.md # Personal reflection on trade-offs and lessons learned
│   ├── 02_individual_technical_reflection.pdf# Rendered reflection PDF publication
│   └── generate_submission_docs.py           # Automated Markdown-to-PDF rendering utility
├── portfolio-1-database-design/
│   ├── 01_schema.sql                        # PostgreSQL DDL for all 14 core tables + constraints
│   ├── 02_seed_data.sql                     # Rich seed dataset covering Lagos PHCs and patients
│   └── README.md                            # ER Diagram, 1NF-3NF normalization narrative, keys
├── portfolio-2-query-optimisation/
│   ├── 01_malaria_quarterly_cases.sql       # Complex analytical query with CTEs and 3 window functions (Malaria)
│   ├── 02_immunization_monthly_aggregates.sql # GROUP BY monthly batch aggregate query across LGAs
│   ├── 03_query_optimization_indexes.sql    # EXPLAIN ANALYZE benchmarks and partial B-Tree indexes
│   ├── run_portfolio_2.sh                   # Automated execution runner script
│   └── README.md                            # Execution plan profiling, before/after metrics
├── portfolio-3-transactions-concurrency/
│   ├── 01_atomic_referral_transaction.sql   # Atomic 3-step referral pipeline with COMMIT & ROLLBACK
│   ├── 02_isolation_level_setup.sql         # Appointment slot quota schema for race condition tests
│   ├── 03_inventory_deadlock_setup.sql      # Clinic drug inventory schema for deadlock tests
│   ├── test_isolation.sh                    # Parallel psql test: Read Committed vs Repeatable Read
│   ├── test_deadlock.sh                     # Live PostgreSQL deadlock reproduction and ordered resolution
│   ├── run_portfolio_3.sh                   # Automated concurrency test runner
│   └── README.md                            # ACID properties, locking mechanisms, deadlock prevention
├── portfolio-4-nosql-data-models/
│   ├── 01_patient_profile_schema.json       # JSON Schema validation for Patient Health Profile
│   ├── 02_mongo_crud_operations.js          # MongoDB shell (mongosh) atomic CRUD operations
│   ├── execute_mongo_crud.py                # Standalone runnable Python engine executing NoSQL CRUD
│   └── README.md                            # Document store modeling and PostgreSQL vs MongoDB comparison
└── portfolio-5-distributed-cloud/
    ├── 02_horizontal_partitioning_lga.sql   # Declarative table partitioning by LGA zone in PostgreSQL
    ├── run_portfolio_5.sh                   # Partitioning verification runner
    └── README.md                            # Distributed topology, replication, and CAP theorem analysis
```

---

## 🚀 Quickstart & Reproduction Guide

### Prerequisites
- **PostgreSQL 14+** (tested and verified on PostgreSQL 16.15)
- **Bash shell** (macOS / Linux / WSL)
- **Python 3.8+** (for NoSQL execution simulation)

### Step 1: Database Initialization
Create the database and execute Portfolio 1 DDL and seed data:
```bash
# Create PostgreSQL database
psql -d postgres -c "DROP DATABASE IF EXISTS lsphcb_emr;"
psql -d postgres -c "CREATE DATABASE lsphcb_emr;"

# Apply Schema DDL
psql -d lsphcb_emr -f portfolio-1-database-design/01_schema.sql

# Seed initial clinical data
psql -d lsphcb_emr -f portfolio-1-database-design/02_seed_data.sql
```

### Step 2: Run Portfolio 2 (Query Optimization Benchmarks)
```bash
chmod +x portfolio-2-query-optimisation/run_portfolio_2.sh
./portfolio-2-query-optimisation/run_portfolio_2.sh
```
*Expected Outcome:* Generates high-volume dataset, runs Malaria surveillance window query, runs LGA monthly immunization aggregates, profiles unindexed query (8.54 ms), creates partial & composite indexes, and demonstrates ~18.6x speedup (0.45 ms).

### Step 3: Run Portfolio 3 (Transactions & Concurrency Control)
```bash
chmod +x portfolio-3-transactions-concurrency/run_portfolio_3.sh
./portfolio-3-transactions-concurrency/run_portfolio_3.sh
```
*Expected Outcome:*
- Executes atomic patient referral transaction and confirms rollback on illegal self-referral.
- Runs concurrent sessions demonstrating Phantom Reads under `READ COMMITTED` and Snapshot Isolation protection under `REPEATABLE READ`.
- Reproduces a live PostgreSQL deadlock (`ERROR: deadlock detected`) and demonstrates zero-deadlock execution via deterministic key ordering.

### Step 4: Run Portfolio 4 (NoSQL Document Model Engine)
```bash
python3 portfolio-4-nosql-data-models/execute_mongo_crud.py
```
*Expected Outcome:* Validates JSON schema, inserts initial patient profile, performs single-fetch timeline query without JOIN overhead, and applies atomic `$push` updates to immunization and clinical encounter arrays.

### Step 5: Run Portfolio 5 (Distributed Partitioning)
```bash
chmod +x portfolio-5-distributed-cloud/run_portfolio_5.sh
./portfolio-5-distributed-cloud/run_portfolio_5.sh
```
*Expected Outcome:* Sets up declarative list partitioning on encounters across `LAGOS_WEST`, `LAGOS_CENTRAL`, and `LAGOS_EAST`, demonstrating **Partition Pruning** in 0.008 ms.

### Step 6: Generate Academic PDF Reports
```bash
python docs/generate_submission_docs.py
```
*Expected Outcome:* Generates styled academic HTML and PDF publications for the technical report (`docs/01_technical_report.pdf`) and individual reflection (`docs/02_individual_technical_reflection.pdf`).

---

## 📊 Summary of Technical Findings

| Portfolio Area | Key Deliverable | Verified Technical Result |
| :--- | :--- | :--- |
| **1. Database Design** | 14-Table 3NF PostgreSQL Schema | Enforces physiological check constraints ($BMI > 0$, blood pressure, temp ranges) and clinical audit foreign keys (`ON DELETE RESTRICT`). |
| **2. Query Optimization** | Malaria Surveillance Window Query & Partial Index | Slashing query latency from **8.54 ms to 0.45 ms (~18.6x speedup)** and cutting shared buffer reads by **88.4%**. |
| **3. Concurrency** | Atomic Referral & Deadlock Resolution | Proved atomicity via `ROLLBACK`, eliminated phantom reads using `REPEATABLE READ`, and resolved deadlocks via `ORDER BY id ASC FOR UPDATE`. |
| **4. NoSQL Models** | MongoDB Patient Health Profile | Single-fetch longitudinal patient view eliminating 7-table join overhead, with atomic real-time `$push` updates. |
| **5. Distributed Systems** | Primary-Replica Topology & Sharding | Designed a fault-tolerant cloud topology with edge store-and-forward caching, and demonstrated PostgreSQL partition pruning in **0.008 ms**. |

---

## 📑 Formal Reports & Documentation
- **Technical Report:** [Markdown](docs/01_technical_report.md) | [PDF Publication](docs/01_technical_report.pdf)
- **Individual Reflection:** [Markdown](docs/02_individual_technical_reflection.md) | [PDF Publication](docs/02_individual_technical_reflection.pdf)

---
*Developed for Lagos State Primary Health Care Board (LSPHCB) EMR Project & Advanced Database Systems (MIT 8103).*
