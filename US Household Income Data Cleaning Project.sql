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