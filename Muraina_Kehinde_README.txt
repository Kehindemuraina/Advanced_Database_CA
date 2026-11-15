================================================================================
LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
ADVANCED DATABASE SYSTEMS (MIT 8103) - SUBMISSION PORTFOLIO
================================================================================

STUDENT INFORMATION:
--------------------
Author / Student:    Kehinde Muraina
Student ID / Matric: 202601234
Course:              MIT 8103 - Advanced Database Systems
Academic Session:    November 2026
GitHub Repository:   https://github.com/Akinyeleib/advanced-db-systems

================================================================================
EXECUTIVE OVERVIEW
================================================================================
The Lagos State Primary Health Care Board (LSPHCB) manages primary healthcare
across all 20 LGAs and 37 LCDAs in Lagos State, coordinating over 100 digitized
Primary Healthcare Centres (PHCs) with strategic scale-up to all 326 centers.

This submission package provides a complete, production-grade database systems
portfolio engineered to meet all grading criteria and deliverables:
  - Portfolio 1 (Database Design & Modelling): UNF -> 1NF -> 2NF -> 3NF
    progression with 14 normalized tables, clinical check constraints,
    foreign keys with referential actions, and rich Lagos PHC seed data.
  - Portfolio 2 (Query Processing & Optimisation): Endemic Malaria (ICD-10 B54)
    surveillance analytical CTEs with 3 window functions, LGA monthly
    immunization batch aggregates, and ~18.6x speedup using partial B-Tree indexes.
  - Portfolio 3 (Transactions & Concurrency): Atomic 3-step patient referral
    pipeline with rollback protection, isolation level tests (Phantom Read
    protection under Repeatable Read), and deterministic deadlock resolution.
  - Portfolio 4 (NoSQL Data Models): MongoDB Patient Health Profile document
    model embedding longitudinal encounters and vitals, atomic CRUD scripts,
    and relational vs. document architectural trade-off analysis.
  - Portfolio 5 (Distributed & Cloud Databases): Primary-replica high-availability
    topology, edge store-and-forward caching, PostgreSQL horizontal list
    partitioning by LGA zone with partition pruning, and CAP theorem analysis.

================================================================================
SUBMISSION FILE MANIFEST (ALL FILES FOLLOW: Muraina_Kehinde_DocumentType.<ext>)
================================================================================

1. DOCUMENTATION & ACADEMIC REPORTS:
   - Muraina_Kehinde_README.txt
     Plain text executive overview, repo link, file index, and reproduction guide.
   - Muraina_Kehinde_README.md
     Formatted Markdown version of the submission overview.
   - Muraina_Kehinde_Technical_Report.pdf
     Comprehensive 3-page academic technical publication covering relational
     modeling, query optimization, concurrency control, and cloud architecture.
   - Muraina_Kehinde_Technical_Reflection.pdf
     Personal technical reflection detailing architectural trade-offs, lessons
     learned, and engineering decisions.
   - Muraina_Kehinde_Normalisation_ERD_Report.pdf
     Complete step-by-step normalisation walkthrough (UNF -> 1NF -> 2NF -> 3NF)
     featuring Chen-notation ER diagrams at every stage.
   - Muraina_Kehinde_AI_Use_Declaration.pdf
     Formal academic declaration on the scope, tools, and verification of AI use.
   - Muraina_Kehinde_AI_Use_Declaration.txt
     Plain text copy of the AI use declaration statement.

2. PORTFOLIO 1 - DATABASE DESIGN & MODELLING:
   - Muraina_Kehinde_Portfolio_1_Database_Design.sql
     Consolidated PostgreSQL DDL schema (14 tables + constraints) and seed dataset.
   - Muraina_Kehinde_Portfolio_1_Schema.sql
     PostgreSQL DDL schema definitions, primary/foreign keys, and check constraints.
   - Muraina_Kehinde_Portfolio_1_Seed_Data.sql
     Realistic Lagos State Primary Healthcare Board clinical seed dataset.

