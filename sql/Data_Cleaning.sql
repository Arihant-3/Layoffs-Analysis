-- Data Cleaning

SELECT *
FROM layoffs
;

-- STEPS/TO-DOS :-
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handling Null and Blank Values
-- 4. Remove any Columns or Rows

CREATE TABLE layoffs_stagging
LIKE layoffs; 

SELECT *
FROM layoffs_stagging
;

INSERT layoffs_stagging
SELECT *
FROM layoffs;

-- 1. Removing Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_stagging;


WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, country, funds_raised) AS row_num
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


SELECT *
FROM layoffs_stagging
WHERE company = 'Cazoo';
;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, country, funds_raised) AS row_num
FROM layoffs_stagging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;
-- We can't update the CTE 
-- So we have to create another table which include row_num


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_stagging2
WHERE row_num > 1;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, country, funds_raised) AS row_num
FROM layoffs_stagging;

DELETE 
FROM layoffs_stagging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_stagging2;


-- 2. Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);


SELECT DISTINCT industry
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT location, country
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;

-- Location fault (double) : Bengaluru, Gurugram, Kuala Lumpur, Melbourne, Montreal, Mumbai, Singapore
-- Country fault (both present) - UAE and United Arab Emirates

SELECT * 
FROM layoffs_stagging2
WHERE location LIKE 'Singapore%';

UPDATE layoffs_stagging2
SET location = 'Singapore,Non-U.S.'
WHERE location = 'Singapore';


SELECT * 
FROM layoffs_stagging2
WHERE country LIKE 'United Arab Emirates'
OR country LIKE 'UAE';

UPDATE layoffs_stagging2
SET country = 'United Arab Emirates'
WHERE country = 'UAE';

-- Changing percentage_laid_off from 6% to 0.06...
UPDATE layoffs_stagging2
SET percentage_laid_off = NULL
WHERE TRIM(percentage_laid_off) = '';

UPDATE layoffs_stagging2
SET percentage_laid_off = CAST(REPLACE(percentage_laid_off, '%', '') AS DECIMAL(5,2)) / 100;

UPDATE layoffs_stagging2
SET percentage_laid_off = ROUND(percentage_laid_off, 2);

-- Change fund_raised from $56 to 56 and name from fund_raised to fund_raised_millions_dollars
select funds_raised 
from layoffs_stagging2;

UPDATE layoffs_stagging2
SET funds_raised = NULL 
WHERE TRIM(funds_raised) = '';

UPDATE layoffs_stagging2
SET funds_raised = REPLACE(funds_raised, '$', '');

ALTER TABLE layoffs_stagging2
RENAME COLUMN funds_raised TO funds_raised_million_dollars;

SELECT funds_raised_million_dollars
FROM layoffs_stagging2;

-- Formatting Data

SELECT `date`, date_added
FROM layoffs_stagging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
UPDATE layoffs_stagging2
SET date_added = STR_TO_DATE(date_added, '%m/%d/%Y');

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;
ALTER TABLE layoffs_stagging2
MODIFY COLUMN date_added DATE;


-- table has a value like '' (empty string) in that column. MySQL cannot convert '' into an integer — hence the error.
-- So we have to trim that part
UPDATE layoffs_stagging2
SET total_laid_off = NULL
WHERE TRIM(total_laid_off) = '';
ALTER TABLE layoffs_stagging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN funds_raised_million_dollars INT;


-- 3. Handling Null and Blank Values

SELECT *
FROM layoffs_stagging2;


SELECT *
FROM layoffs_stagging2
WHERE industry = '';

SELECT *
FROM layoffs_stagging2
WHERE company LIKE '%Appsmith%';


SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = ''
AND total_laid_off = '';

DELETE 
FROM layoffs_stagging2
WHERE percentage_laid_off = ''
AND total_laid_off = '';


-- 4. Remove any Columns or Rows 

SELECT *
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;
