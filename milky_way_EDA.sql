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

# 3 celestial bodies with largest mass 




