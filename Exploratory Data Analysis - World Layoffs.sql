-- Exploratory Data Analysis

-- Task:
-- 1. Total laid off for each year
-- 2 If there is a seasonality (by month)
-- 3 If there is a industry pattern
-- 4 If there is a country pattern

-- 1. Total laid off for each year
SELECT YEAR(`date`) AS `year`, SUM(total_laid_off) as year_laid_off
FROM layoffs_copy
GROUP BY `year`
ORDER BY `year_laid_off` DESC;

-- 2 If there is a seasonality (by month)
SELECT YEAR(`date`) AS `year`, MONTH(`date`) AS `month`, SUM(total_laid_off) as month_laid_off
FROM layoffs_copy
GROUP BY `year`, `month`
ORDER BY `year`, `month`;

-- 2.1 check monthly rolling total in each year
WITH month_rolling_total AS
(
	SELECT YEAR(`date`) AS `year`, MONTH(`date`) AS `month`, SUM(total_laid_off) as month_laid_off
	FROM layoffs_copy
	WHERE `date` IS NOT NULL
	GROUP BY `year`, `month`
	ORDER BY `year`, `month`
)
SELECT `year`, `month`, month_laid_off, SUM(month_laid_off) OVER(PARTITION BY `year` ORDER BY `month`) AS rolling_total
FROM month_rolling_total
;

-- 3 If there is a industry pattern
-- 3.1 Find the top 3 layoff idustries every year
WITH Year_Industry (Years, Industry, Year_Laid_Off) AS
(
SELECT YEAR(`date`) AS `year`, industry, SUM(total_laid_off)
FROM layoffs_copy
WHERE `date` IS NOT NULL
GROUP BY `year`, industry
ORDER BY `year`
),
Year_Industry_Rank (Years, Industry, Year_Laid_Off, Ranking) AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Year_Laid_Off DESC) AS Ranking
FROM Year_Industry
)
SELECT *
FROM Year_Industry_Rank
WHERE Ranking <= 3
;

-- 3.2 Find top 5 companies in each of the top industry
WITH Year_Industry (Years, Industry, Year_Laid_Off) AS
(
SELECT YEAR(`date`) AS `year`, industry, SUM(total_laid_off)
FROM layoffs_copy
WHERE `date` IS NOT NULL
GROUP BY `year`, industry
ORDER BY `year`
),
Year_Company_Industry (Years, Company, Industry, Company_Laid_Off, Year_Laid_Off) AS
(
SELECT YEAR(layoffs_copy.`date`) AS `year`, layoffs_copy.company, layoffs_copy.industry, layoffs_copy.total_laid_off, Year_Industry.Year_Laid_Off
FROM layoffs_copy
JOIN Year_Industry
	ON YEAR(layoffs_copy.`date`) = Years
    AND layoffs_copy.industry = Year_Industry.Industry
WHERE layoffs_copy.total_laid_off IS NOT NULL
ORDER BY `year`, Year_Industry.Year_Laid_Off DESC
),
Year_Company_Industry_Rank (Years, Company, Industry, Company_Laid_Off, Year_Laid_Off, Year_Raning, Company_Ranking) AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Year_Laid_Off DESC) AS Year_Ranking,
DENSE_RANK() OVER (PARTITION BY Years, Industry ORDER BY Company_Laid_Off DESC) AS Company_Ranking
FROM Year_Company_Industry
)
SELECT *
FROM Year_Company_Industry_Rank
WHERE Year_Raning <= 3 AND Company_Ranking <= 5
;

-- 4 If there is a country pattern
-- 4.1 Find the top 3 layoff countries every year
WITH
Year_Country (Years, Country, Country_Year_Off) AS
(
SELECT YEAR(`date`) AS `year`, country, SUM(total_laid_off) as country_year_off
FROM layoffs_copy
WHERE `date` IS NOT NULL
GROUP BY `year`, country
ORDER BY `year`
),
Year_Country_Rank (Years, Country, Country_Year_Off, Ranking) AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Country_Year_Off DESC) AS Ranking
FROM Year_Country
WHERE Country_Year_Off IS NOT NULL
)
SELECT *
FROM Year_Country_Rank
WHERE Ranking <= 3
;

-- 4.2 Find the top 5 layoff idustries in US every year
WITH Year_Industry_US (Years, Industry, Industry_Laid_Off, Country) AS
(
SELECT YEAR(`date`) AS `year`, industry, SUM(total_laid_off), country
FROM layoffs_copy
WHERE `date` IS NOT NULL 
	AND  industry IS NOT NULL
	AND country LIKE '%United States%'
GROUP BY `year`, industry, country
ORDER BY `year`
),
Year_Industry_US_Rank (Years, Industry, Industry_Laid_Off, Country, Ranking) AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Industry_Laid_Off DESC) AS Ranking
FROM Year_Industry_US
)
SELECT *
FROM Year_Industry_US_Rank
WHERE Ranking <= 5
;





