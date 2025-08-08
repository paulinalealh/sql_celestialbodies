-- MILKY WAY: Data Cleaning

SELECT *
FROM celestial_body;

#Creating a copy of celestial_body
CREATE TABLE cb
LIKE celestial_body;

SELECT * 
FROM cb;  

INSERT cb
SELECT *
FROM celestial_body;

SELECT *
FROM cb; 

#Checking of duplicates
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY name) AS row_num
FROM cb; 

#Removing duplicates
WITH duplicate_cte AS(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY name) AS row_num
    FROM cb
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;






