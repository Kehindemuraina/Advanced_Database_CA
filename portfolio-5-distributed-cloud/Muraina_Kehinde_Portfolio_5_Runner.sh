#!/usr/bin/env bash
# Runner for Portfolio 5 distributed partitioning

set -e

DB_NAME="lsphcb_emr"

echo "--- Running Portfolio 5: Distributed and Cloud Partitioning ---"

echo ""
echo "[1/2] Executing Horizontal Partitioning by Administrative LGA Zones..."
psql -d "$DB_NAME" -f portfolio-5-distributed-cloud/Muraina_Kehinde_Portfolio_5_Horizontal_Partitioning_LGA.sql

echo ""
echo "[2/2] Distributed Topology & CAP Theorem Analysis documented in README.md."
echo ""
echo "Portfolio 5 completed successfully."
