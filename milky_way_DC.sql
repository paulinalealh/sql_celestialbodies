-- MILKY WAY: DATA CLEANING

#Duplicating main table celestial_body

SELECT *
FROM celestial_body; 

CREATE TABLE cb
LIKE celestial_body;

SELECT *
FROM cb; 

INSERT cb 
SELECT *
FROM celestial_body; 

SELECT *
FROM cb; 

#Removing duplicated data

SELECT *, ROW_NUMBER()OVER(PARTITION BY name, type_id) AS row_num
FROM cb
ORDER BY id;    

WITH cte AS (
	SELECT *, ROW_NUMBER()OVER(PARTITION BY name, type_id) AS row_num
	FROM cb
    )
SELECT *
FROM cte 
WHERE row_num >	1;

#No duplicates in this table. 

-- Standardizing Data 

SELECT name, TRIM(name) 	
FROM cb; 

UPDATE cb 
SET name = TRIM(name);

SELECT *
FROM cb; 

#Creating similar sample sizes

SELECT type_id, COUNT(type_id) AS count_id
FROM cb
GROUP BY type_id
ORDER BY count_id DESC;

WITH sampler AS(
	SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY type_id ORDER BY RAND()) AS row_num 
	FROM cb 
)
SELECT *
FROM sampler
WHERE row_num <= 8; 

WITH sampler AS(
	SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY type_id ORDER BY RAND()) AS row_num 
	FROM cb 
)
SELECT *
FROM sampler
WHERE row_num <= 8; 

WITH sampler AS(
	SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY type_id ORDER BY RAND()) AS row_num 
	FROM cb 
)
SELECT *
FROM sampler
WHERE row_num > 8; 

SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY type_id ORDER BY RAND()) AS rn
    FROM cb
) AS t
WHERE rn > 8;

DELETE cb
FROM cb
JOIN (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY type_id ORDER BY RAND()) AS rn
    FROM cb
) AS t ON cb.id = t.id
WHERE t.rn > 8;

SELECT *
FROM cb
ORDER BY type_id; 

SELECT *
FROM cb; 

#Restarting id number
SET @row_num = 0;

UPDATE cb
JOIN (
	SELECT id, (@row_num := @row_num + 1) AS new_id
    FROM cb 
) AS numbered 	
		ON cb.id = numbered.id
SET cb.id = numbered.new_id;

SELECT *
FROM cb;

#Joining cb with constellation table
SELECT *
FROM cb 
JOIN constellation 
	ON cb.constellation_id = constellation.constellation_id;

SELECT *
FROM cb; 
    
ALTER TABLE cb
ADD COLUMN constellation_name VARCHAR(255);

SELECT *
FROM constellation;

UPDATE cb
INNER JOIN constellation ON cb.constellation_id = constellation.constellation_id
SET cb.constellation_name = constellation.name;

SELECT constellation_id, constellation_name
FROM cb
LIMIT 91;

ALTER TABLE cb
DROP COLUMN constellation_id;

SELECT *
FROM cb; 

#Joining cb with type table

SELECT *
FROM cb; 

SELECT *
FROM cb_type; 

SELECT *
FROM cb 
JOIN cb_type
	ON cb.type_id = cb_type.type_id; 
    
#Mistake noticed on cb_type: 21 and 22 are duplicates and must be changed to 23 and 24.
#Reordering values on cb_type and changing values in cb

SELECT *
FROM cb_type;

SELECT *
FROM cb_type 
WHERE name = 'Star' AND category = 'Orange Dwarf';

UPDATE cb_type 
SET type_id = 23
WHERE name = 'Star' AND category = 'Orange Dwarf'; 

UPDATE cb_type 
SET type_id = 24
WHERE name = 'Star' AND category = 'Subgiant'; 

SELECT *
FROM cb 
WHERE type_id = 21 OR type_id = 22;

SELECT *
FROM cb 
WHERE type_id = 23;

UPDATE cb 
SET type_id = 23
WHERE type_id = 21;

UPDATE cb 
SET type_id = 24
WHERE type_id = 22;

#Joining tables
SELECT * 
FROM cb
JOIN cb_type
	ON cb.type_id = cb_type.type_id; 

ALTER TABLE cb
ADD COLUMN type_name VARCHAR(255),
ADD COLUMN category VARCHAR(255),
ADD COLUMN description TEXT;

SELECT *
FROM cb; 

UPDATE cb
JOIN cb_type ON cb.type_id = cb_type.type_id
SET 
    cb.type_name = cb_type.name,
    cb.category = cb_type.category,
    cb.description = cb_type.description;
    
SELECT *
FROM cb; 

ALTER TABLE cb 
DROP COLUMN type_id; 

SELECT DISTINCT constellation_name
FROM cb; 

#Removing parenthesis
ALTER TABLE cb
    RENAME COLUMN `mass (kg)` TO mass;
    
ALTER TABLE cb
    RENAME COLUMN `radius (km)` TO radius;
    
ALTER TABLE cb
    RENAME COLUMN `temperature_low (K)` TO temp_lo;
    
ALTER TABLE cb
    RENAME COLUMN `temperature_high (K)` TO temp_hi;

SELECT *
FROM cb
WHERE mass IS NULL 
	OR radius IS NULL 
    OR temp_lo IS NULL 
    OR temp_hi IS NULL; 
    
#No nulls
    
SELECT * 
FROM cb; 

-- DATA CLEANING COMPLETE


    







    

    

    

































