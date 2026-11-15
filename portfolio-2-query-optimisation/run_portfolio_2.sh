#!/usr/bin/env bash
# Runner for Portfolio 2 queries and benchmarks

set -e

DB_NAME="lsphcb_emr"

echo "--- Running Portfolio 2: Query Processing and Optimisation ---"

echo ""
echo "[1/3] Executing Task 1: Endemic Malaria Analytical Query (Fiscal Q1 2024)..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/01_malaria_quarterly_cases.sql

echo ""
echo "[2/3] Executing Task 2: Monthly Immunization Aggregates per Batch Across LGAs..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/02_immunization_monthly_aggregates.sql

echo ""
echo "[3/3] Executing Task 3: EXPLAIN ANALYZE & Index Optimization..."
psql -d "$DB_NAME" -f portfolio-2-query-optimisation/03_query_optimization_indexes.sql

echo ""
echo "Portfolio 2 completed successfully."