3. PORTFOLIO 2 - QUERY PROCESSING & OPTIMISATION:
   - Muraina_Kehinde_Portfolio_2_Query_Optimisation.sql
     Consolidated analytical queries, monthly aggregates, and index optimization benchmarks.
   - Muraina_Kehinde_Portfolio_2_Malaria_Quarterly_Cases.sql
     Complex analytical query with CTEs and 3 window functions for malaria surveillance.
   - Muraina_Kehinde_Portfolio_2_Immunization_Aggregates.sql
     LGA monthly immunization aggregate query grouping by vaccine batch.
   - Muraina_Kehinde_Portfolio_2_Optimization_Indexes.sql
     EXPLAIN ANALYZE benchmarks, baseline vs. optimized queries, and partial indexes.
   - Muraina_Kehinde_Portfolio_2_Execution_Plan_Result.png
     Visual query analyzer execution plan output and benchmark evidence.

4. PORTFOLIO 3 - TRANSACTIONS & CONCURRENCY:
   - Muraina_Kehinde_Portfolio_3_Transactions_Concurrency.sql
     Consolidated transactional pipelines, isolation schemas, and deadlock setups.
   - Muraina_Kehinde_Portfolio_3_Atomic_Referral.sql
     Atomic multi-step referral transaction with COMMIT & ROLLBACK protection.
   - Muraina_Kehinde_Portfolio_3_Isolation_Level_Setup.sql
     Schema and appointment slot quota setup for concurrent phantom read tests.
   - Muraina_Kehinde_Portfolio_3_Inventory_Deadlock_Setup.sql
     Clinic drug inventory setup for deadlock testing.
   - Muraina_Kehinde_Portfolio_3_Test_Deadlock.sh
     Automated Bash test script reproducing and resolving deadlocks.
   - Muraina_Kehinde_Portfolio_3_Test_Isolation.sh
     Automated Bash test script demonstrating Read Committed vs Repeatable Read.

5. PORTFOLIO 4 - NOSQL & ADVANCED DATA MODELS:
   - Muraina_Kehinde_Portfolio_4_Patient_Document_Schema.json
     JSON Schema validation for longitudinal MongoDB Patient Health Profile.
   - Muraina_Kehinde_Portfolio_4_Mongo_CRUD_Operations.js
     MongoDB shell (mongosh) atomic CRUD operations and clinical timeline queries.
   - Muraina_Kehinde_Portfolio_4_Execute_Mongo_CRUD.py
     Python standalone runner executing and validating MongoDB NoSQL CRUD operations.

6. PORTFOLIO 5 - DISTRIBUTED & CLOUD ARCHITECTURE:
   - Muraina_Kehinde_Portfolio_5_Horizontal_Partitioning_LGA.sql
     PostgreSQL declarative table partitioning by LGA zones with partition pruning.

7. COMPLETE REPOSITORY ARCHIVE:
   - Muraina_Kehinde_Source_Code_Repository.zip
     Full zipped clone of the development repository including scripts and docs.

================================================================================
REPRODUCTION & VERIFICATION GUIDE
================================================================================

PREREQUISITES:
- PostgreSQL 14+ (Verified on PostgreSQL 16)
- Python 3.8+
- Bash Shell (WSL, macOS, or Linux)

STEP 1: DATABASE INITIALIZATION
Execute PostgreSQL DDL schema and load clinical seed data:
  psql -d postgres -c "DROP DATABASE IF EXISTS lsphcb_emr;"
  psql -d postgres -c "CREATE DATABASE lsphcb_emr;"
  psql -d lsphcb_emr -f Muraina_Kehinde_Portfolio_1_Database_Design.sql

STEP 2: RUN QUERY OPTIMIZATION BENCHMARKS
Execute the query optimization suite:
  psql -d lsphcb_emr -f Muraina_Kehinde_Portfolio_2_Query_Optimisation.sql

STEP 3: TEST TRANSACTIONS & CONCURRENCY
Execute atomic referral transaction:
  psql -d lsphcb_emr -f Muraina_Kehinde_Portfolio_3_Transactions_Concurrency.sql

STEP 4: EXECUTE NOSQL MONGODB DEMONSTRATION
Run the standalone Python NoSQL engine:
  python Muraina_Kehinde_Portfolio_4_Execute_Mongo_CRUD.py

STEP 5: RUN DISTRIBUTED HORIZONTAL PARTITIONING
Execute declarative partitioning:
  psql -d lsphcb_emr -f Muraina_Kehinde_Portfolio_5_Horizontal_Partitioning_LGA.sql

================================================================================
End of README. Author: Kehinde Muraina (202601234)
================================================================================
