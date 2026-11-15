/* 
Task:
 the monthly total number of immunization doses administered per vaccine 
 batch across all Lagos State local government areas (LGAs).
*/
SELECT 
    f.lga AS local_government_area,
    TO_CHAR(i.administration_date, 'YYYY-MM') AS administration_month,
    i.vaccine_name,
    i.batch_number,
    COUNT(i.immunization_id) AS total_doses_administered,
    COUNT(DISTINCT i.patient_id) AS unique_children_vaccinated,
    MIN(i.administration_date) AS first_dose_date,
    MAX(i.administration_date) AS last_dose_date
FROM immunization i
JOIN encounter e ON i.encounter_id = e.encounter_id
JOIN facility f ON e.facility_id = f.facility_id
GROUP BY 
    f.lga, 
    TO_CHAR(i.administration_date, 'YYYY-MM'),
    i.vaccine_name, 
    i.batch_number
ORDER BY 
    f.lga, 
    administration_month, 
    total_doses_administered DESC,
    i.vaccine_name;
