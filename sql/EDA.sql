-- Exploratory Data Analysis

-- we are just going to explore the data and find trends or patterns or anything interesting like outliers

SELECT *
FROM layoffs_stagging2;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_stagging2;
-- This dataset is from 2020-03-11 to 2025-07-24

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_stagging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_stagging2
WHERE  percentage_laid_off IS NOT NULL;


-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1;

-- Specific 
SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
AND country = 'India'
AND industry = 'AI';


SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_million_dollars DESC;
-- Britishvolt, Quibi, Deliveroo Australia, Fisker, Katerra, Lilium, Convoy, Lordstown Motors, BlockFi have raised over 1 billion dollars and went down


-- Company with the most layoff 
SELECT company, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC;

-- Layoff count by location
SELECT location, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY location
ORDER BY 2 DESC;

-- Layoff count by country
SELECT country, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY country
ORDER BY 2 DESC;

-- Layoff count by Industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY industry
ORDER BY 2 DESC;

-- Layoff count within year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Layoff count by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT * 
FROM layoffs_stagging2;


-- Rolling 

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY `Month`
ORDER BY 1;

WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total 
FROM Rolling_total;



-- Layoff in company by year

SELECT company, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY 1 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (Company, `Year`, Total_laid_off_year) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_laid_off_year DESC) AS Ranking
FROM Company_year
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;


