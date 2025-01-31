---Retrieved all sales transaction
SELECT *
FROM dbo.Superstore

---Drop unnecessary columns and modifications
ALTER TABLE Superstore
DROP COLUMN Postal_code 

ALTER TABLE Superstore
DROP COLUMN Order_ID, Ship_Date, Ship_Mode, Product_ID, Product_Name;

ALTER TABLE Superstore
ALTER COLUMN Sales DECIMAL(10,2) 

---Confirm the absence of duplicate in primary key
SELECT Row_ID, COUNT(*) AS Duplicate_values
FROM dbo.Superstore
GROUP BY Row_ID
HAVING COUNT(*) > 1;

---Retrieve all product categories and Sub-category
SELECT DISTINCT Category
FROM dbo.Superstore

SELECT DISTINCT Sub_Category
FROM dbo.Superstore

---All years included in the dataset
SELECT YEAR(Order_Date) AS Sales_Years
FROM dbo.Superstore
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Years

---Calculate Total Revenue
SELECT SUM(Sales) AS Total_Revenue
FROM dbo.Superstore

---Calculate Total Order Value Per Year
SELECT YEAR(Order_Date) AS Sales_Years, SUM(Sales) AS Yearly_TOV
FROM dbo.Superstore
GROUP BY YEAR(Order_Date)
ORDER BY Yearly_TOV DESC

---Calcuate Total Revenue Per Category
SELECT Category, SUM(Sales) AS Category_Total_Revenue
FROM dbo.Superstore
GROUP BY Category
ORDER BY Category_Total_Revenue DESC

---Calculate Total Revenue Per Sub-Categories
SELECT Sub_Category, SUM(Sales) AS Sub_Category_Total_Revenue
FROM dbo.Superstore
GROUP BY Sub_Category
ORDER BY Sub_Category_Total_Revenue DESC

---Total Revenue Per State
SELECT State, SUM(Sales) Total_State_Revenue
FROM dbo.Superstore
GROUP BY State
ORDER BY Total_State_Revenue DESC

---Top 5 States with the highest number of customer
SELECT TOP 5 State, COUNT(DISTINCT Customer_ID) AS Customer_Count
FROM dbo.Superstore
GROUP BY State
ORDER BY Customer_Count DESC

---Customers that spent more than $10000 Per year
SELECT Customer_Name, SUM(Sales) AS Customer_Total_Purchase
FROM dbo.Superstore
GROUP BY Customer_Name
HAVING SUM(Sales) > 10000
ORDER BY Customer_Total_Purchase DESC


---Idenify New Customers Added each year using CTE and Stored Procedure
CREATE OR ALTER PROCEDURE YearlyNewCustomers

@YEAR INT

AS

WITH FirstPurchase AS (
SELECT Customer_Name, MIN(Order_Date) AS FirstPurchase_Date
FROM dbo.Superstore
GROUP BY Customer_Name
)

SELECT Customer_Name, FirstPurchase_Date
FROM FirstPurchase
WHERE YEAR(FirstPurchase_Date) = @YEAR
ORDER BY FirstPurchase_Date

EXEC YearlyNewCustomers @YEAR = 2016

---A Stored Procedure that fetches Monthly Revenue Trend

CREATE OR ALTER PROCEDURE GetMonthlyRevenue

@YEAR INT
  AS
	SELECT DATENAME(MONTH,Order_Date) AS Month, SUM(Sales) AS Monthly_Revenue
FROM dbo.Superstore
WHERE YEAR(Order_Date) = @YEAR
GROUP BY DATENAME(MONTH,Order_Date)
ORDER BY Monthly_Revenue DESC

EXEC GetMonthlyRevenue @YEAR = 2018