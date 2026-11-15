#!/usr/bin/env python3
"""
package_submission.py
Automated submission packager for Kehinde Muraina (MIT 8103).
Strictly adheres to:
1. Folder Naming Convention: Surname_Firstname_StudentID (e.g. Muraina_Kehinde_202601234)
2. File Naming Convention:   Surname_Firstname_DocumentType.<ext> (e.g. Muraina_Kehinde_README.txt)
"""

import os
import sys
import shutil
import re
import zipfile
import argparse
from pathlib import Path

SURNAME_DEFAULT = "Muraina"
FIRSTNAME_DEFAULT = "Kehinde"
STUDENT_ID_DEFAULT = "202601234"
COURSE_CODE = "MIT 8103"
COURSE_TITLE = "Advanced Database Systems"
PROJECT_TITLE = "Lagos State Primary Health Care Board (LSPHCB) EMR System"
GITHUB_REPO = "https://github.com/Akinyeleib/advanced-db-systems"


def find_file(directory: Path, *candidates: str) -> Path | None:
    for c in candidates:
        p = directory / c
        if p.exists():
            return p
    return None


def generate_readme_txt(surname: str, firstname: str, student_id: str) -> str:
    prefix = f"{surname}_{firstname}"
    return f"""================================================================================
LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
ADVANCED DATABASE SYSTEMS (MIT 8103) - SUBMISSION PORTFOLIO
================================================================================

STUDENT INFORMATION:
--------------------
Author / Student:    {firstname} {surname}
Student ID / Matric: {student_id}
Course:              {COURSE_CODE} - {COURSE_TITLE}
Academic Session:    November 2026
GitHub Repository:   {GITHUB_REPO}

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
SUBMISSION FILE MANIFEST (ALL FILES FOLLOW: {prefix}_DocumentType.<ext>)
================================================================================

1. DOCUMENTATION & ACADEMIC REPORTS:
   - {prefix}_README.txt
     Plain text executive overview, repo link, file index, and reproduction guide.
   - {prefix}_README.md
     Formatted Markdown version of the submission overview.
   - {prefix}_Technical_Report.pdf
     Comprehensive 3-page academic technical publication covering relational
     modeling, query optimization, concurrency control, and cloud architecture.
   - {prefix}_Technical_Reflection.pdf
     Personal technical reflection detailing architectural trade-offs, lessons
     learned, and engineering decisions.
   - {prefix}_Normalisation_ERD_Report.pdf
     Complete step-by-step normalisation walkthrough (UNF -> 1NF -> 2NF -> 3NF)
     featuring Chen-notation ER diagrams at every stage.
   - {prefix}_AI_Use_Declaration.pdf
     Formal academic declaration on the scope, tools, and verification of AI use.
   - {prefix}_AI_Use_Declaration.txt
     Plain text copy of the AI use declaration statement.

2. PORTFOLIO 1 - DATABASE DESIGN & MODELLING:
   - {prefix}_Portfolio_1_Database_Design.sql
     Consolidated PostgreSQL DDL schema (14 tables + constraints) and seed dataset.
   - {prefix}_Portfolio_1_Schema.sql
     PostgreSQL DDL schema definitions, primary/foreign keys, and check constraints.
   - {prefix}_Portfolio_1_Seed_Data.sql
     Realistic Lagos State Primary Healthcare Board clinical seed dataset.

3. PORTFOLIO 2 - QUERY PROCESSING & OPTIMISATION:
   - {prefix}_Portfolio_2_Query_Optimisation.sql
     Consolidated analytical queries, monthly aggregates, and index optimization benchmarks.
   - {prefix}_Portfolio_2_Malaria_Quarterly_Cases.sql
     Complex analytical query with CTEs and 3 window functions for malaria surveillance.
   - {prefix}_Portfolio_2_Immunization_Aggregates.sql
     LGA monthly immunization aggregate query grouping by vaccine batch.
   - {prefix}_Portfolio_2_Optimization_Indexes.sql
     EXPLAIN ANALYZE benchmarks, baseline vs. optimized queries, and partial indexes.
   - {prefix}_Portfolio_2_Execution_Plan_Result.png
     Visual query analyzer execution plan output and benchmark evidence.

4. PORTFOLIO 3 - TRANSACTIONS & CONCURRENCY:
   - {prefix}_Portfolio_3_Transactions_Concurrency.sql
     Consolidated transactional pipelines, isolation schemas, and deadlock setups.
   - {prefix}_Portfolio_3_Atomic_Referral.sql
     Atomic multi-step referral transaction with COMMIT & ROLLBACK protection.
   - {prefix}_Portfolio_3_Isolation_Level_Setup.sql
     Schema and appointment slot quota setup for concurrent phantom read tests.
   - {prefix}_Portfolio_3_Inventory_Deadlock_Setup.sql
     Clinic drug inventory setup for deadlock testing.
   - {prefix}_Portfolio_3_Test_Deadlock.sh
     Automated Bash test script reproducing and resolving deadlocks.
   - {prefix}_Portfolio_3_Test_Isolation.sh
     Automated Bash test script demonstrating Read Committed vs Repeatable Read.

5. PORTFOLIO 4 - NOSQL & ADVANCED DATA MODELS:
   - {prefix}_Portfolio_4_Patient_Document_Schema.json
     JSON Schema validation for longitudinal MongoDB Patient Health Profile.
   - {prefix}_Portfolio_4_Mongo_CRUD_Operations.js
     MongoDB shell (mongosh) atomic CRUD operations and clinical timeline queries.
   - {prefix}_Portfolio_4_Execute_Mongo_CRUD.py
     Python standalone runner executing and validating MongoDB NoSQL CRUD operations.

6. PORTFOLIO 5 - DISTRIBUTED & CLOUD ARCHITECTURE:
   - {prefix}_Portfolio_5_Horizontal_Partitioning_LGA.sql
     PostgreSQL declarative table partitioning by LGA zones with partition pruning.

7. COMPLETE REPOSITORY ARCHIVE:
   - {prefix}_Source_Code_Repository.zip
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
  psql -d lsphcb_emr -f {prefix}_Portfolio_1_Database_Design.sql

STEP 2: RUN QUERY OPTIMIZATION BENCHMARKS
Execute the query optimization suite:
  psql -d lsphcb_emr -f {prefix}_Portfolio_2_Query_Optimisation.sql

STEP 3: TEST TRANSACTIONS & CONCURRENCY
Execute atomic referral transaction:
  psql -d lsphcb_emr -f {prefix}_Portfolio_3_Transactions_Concurrency.sql

STEP 4: EXECUTE NOSQL MONGODB DEMONSTRATION
Run the standalone Python NoSQL engine:
  python {prefix}_Portfolio_4_Execute_Mongo_CRUD.py

STEP 5: RUN DISTRIBUTED HORIZONTAL PARTITIONING
Execute declarative partitioning:
  psql -d lsphcb_emr -f {prefix}_Portfolio_5_Horizontal_Partitioning_LGA.sql

================================================================================
End of README. Author: {firstname} {surname} ({student_id})
================================================================================
"""


