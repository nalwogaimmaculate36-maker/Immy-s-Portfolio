# US Household Income Project (Data Cleaning)

SELECT *
FROM us_household_income
;

SELECT *
FROM us_household_income_statistics
;

# I used ALTER TABLE, RENAME COLUMN to change the is column name

ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

# I used COUNT() on the id column in both tables to see the number or rows that were imported

SELECT COUNT(id)
FROM us_household_income;

SELECT *
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

# I used COUNT(),ROW_NUMBER() OVER(PARTITION BY  ORDER BY) and subquery to identify duplicates within the id coulmn and DELETE to remove all the duplicates. The us_household_income_statistics table has no duplicates

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

SELECT *
FROM (
	SELECT row_id,
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
    FROM us_household_income) row_tab
WHERE row_num > 1;

DELETE FROM us_household_income
WHERE row_id IN (
		SELECT row_id
		FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
		FROM us_household_income) row_tab
		WHERE row_num > 1);
				
SELECT *
FROM us_household_income;


SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1 ;

SELECT *
FROM us_household_income;

# I used DISTINCT to identify the inconsistent spellings in the Sate Name column and used UPDATE to standardize them

SELECT DISTINCT State_Name
FROM us_household_income;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

SELECT DISTINCT State_ab
FROM us_household_income;

# I used UPDATE to populate the blank row in the Place column. I populated it with Autaugaville because it was most common value in the column. 

SELECT *
FROM us_household_income
WHERE Place = ''
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

UPDATE us_household_income
SET State_Name = UPPER(State_Name);

UPDATE us_household_income
SET County = UPPER(County);

UPDATE us_household_income
SET State_ab = UPPER(State_ab);

UPDATE us_household_income
SET City = UPPER(City);

UPDATE us_household_income
SET Place = UPPER(Place);

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

UPDATE us_household_income
SET Type = 'CDP'
WHERE Type = 'CPD';


SELECT DISTINCT Type
FROM us_household_income
;

SELECT * 
FROM us_household_income
;



# These queries find out either there is ALand or AWater or it has 0, or is blank or is null land and more water vice versa. Showing places with either just land or water. 

SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL
;
SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

SELECT ALand, AWater
FROM us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
AND (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

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
# Automated Data 


SELECT * 
FROM us_household_income_statistics_backup
;

# Automated Data Cleaning Project

SELECT * 
FROM us_household_income_cleaned_automately
;


DELIMITER $$
DROP PROCEDURE IF EXISTS `Copy_and_Clean_Data`;
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN 
-- Creating table

		CREATE TABLE IF NOT EXISTS `us_household_income_clean` (
		  `row_id` int DEFAULT NULL,
		  `id` int DEFAULT NULL,
		  `State_Code` int DEFAULT NULL,
		  `State_Name` text,
		  `State_ab` text,
		  `County` text,
		  `City` text,
		  `Place` text,
		  `Type` text,
		  `Primary` text,
		  `Zip_Code` int DEFAULT NULL,
		  `Area_Code` int DEFAULT NULL,
		  `ALand` int DEFAULT NULL,
		  `AWater` int DEFAULT NULL,
		  `Lat` double DEFAULT NULL,
		  `Lon` double DEFAULT NULL,
		  `TimeStamp` TIMESTAMP DEFAULT NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
-- Copying Data to new table 
		INSERT INTO us_household_income_clean
		SELECT * , CURRENT_TIMESTAMP()
		FROM us_household_income_backup;
        
-- Data Cleaning Steps
-- Removing Duplicates

DELETE FROM us_household_income_clean
WHERE row_id IN (
		SELECT row_id
		FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id, `TimeStamp` ORDER BY id, `TimeStamp`) as row_num
		FROM us_household_income_clean) row_tab
		WHERE row_num > 1);
        
-- Fixing some data quality issues by fixing typos and general standardization

		UPDATE us_household_income_clean
		SET State_Name = 'Georgia'
		WHERE State_Name = 'Georia';

		UPDATE us_household_income_clean
		SET Type = 'CDP'
		WHERE Type = 'CPD';

		UPDATE us_household_income_clean
		SET Type = 'Borough'
		WHERE Type = 'Boroughs';

		UPDATE us_household_income_clean
		SET County = UPPER(County);

		UPDATE us_household_income_clean
		SET City = UPPER(City);

		UPDATE us_household_income_clean
		SET Place = UPPER(Place);

		UPDATE us_household_income_clean
		SET State_Name = UPPER(State_Name);

END $$
DELIMITER ;


CALL Copy_and_Clean_Data();

SELECT * 
FROM us_household_income_clean
;
# Create Event

CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_Data;
    

 CALL EVENTS;
 
DROP EVENT run_data_cleaning;

SELECT DISTINCT TimeStamp
FROM us_household_income_clean;











# DEBUGGING AND CHECKING SP WORKS

SELECT row_id , id, row_num
FROM (
	SELECT row_id, id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income_clean
    #us_household_income_backup
    ) AS row_tab
WHERE row_num > 1;

SELECT COUNT(row_id)
FROM us_household_income_clean 
#us_household_income_backup
;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_clean
#us_household_income_backup
GROUP BY State_Name;










