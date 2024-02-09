SELECT *
FROM drug;

SELECT *
FROM overdose_deaths;

SELECT *
FROM prescriber
WHERE npi = '1881634483';

/* Number 1.  */
-- A.
SELECT npi, SUM(total_claim_count) as total
FROM prescription
GROUP BY npi
ORDER BY total DESC;

--B.
SELECT ps1.npi, ps1.nppes_provider_last_org_name AS last_name,ps1.nppes_provider_first_name AS first_name, 
	   ps1.specialty_description AS specialty, SUM(total_claim_count) AS total_claims
FROM prescriber AS ps1 INNER JOIN prescription AS ps2 ON ps1.npi = ps2.npi
GROUP By ps1.npi, ps1.nppes_provider_last_org_name, ps1.nppes_provider_first_name, ps1.specialty_description
ORDER BY total_claims DESC;

/* Number 2 */
-- A.
SELECT ps1.specialty_description AS specialty, SUM(total_claim_count) AS total_claims
FROM prescriber AS ps1 INNER JOIN prescription AS ps2 USING(npi)
GROUP BY ps1.specialty_description
ORDER BY total_claims DESC;

-- B.
SELECT ps2.specialty_description AS specialty, drug.opioid_drug_flag AS opioid, SUM(total_claim_count) AS total_claims
FROM prescription AS ps1 INNER JOIN prescriber AS ps2 ON ps1.npi = ps2.npi
						 INNER JOIN drug ON ps1.drug_name = drug.drug_name
WHERE drug.opioid_drug_flag LIKE 'Y'
GROUP BY ps2.specialty_description, drug.opioid_drug_flag
ORDER BY total_claims DESC;

/* Number 3. */
-- A.
SELECT drug.generic_name, SUM(total_drug_cost::money) AS total_cost
FROM prescription AS ps1 INNER JOIN drug USING(drug_name)
GROUP BY drug.generic_name
ORDER BY total_cost DESC;

-- B.
SELECT drug.generic_name,ROUND(SUM(ps1.total_drug_cost)/SUM(ps1.total_day_supply),2) AS cost_per_day
FROM prescription AS ps1 INNER JOIN drug USING(drug_name)
GROUP BY drug.generic_name
ORDER BY cost_per_day DESC;

SELECT *
FROM prescription
WHERE drug_name ILIKE 'esbriet';

/* Number 4. */
-- A.
SELECT drug_name, (CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
					   WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
					   ELSE'neither' END) AS drug_type
FROM drug;

-- B.
SELECT (CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		ELSE 'neither' END) AS drug_type,
		SUM(total_drug_cost)::money AS total_cost
FROM drug INNER JOIN prescription USING (drug_name)
GROUP BY drug_type
ORDER BY total_cost DESC;

/* Number 5. */
-- A.
SELECT COUNT(fipscounty)
FROM cbsa
WHERE cbsaname LIKE '%TN%';

-- B.
SELECT cbsaname, SUM(population) AS total_population
FROM cbsa INNER JOIN population USING (fipscounty)
GROUP BY cbsaname
ORDER BY total_population DESC;

-- C.
SELECT fc1.county, SUM(p1.population) AS county_population
FROM cbsa AS c1 INNER JOIN population AS p1 USING (fipscounty)
		  		INNER JOIN fips_county AS fc1 USING (fipscounty)
GROUP BY fc1.county
ORDER by county_population DESC;

/* Number 6. */
-- A. 
WITH total_claims AS 
					(SELECT npi, drug_name, total_claim_count 
					 FROM prescription
					 WHERE total_claim_count > 3000)
-- B and C. 		 
SELECT nppes_provider_first_name AS first_name, 
	   nppes_provider_last_org_name AS last_name, 
	   drug_name, 
	   total_claim_count, 
	   opioid_drug_flag
FROM total_claims INNER JOIN drug USING (drug_name)
				  INNER JOIN prescriber USING (npi)
ORDER BY opioid_drug_flag DESC;

/* Number 7 */
-- A. 
SELECT 
FROM prescription AS ps1 INNER JOIN prescriber AS ps2 USING (npi)
			     		 INNER JOIN drug AS dr1 USING (drug_name) 
WHERE specialty_description ILIKE '%Pain Management%'













