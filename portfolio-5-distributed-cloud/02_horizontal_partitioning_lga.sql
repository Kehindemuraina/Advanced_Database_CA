/* Description:
 Demonstrates horizontal partitioning in PostgreSQL using Declarative List
 Partitioning based on Lagos State administrative healthcare zones:
   1. Lagos West Zone: Alimosho, Agege, Ojo, Badagry, Ikeja, Oshodi-Isolo
   2. Lagos Central Zone: Surulere, Lagos Island, Lagos Mainland, Mushin, Apapa
   3. Lagos East Zone: Ikorodu, Kosofe, Somolu, Epe, Ibeju-Lekki, Eti-Osa
 Includes partition pruning demonstration via EXPLAIN ANALYZE.
*/
DROP TABLE IF EXISTS encounter_partitioned CASCADE;

-- Master Partitioned Table (Partitioned by LIST on administrative zone)
CREATE TABLE encounter_partitioned (
    encounter_id SERIAL,
    patient_id INT NOT NULL,
    facility_id INT NOT NULL,
    staff_id INT NOT NULL,
    lga_zone VARCHAR(30) NOT NULL, -- Partition Key: 'LAGOS_WEST', 'LAGOS_CENTRAL', 'LAGOS_EAST'
    visit_date DATE NOT NULL,
    visit_time TIME NOT NULL DEFAULT CURRENT_TIME,
    encounter_type VARCHAR(50) NOT NULL,
    chief_complaint TEXT NOT NULL,
    presenting_symptoms TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Completed',
    PRIMARY KEY (encounter_id, lga_zone) -- Partition key must be part of composite primary key
) PARTITION BY LIST (lga_zone);

-- Create Regional Child Partitions

-- Partition 1: Lagos West Health District
CREATE TABLE encounter_lagos_west PARTITION OF encounter_partitioned
    FOR VALUES IN ('LAGOS_WEST');

-- Partition 2: Lagos Central Health District
CREATE TABLE encounter_lagos_central PARTITION OF encounter_partitioned
    FOR VALUES IN ('LAGOS_CENTRAL');

-- Partition 3: Lagos East Health District
CREATE TABLE encounter_lagos_east PARTITION OF encounter_partitioned
    FOR VALUES IN ('LAGOS_EAST');

-- Create regional indexes on each partition
CREATE INDEX idx_west_date ON encounter_lagos_west (visit_date);
CREATE INDEX idx_central_date ON encounter_lagos_central (visit_date);
CREATE INDEX idx_east_date ON encounter_lagos_east (visit_date);

-- Seed Data Across Regional Partitions
-- West encounters (Alimosho, Ikeja)
INSERT INTO encounter_partitioned (patient_id, facility_id, staff_id, lga_zone, visit_date, encounter_type, chief_complaint, presenting_symptoms)
VALUES
(1, 1, 1, 'LAGOS_WEST', '2024-02-10', 'Outpatient', 'High fever and abdominal discomfort', 'Typhoid presentation'),
(3, 3, 6, 'LAGOS_WEST', '2024-03-02', 'Immunization', 'Routine 9-month immunization', 'Infant checkup'),
(5, 1, 1, 'LAGOS_WEST', '2024-03-25', 'Outpatient', 'Step ladder pyrexia', 'Enteric fever signs');

-- Central encounters (Surulere, Lagos Island, Mushin)
INSERT INTO encounter_partitioned (patient_id, facility_id, staff_id, lga_zone, visit_date, encounter_type, chief_complaint, presenting_symptoms)
VALUES
(2, 2, 3, 'LAGOS_CENTRAL', '2024-02-15', 'Antenatal', '24-week ANC review', 'Maternal checkup'),
(4, 4, 7, 'LAGOS_CENTRAL', '2024-03-18', 'Outpatient', 'Elevated systolic pressure', 'Hypertension review'),
(6, 6, 9, 'LAGOS_CENTRAL', '2024-04-05', 'Emergency', 'Acute gastroenteritis', 'Dehydration presentation'),
(10, 2, 3, 'LAGOS_CENTRAL', '2024-03-12', 'Outpatient', 'Severe continuous fever', 'Complicated typhoid');

-- East encounters (Ikorodu, Kosofe, Eti-Osa)
INSERT INTO encounter_partitioned (patient_id, facility_id, staff_id, lga_zone, visit_date, encounter_type, chief_complaint, presenting_symptoms)
VALUES
(7, 7, 10, 'LAGOS_EAST', '2024-01-20', 'Outpatient', 'Fever with chills and headache', 'Malaria/Typhoid screening'),
(8, 8, 3, 'LAGOS_EAST', '2024-02-28', 'Outpatient', 'Persistent pyrexia', 'Clinical evaluation'),
(5, 5, 8, 'LAGOS_EAST', '2024-06-02', 'Outpatient', 'Upper respiratory symptoms', 'Catarrh and mild cough');

-- Verification: Querying Partitions Directly
SELECT 'encounter_lagos_west' AS partition_name, count(*) AS total_records FROM encounter_lagos_west
UNION ALL
SELECT 'encounter_lagos_central', count(*) FROM encounter_lagos_central
UNION ALL
SELECT 'encounter_lagos_east', count(*) FROM encounter_lagos_east;

-- Demonstration: Partition Pruning (EXPLAIN ANALYZE)
-- Query targeting LAGOS_WEST only scans encounter_lagos_west and prunes others
EXPLAIN (ANALYZE, BUFFERS)
SELECT encounter_id, patient_id, facility_id, visit_date, chief_complaint
FROM encounter_partitioned
WHERE lga_zone = 'LAGOS_WEST' AND visit_date >= '2024-02-01';
