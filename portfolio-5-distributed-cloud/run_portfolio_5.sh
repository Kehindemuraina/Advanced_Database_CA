#!/usr/bin/env bash
# ============================================================================
# LAGOS STATE PRIMARY HEALTH CARE BOARD (LSPHCB) EMR SYSTEM
# Portfolio 5: Distributed & Cloud Database Runner
# ============================================================================

set -e

DB_NAME="lsphcb_emr"

echo "======================================================================"
echo "RUNNING PORTFOLIO 5: DISTRIBUTED & CLOUD DATABASE EXERCISE"
echo "======================================================================"

echo ""
echo "[1/2] Executing Horizontal Partitioning by Administrative LGA Zones..."
psql -d "$DB_NAME" -f portfolio-5-distributed-cloud/02_horizontal_partitioning_lga.sql

echo ""
echo "[2/2] Distributed Topology & CAP Theorem Analysis documented in README.md."
echo ""
echo "Portfolio 5 completed successfully."
