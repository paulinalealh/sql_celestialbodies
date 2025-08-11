-- Exploratory Data Analysis

SELECT *
FROM cb; 

#Average Radius(km): 76190110589531.31 km
SELECT AVG(radius)
FROM cb;

#Most and least common constellation in sample: Sagittarius and Draco
SELECT constellation_name, COUNT(constellation_name) AS const_count
FROM cb
GROUP BY constellation_name
ORDER BY const_count DESC; 

# Top 3 celestial bodies with largest mass in sample: Sagittarius A, Carina Nebula and N44
SELECT *, DENSE_RANK() OVER(ORDER BY mass DESC) AS Ranking
FROM cb
LIMIT 3;

#Average mass of all stars: 1.7357684210526314e30
SELECT type_name, AVG(mass)
FROM cb 
WHERE type_name = 'Star'
GROUP BY type_name;

#Coldest celestial body: GAIA BH2
SELECT *
FROM cb
ORDER BY temp_lo ASC
LIMIT 1;

#Mass Rolling Total
WITH mass_rt AS(
SELECT name, SUM(mass) AS mass
FROM cb
WHERE name IS NOT NULL
GROUP BY name
ORDER BY 1
)
SELECT name, mass,
SUM(mass) OVER(ORDER BY mass) AS mass_rt
FROM mass_rt;


#Average temperature per body 
SELECT *, (temp_lo + temp_hi)/2 as avg_temp
FROM cb
ORDER BY avg_temp;

#Most common category of Black Holes: Stellar-Mass
SELECT category, COUNT(category) as bh_count
FROM cb 
WHERE type_name LIKE 'Black Hole'
GROUP BY category
ORDER BY bh_count DESC;

#Median Constellation: Virgo 
WITH ordered AS (
  SELECT *,
         ROW_NUMBER() OVER (ORDER BY id) AS row_num,
         COUNT(*) OVER () AS total_rows
  FROM cb
)
SELECT constellation_name, id
FROM ordered
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));

SELECT *
FROM cb; 

#Counting categories
SELECT category, COUNT(category) as cat_count
FROM cb
GROUP BY category
ORDER BY cat_count DESC;

# Volume V = (4/3)πr³ for each celestial object 
SELECT name, radius, 
		(4/3) * 3.1416 * POW(radius,3) AS volume_km3
FROM cb; 

#Average temperature_hi and temperature_lo: 554528.40109890K
WITH temp_cte AS (
	SELECT *, (temp_hi + temp_lo) / 2 AS avg_temp
	FROM cb
)
SELECT AVG(avg_temp) AS avg_temp_K
FROM temp_cte; 

SELECT *
FROM cb; 

#Densest object per category 
WITH dt AS (
	SELECT *, mass/((4/3)*3.1416*POW(radius * 1000,3)) as density_kg_m3
	FROM cb
), density_rank AS(
	SELECT name, type_name, category, density_kg_m3, DENSE_RANK()OVER(PARTITION BY category ORDER BY density_kg_m3 DESC) as ranking
	FROM dt
)
SELECT *
FROM density_rank
WHERE ranking = 1; 

