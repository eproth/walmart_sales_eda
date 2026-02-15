-- INSPECT THE DATASET
SELECT * 
FROM walmart_sales;

-- Backup table in case off making mistakes
CREATE TABLE sales_staging AS
SELECT *
FROM walmart_sales;

SELECT * FROM sales_staging;

-- DATA CLEANING

-- null values
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Store_nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_nulls,
	SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS Weekly_Sales_nulls,
    SUM(CASE WHEN Holiday_Flag IS NULL THEN 1 ELSE 0 END) AS Holiday_Flag_nulls,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS Temperature_nulls,
    SUM(CASE WHEN Fuel_Price IS NULL THEN 1 ELSE 0 END) AS Fuel_Price_nulls,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS CPI_nulls,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Unemployment_nulls
FROM sales_staging;
-- no missing values

-- duplicates
SELECT *, COUNT(*) as count_duplicates
FROM sales_staging
GROUP BY Store, Date, Weekly_Sales, Holiday_Flag, Temperature, Fuel_Price, CPI, Unemployment
HAVING COUNT(*) > 1;
-- no duplicate in the dataset

-- EXPLORATORY DATA ANALYSIS

-- date range
SELECT MIN(`date`), MAX(`date`)
FROM sales_staging;

-- basic statistics
SELECT 
    MIN(Weekly_Sales) AS min_sales,
    MAX(Weekly_Sales) AS max_sales,
    AVG(Weekly_Sales) AS avg_sales,
    MIN(Temperature) AS min_temp,
    MAX(Temperature) AS max_temp,
    AVG(Temperature) AS avg_temp
FROM sales_staging;

-- sales trends over time
SELECT Date, SUM(Weekly_Sales) AS total_sales
FROM sales_staging
GROUP BY Date
ORDER BY Date;

-- sales trends over time by year
SELECT substr(Date, 7, 4) AS year,
       SUM(Weekly_Sales) AS total_sales,
       AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY year
ORDER BY year;

-- weekly sales by store
SELECT Store,
	AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Store
ORDER BY avg_sales DESC;
-- Store 20, 4, and 14 are the top 3 with highest average sales



-- sales during holidays vs. non-holidays
SELECT Holiday_Flag, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Holiday_Flag;

-- store benefits the most during holidays
SELECT Store, Holiday_Flag, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Store, Holiday_Flag
ORDER BY Store, Holiday_Flag;


-- tempurature and fuel price impact
SELECT Temperature, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Temperature
ORDER BY Temperature;

SELECT Fuel_Price, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Fuel_Price
ORDER BY Fuel_Price;

-- cpi and unemployment impact
SELECT CPI, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY CPI
ORDER BY CPI;

SELECT Unemployment, AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY Unemployment
ORDER BY Unemployment;


-- Monthly patterns
SELECT substr(Date, 4, 2) AS month,
       SUM(Weekly_Sales) AS total_sales,
       AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY month
ORDER BY month;

-- Seasonal sales
SELECT 
    CASE 
        WHEN substr(Date, 4, 2) IN (12, 1, 2) THEN 'Winter'
        WHEN substr(Date, 4, 2) IN (3, 4, 5) THEN 'Spring'
        WHEN substr(Date, 4, 2) IN (6, 7, 8) THEN 'Summer'
        WHEN substr(Date, 4, 2) IN (9, 10, 11) THEN 'Fall'
    END AS season,
    SUM(Weekly_Sales) AS total_sales,
    AVG(Weekly_Sales) AS avg_sales
FROM sales_staging
GROUP BY season
ORDER BY total_sales DESC;

-- Top 5 weeks with highest sales
SELECT Date, Store, Weekly_Sales
FROM sales_staging
ORDER BY Weekly_Sales DESC
LIMIT 5;

-- Highest average sales per economic condition
SELECT Store, AVG(Weekly_Sales) AS avg_sales, AVG(CPI) AS avg_cpi, AVG(Unemployment) AS avg_unemployment
FROM sales_staging
GROUP BY Store
ORDER BY avg_sales DESC;