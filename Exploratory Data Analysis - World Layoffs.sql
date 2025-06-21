-- Exploratory Data Analysis

-- Task:
-- 1. Total laid off for each year
-- 2 If there is a seasonality (by month)
-- 3 If there is a industry pattern
-- 4 If there is a location pattern
-- 5 If there is a stage pattern

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