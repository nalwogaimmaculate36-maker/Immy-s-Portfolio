
# US Household Income Exploratory Data Analysis

SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

# I used SUM() on the ALand and AWater columns to find the State_Name with largest and smallest land, and largest and smallest waterbodies by using ORDER BY DESC and ASC and limited the output to the top 10 respectively

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
;
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC 
LIMIT 10;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 ASC
LIMIT 10;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10  
;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 ASC
LIMIT 10  
;


SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

# I used  Right Join to identify any 0 rows because during importing the two tables not all rows came in.
 
SELECT * 
FROM us_household_income u 
RIGHT JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean = 0
;

SELECT Type, COUNT(Type), ROUND(AVG(Mean),2) AS avg_mean, ROUND(AVG(Median),2) AS avg_median
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY Type
ORDER BY 3 DESC
;


SELECT * 
FROM us_household_income u 
RIGHT JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
;

SELECT u.State_Name, ROUND(AVG(Mean),2) AS avg_mean, ROUND(AVG(Median),2) AS avg_median
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

SELECT u.State_Name, ROUND(AVG(Mean),2) AS avg_mean,ROUND(AVG(Median),2) AS avg_median
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5;

SELECT u.State_Name, ROUND(AVG(Mean),2) AS avg_mean,ROUND(AVG(Median),2) AS avg_median
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.State_Name
ORDER BY 2 ASC
LIMIT 5;


SELECT * 
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
;

# This shows the city with highest average mean and median income

SELECT u.State_Name, City, ROUND(AVG(Mean),1) AS avg_mean, ROUND(AVG(Median),1) AS avg_median 
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.State_Name, City
ORDER BY 3 DESC
LIMIT 20 
;