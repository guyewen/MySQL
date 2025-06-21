-- Data Cleaning - World Layoffs

SELECT *
FROM layoffs;

-- Tasks:
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle null and blank values
-- 4. Remove any columns

-- created a table that has same columns as the raw data
CREATE TABLE layoffs_copy
Like layoffs;

INSERT layoffs_copy
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_copy;

-- 1. Remove Duplicates

-- add rown number for each unique combination of company + industry + total_laid_off ...
-- if no duplicate, the row_num should not >= 2
SELECT *,
ROW_NUMBER() OVER(
partition by company, industry, total_laid_off, percentage_laid_off, `date`
) AS row_num
FROM layoffs_copy;

-- Use WITH to create a CTE (temp table) to further query on row_num
-- Pick out the info for the companies that are duplicated
DROP TABLE IF EXISTS table_duplicate;
CREATE TEMPORARY TABLE table_duplicate
WITH layoffs_copy_with_row_num AS
(
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_copy
)
SELECT *
FROM layoffs_copy_with_row_num
;

#SELECT *
#FROM table_duplicate;

-- 2361
#SELECT COUNT(*)
#FROM table_duplicate;

DELETE
FROM table_duplicate
WHERE row_num > 1;

-- 2356
#SELECT COUNT(*)
#FROM table_duplicate;

-- Should show nothing
#SELECT *
#FROM table_duplicate
#WHERE row_num > 1;

-- Remove row_num column
ALTER TABLE table_duplicate
DROP COLUMN row_num;

#SELECT *
#FROM table_duplicate;

-- update layoffs_copy
DROP TABLE IF EXISTS layoffs_copy;
CREATE TABLE layoffs_copy
Like table_duplicate;

INSERT layoffs_copy
SELECT *
FROM table_duplicate;


-- 2. Standardize data
-- take away the empty space before company name
UPDATE layoffs_copy
SET company = TRIM(company);

-- check if any similar industry name
SELECT DISTINCT industry
FROM layoffs_copy
ORDER BY 1;

-- find out Crypto, CryptoCurrency, Crypto Currency which are similar industry names
SELECT *
FROM layoffs_copy
WHERE industry LIKE 'Crypto%';

-- standardize it into Crypto
UPDATE layoffs_copy
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- do the same similarity check for other columns
-- find in country you have United States and United States.
-- clean it
UPDATE layoffs_copy
SET country = 'United States'
WHERE country LIKE 'United States%';

-- may also clean like this, if you know you only need to remove a '.'
-- TRIM(TRAILING '.' FROM country) will take away '.' from country column
UPDATE layoffs_copy
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- covert date format
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') as std_date
FROM layoffs_copy;

-- the data type of date is still text after below
UPDATE layoffs_copy
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- change data type from text to DATE
ALTER TABLE layoffs_copy
MODIFY COLUMN `date` DATE;

-- start to deal with the NULLs and blanks
-- first set all blanks to null
UPDATE layoffs_copy
SET industry = NULL
WHERE industry = '';

-- use join table to check if any company with industry = null, 
-- has industry specified in other rows, if yes, update
UPDATE layoffs_copy t1
JOIN layoffs_copy t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- remove invalid data, e.g. both total_laid_off and percentage_laid_off is NULL or empty
-- careful before delete data!
-- again, first make empty to null, easier to handle later
UPDATE layoffs_copy
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_copy
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

DELETE
FROM layoffs_copy
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


