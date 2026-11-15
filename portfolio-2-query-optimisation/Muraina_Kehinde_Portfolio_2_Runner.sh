#!/usr/bin/env bash
# Runner for Portfolio 2 queries and benchmarks

set -e

DB_NAME="lsphcb_emr"

echo "--- Running Portfolio 2: Query Processing and Optimisation ---"

echo ""
echo "[1/3] Executing Task 1: Endemic Malaria Analytical Query (Fiscal Q1 2024)..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/Muraina_Kehinde_Portfolio_2_Malaria_Quarterly_Cases.sql

echo ""
echo "[2/3] Executing Task 2: Monthly Immunization Aggregates per Batch Across LGAs..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/Muraina_Kehinde_Portfolio_2_Immunization_Aggregates.sql

echo ""
echo "[3/3] Executing Task 3: EXPLAIN ANALYZE & Index Optimization..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/Muraina_Kehinde_Portfolio_2_Optimization_Indexes.sql

echo ""
echo "Portfolio 2 completed successfully."