def package(surname: str, firstname: str, student_id: str, repo_root: Path):
    prefix = f"{surname}_{firstname}"
    folder_name = f"{prefix}_{student_id}"
    target_dir = repo_root / folder_name

    print(f"[1/6] Initializing submission folder: {folder_name}...")
    if target_dir.exists():
        shutil.rmtree(target_dir)
    target_dir.mkdir(parents=True, exist_ok=True)

    # 1. README files
    print(f"[2/6] Generating README files...")
    readme_txt_path = target_dir / f"{prefix}_README.txt"
    readme_txt_path.write_text(generate_readme_txt(surname, firstname, student_id), encoding="utf-8")

    readme_src = find_file(repo_root, f"{prefix}_README.md", "README.md")
    if readme_src:
        shutil.copy2(readme_src, target_dir / f"{prefix}_README.md")

    # 2. PDF Reports & Documentation
    print(f"[3/6] Staging PDF academic reports & declarations...")
    docs_dir = repo_root / "docs"

    doc_specs = [
        ([f"{prefix}_Technical_Report.pdf", "01_technical_report.pdf"], f"{prefix}_Technical_Report.pdf"),
        ([f"{prefix}_Technical_Reflection.pdf", "02_individual_technical_reflection.pdf"], f"{prefix}_Technical_Reflection.pdf"),
        ([f"{prefix}_Normalisation_ERD_Report.pdf", "LSPHCB_Normalisation_ERD_Report.pdf"], f"{prefix}_Normalisation_ERD_Report.pdf"),
        ([f"{prefix}_AI_Use_Declaration.pdf", "AI_USE_DECLARATION.pdf"], f"{prefix}_AI_Use_Declaration.pdf"),
        ([f"{prefix}_AI_Use_Declaration.txt", f"{prefix}_AI_Use_Declaration.md", "AI_USE_DECLARATION.md"], f"{prefix}_AI_Use_Declaration.txt"),
    ]

    for candidates, dst_name in doc_specs:
        src_file = find_file(docs_dir, *candidates)
        if src_file:
            shutil.copy2(src_file, target_dir / dst_name)
            print(f"  + Copied: {dst_name} ({src_file.stat().st_size:,} bytes)")
        else:
            print(f"  ! Warning: {candidates[0]} not found in docs/")

    # 3. Portfolio Code Deliverables
    print(f"[4/6] Staging Portfolio SQL & Code Deliverables...")

    # Portfolio 1
    p1_dir = repo_root / "portfolio-1-database-design"
    p1_schema = find_file(p1_dir, f"{prefix}_Portfolio_1_Schema.sql", "01_schema.sql")
    p1_seed = find_file(p1_dir, f"{prefix}_Portfolio_1_Seed_Data.sql", "02_seed_data.sql")
    p1_consolidated = find_file(p1_dir, f"{prefix}_Portfolio_1_Database_Design.sql")

    if p1_consolidated:
        shutil.copy2(p1_consolidated, target_dir / f"{prefix}_Portfolio_1_Database_Design.sql")
        print(f"  + Copied: {prefix}_Portfolio_1_Database_Design.sql")
    elif p1_schema and p1_seed:
        p1_combined = target_dir / f"{prefix}_Portfolio_1_Database_Design.sql"
        with open(p1_combined, "w", encoding="utf-8") as outfile:
            outfile.write(f"-- LSPHCB EMR System - Portfolio 1: Database Design & Modeling\n")
            outfile.write(f"-- Author: {firstname} {surname} ({student_id})\n")
            outfile.write(f"-- Consolidated Schema DDL and Seed Data\n\n")
            outfile.write("-- PART 1: RELATIONAL SCHEMA DEFINITIONS & CONSTRAINTS\n")
            outfile.write(p1_schema.read_text(encoding="utf-8"))
            outfile.write("\n\n-- PART 2: CLINICAL SEED DATASET\n")
            outfile.write(p1_seed.read_text(encoding="utf-8"))
        print(f"  + Generated: {prefix}_Portfolio_1_Database_Design.sql ({p1_combined.stat().st_size:,} bytes)")

    if p1_schema:
        shutil.copy2(p1_schema, target_dir / f"{prefix}_Portfolio_1_Schema.sql")
    if p1_seed:
        shutil.copy2(p1_seed, target_dir / f"{prefix}_Portfolio_1_Seed_Data.sql")

    # Portfolio 2
    p2_dir = repo_root / "portfolio-2-query-optimisation"
    p2_q1 = find_file(p2_dir, f"{prefix}_Portfolio_2_Malaria_Quarterly_Cases.sql", "01_malaria_quarterly_cases.sql")
    p2_q2 = find_file(p2_dir, f"{prefix}_Portfolio_2_Immunization_Aggregates.sql", "02_immunization_monthly_aggregates.sql")
    p2_q3 = find_file(p2_dir, f"{prefix}_Portfolio_2_Optimization_Indexes.sql", "03_query_optimization_indexes.sql")
    p2_img = find_file(p2_dir, f"{prefix}_Portfolio_2_Execution_Plan_Result.png", "Query Analyzer Result.png")
    p2_consolidated = find_file(p2_dir, f"{prefix}_Portfolio_2_Query_Optimisation.sql")

    if p2_consolidated:
        shutil.copy2(p2_consolidated, target_dir / f"{prefix}_Portfolio_2_Query_Optimisation.sql")
        print(f"  + Copied: {prefix}_Portfolio_2_Query_Optimisation.sql")
    elif p2_q1 and p2_q2 and p2_q3:
        p2_combined = target_dir / f"{prefix}_Portfolio_2_Query_Optimisation.sql"
        with open(p2_combined, "w", encoding="utf-8") as outfile:
            outfile.write(f"-- LSPHCB EMR System - Portfolio 2: Query Processing & Optimization\n")
            outfile.write(f"-- Author: {firstname} {surname} ({student_id})\n")
            outfile.write(f"-- Consolidated Analytical Queries and Index Optimizations\n\n")
            outfile.write("-- QUERY 1: MALARIA QUARTERLY CASE SURVEILLANCE WITH WINDOW FUNCTIONS\n")
            outfile.write(p2_q1.read_text(encoding="utf-8"))
            outfile.write("\n\n-- QUERY 2: MONTHLY IMMUNIZATION BATCH AGGREGATES BY LGA\n")
            outfile.write(p2_q2.read_text(encoding="utf-8"))
            outfile.write("\n\n-- QUERY 3: EXPLAIN ANALYZE BENCHMARKS & PARTIAL B-TREE INDEXES\n")
            outfile.write(p2_q3.read_text(encoding="utf-8"))
        print(f"  + Generated: {prefix}_Portfolio_2_Query_Optimisation.sql ({p2_combined.stat().st_size:,} bytes)")

    if p2_q1:
        shutil.copy2(p2_q1, target_dir / f"{prefix}_Portfolio_2_Malaria_Quarterly_Cases.sql")
    if p2_q2:
        shutil.copy2(p2_q2, target_dir / f"{prefix}_Portfolio_2_Immunization_Aggregates.sql")
    if p2_q3:
        shutil.copy2(p2_q3, target_dir / f"{prefix}_Portfolio_2_Optimization_Indexes.sql")
    if p2_img:
        shutil.copy2(p2_img, target_dir / f"{prefix}_Portfolio_2_Execution_Plan_Result.png")

    # Portfolio 3
    p3_dir = repo_root / "portfolio-3-transactions-concurrency"
    p3_t1 = find_file(p3_dir, f"{prefix}_Portfolio_3_Atomic_Referral.sql", "01_atomic_referral_transaction.sql")
    p3_t2 = find_file(p3_dir, f"{prefix}_Portfolio_3_Isolation_Level_Setup.sql", "02_isolation_level_setup.sql")
    p3_t3 = find_file(p3_dir, f"{prefix}_Portfolio_3_Inventory_Deadlock_Setup.sql", "03_inventory_deadlock_setup.sql")
    p3_sh1 = find_file(p3_dir, f"{prefix}_Portfolio_3_Test_Deadlock.sh", "test_deadlock.sh")
    p3_sh2 = find_file(p3_dir, f"{prefix}_Portfolio_3_Test_Isolation.sh", "test_isolation.sh")
    p3_consolidated = find_file(p3_dir, f"{prefix}_Portfolio_3_Transactions_Concurrency.sql")

    if p3_consolidated:
        shutil.copy2(p3_consolidated, target_dir / f"{prefix}_Portfolio_3_Transactions_Concurrency.sql")
        print(f"  + Copied: {prefix}_Portfolio_3_Transactions_Concurrency.sql")
    elif p3_t1 and p3_t2 and p3_t3:
        p3_combined = target_dir / f"{prefix}_Portfolio_3_Transactions_Concurrency.sql"
        with open(p3_combined, "w", encoding="utf-8") as outfile:
            outfile.write(f"-- LSPHCB EMR System - Portfolio 3: Transactions & Concurrency\n")
            outfile.write(f"-- Author: {firstname} {surname} ({student_id})\n")
            outfile.write(f"-- Consolidated Transactions, Isolation Levels & Deadlocks\n\n")
            outfile.write("-- PART 1: ATOMIC PATIENT REFERRAL TRANSACTION PIPELINE\n")
            outfile.write(p3_t1.read_text(encoding="utf-8"))
            outfile.write("\n\n-- PART 2: ISOLATION LEVEL & APPOINTMENT QUOTA SETUP\n")
            outfile.write(p3_t2.read_text(encoding="utf-8"))
            outfile.write("\n\n-- PART 3: INVENTORY DEADLOCK SIMULATION SETUP\n")
            outfile.write(p3_t3.read_text(encoding="utf-8"))
        print(f"  + Generated: {prefix}_Portfolio_3_Transactions_Concurrency.sql ({p3_combined.stat().st_size:,} bytes)")

    if p3_t1:
        shutil.copy2(p3_t1, target_dir / f"{prefix}_Portfolio_3_Atomic_Referral.sql")
    if p3_t2:
        shutil.copy2(p3_t2, target_dir / f"{prefix}_Portfolio_3_Isolation_Level_Setup.sql")
    if p3_t3:
        shutil.copy2(p3_t3, target_dir / f"{prefix}_Portfolio_3_Inventory_Deadlock_Setup.sql")
    if p3_sh1:
        shutil.copy2(p3_sh1, target_dir / f"{prefix}_Portfolio_3_Test_Deadlock.sh")
    if p3_sh2:
        shutil.copy2(p3_sh2, target_dir / f"{prefix}_Portfolio_3_Test_Isolation.sh")

    # Portfolio 4
    p4_dir = repo_root / "portfolio-4-nosql-data-models"
    p4_schema = find_file(p4_dir, f"{prefix}_Portfolio_4_Patient_Document_Schema.json", "01_patient_profile_schema.json")
    p4_crud = find_file(p4_dir, f"{prefix}_Portfolio_4_Mongo_CRUD_Operations.js", "02_mongo_crud_operations.js")
    p4_py = find_file(p4_dir, f"{prefix}_Portfolio_4_Execute_Mongo_CRUD.py", "execute_mongo_crud.py")

    if p4_schema:
        shutil.copy2(p4_schema, target_dir / f"{prefix}_Portfolio_4_Patient_Document_Schema.json")
    if p4_crud:
        shutil.copy2(p4_crud, target_dir / f"{prefix}_Portfolio_4_Mongo_CRUD_Operations.js")
    if p4_py:
        shutil.copy2(p4_py, target_dir / f"{prefix}_Portfolio_4_Execute_Mongo_CRUD.py")

    # Portfolio 5
    p5_dir = repo_root / "portfolio-5-distributed-cloud"
    p5_sql = find_file(p5_dir, f"{prefix}_Portfolio_5_Horizontal_Partitioning_LGA.sql", "02_horizontal_partitioning_lga.sql")
    if p5_sql:
        shutil.copy2(p5_sql, target_dir / f"{prefix}_Portfolio_5_Horizontal_Partitioning_LGA.sql")

    # 4. Source Code Repository Archive
    print(f"[5/6] Creating compressed source repository archive...")
    zip_inside_name = f"{prefix}_Source_Code_Repository.zip"
    zip_inside_path = target_dir / zip_inside_name

    def zip_filter(p: Path) -> bool:
        parts = p.parts
        ignored_names = {".git", ".venv", "venv", "env", "__pycache__", "scratch", folder_name}
        for ignored in ignored_names:
            if ignored in parts:
                return False
        if p.name.endswith(".zip") or p.name.endswith(".log"):
            return False
        return True

    with zipfile.ZipFile(zip_inside_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for file_path in repo_root.rglob("*"):
            if file_path.is_file() and zip_filter(file_path):
                arcname = file_path.relative_to(repo_root)
                zf.write(file_path, arcname)
    print(f"  + Created: {zip_inside_name} ({zip_inside_path.stat().st_size:,} bytes)")

    # Root submission zip
    root_zip_path = repo_root / f"{folder_name}.zip"
    with zipfile.ZipFile(root_zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for file_path in target_dir.rglob("*"):
            if file_path.is_file():
                arcname = file_path.relative_to(repo_root)
                zf.write(file_path, arcname)
    print(f"  + Created Root Submission Archive: {root_zip_path.name} ({root_zip_path.stat().st_size:,} bytes)")

    # 5. Rigorous Compliance Verification
    print(f"\n[6/6] Executing Regex Compliance & Integrity Validation...")
    pattern = re.compile(rf"^{prefix}_[A-Za-z0-9_]+\.[a-zA-Z0-9]+$")
    all_files = list(target_dir.iterdir())
    violations = []
    manifest_rows = []

    for f in all_files:
        if not f.is_file():
            violations.append(f"Directory found inside submission: {f.name}")
            continue
        if not pattern.match(f.name):
            violations.append(f"Convention violation: {f.name} does not match {prefix}_DocumentType.<ext>")
        size = f.stat().st_size
        if size == 0:
            violations.append(f"Empty file: {f.name}")
        manifest_rows.append((f.name, size))

    if violations:
        print("FAIL: Validation encountered errors:")
        for v in violations:
            print(f"  - {v}")
        sys.exit(1)

    print("SUCCESS: 100% of files strictly comply with the naming convention!")
    print(f"\nSubmission Directory: {target_dir.resolve()}")
    print("=" * 80)
    print(f"{'Filename':<60} | {'Size':>12}")
    print("-" * 80)
    for name, size in sorted(manifest_rows):
        print(f"{name:<60} | {size:>10,} B")
    print("=" * 80)
    print(f"Total Files: {len(manifest_rows)}")
    print(f"Root Zip:    {root_zip_path.resolve()}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Package submission according to strict university naming rules.")
    parser.add_argument("--surname", default=SURNAME_DEFAULT, help="Student surname")
    parser.add_argument("--firstname", default=FIRSTNAME_DEFAULT, help="Student first name")
    parser.add_argument("--student-id", default=STUDENT_ID_DEFAULT, help="Student ID / Matric Number")

    args = parser.parse_args()
    root_path = Path(__file__).resolve().parent
    package(args.surname, args.firstname, args.student_id, root_path)
