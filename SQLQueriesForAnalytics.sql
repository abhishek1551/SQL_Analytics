USE [AdventureWorks2016]
-- Retrieve Top 5 Best-Selling Products
-- Demonstrates: Joins, Aggregation, Sorting.
select* from Sales.SalesOrderDetail
select* from [Production].[Product]

select top 5
	P.Name as ProductName,
	sum(SOD.OrderQty) As TotalQtySold
From Sales.SalesOrderDetail SOD
Join Production.Product P
	on SOD.ProductID = P.ProductID
Group by P.Name
Order by TotalQtySold desc;

-- Calculate Total Sales by Territory
-- Demonstrates: Grouping by Territory.
select* from Sales.SalesOrderHeader
select* from Sales.SalesTerritory

select 
	T.Name as TerritroyName,
	sum(SOH.SubTotal) as TotalSales
from Sales.SalesOrderHeader SOH
Join Sales.SalesTerritory T
	on SOH.TerritoryID = T.TerritoryID
Group by T.Name
Order by TotalSales desc;

-- Identify Customers with Multiple Orders
-- Demonstrates: Grouping with HAVING for filtering aggregates.
Select * from Sales.Customer
Select	
	C.CustomerID,
	count(SOH.SalesOrderID) as OrderCount
from Sales.Customer C
join Sales.SalesOrderHeader SOH
	on C.CustomerID = SOH.CustomerID
Group by C.CustomerID
Having count(SOH.SalesOrderID)>1
order by OrderCOunt desc;

-- Using Common Table Expression to Calculate Average Sales by Territory
-- Demonstrates: Use of CTE and Window Functions.
WITH TerritorySales AS (
    SELECT 
        T.Name AS TerritoryName,
        SUM(SOH.SubTotal) AS TotalSales
    FROM Sales.SalesOrderHeader SOH
    JOIN Sales.SalesTerritory T
        ON SOH.TerritoryID = T.TerritoryID
    GROUP BY T.Name
)
select 
	TerritoryName,
	TotalSales,
	AVG(TotalSales) over() as AverageSales
from TerritorySales;

-- Calculate Yearly Revenue Trend
SELECT 
    YEAR(SOH.OrderDate) AS OrderYear,
    SUM(SOH.SubTotal) AS TotalRevenue
FROM Sales.SalesOrderHeader SOH
Group by year(SOH.OrderDate)
order by TotalRevenue desc;

-- Find Employees with Salaries Aboove the Average
-- Demonstrates: Subqueries for filtering with averages.

select* from HumanResources.EmployeePayHistory
select * from Person.Person
select
	P.FirstName + '' + P.LastName as EmployeeName,
	E.Rate as salary
from HumanResources.EmployeePayHistory E
join Person.Person P
	on E.BusinessEntityID = P.BusinessEntityID
Where E.Rate > (
	select avg(Rate)
	From HumanResources.EmployeePayHistory
);

-- List Orders with Their Most Expensive Product
-- Get data from three different tables using join
select* from Sales.SalesOrderHeader SOH
select* from Sales.SalesOrderDetail SOD
select* from Production.Product

SELECT 
    P.Name AS ProductName,
    MAX(SOD.UnitPrice) AS MaxPrice
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD
    ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product P
    ON SOD.ProductID = P.ProductID
GROUP BY SOH.SalesOrderID, P.Name
ORDER BY MaxPrice DESC;

-- Identify Sales Growth Between Years
select* from Sales.SalesOrderHeader
WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS SalesYear,
        SUM(SubTotal) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
)
select 
    CurrentYear.SalesYear AS CurrentYear,
    PreviousYear.SalesYear AS PreviousYear,
    CurrentYear.TotalSales AS CurrentSales,
    PreviousYear.TotalSales AS PreviousSales,
    (CurrentYear.TotalSales - PreviousYear.TotalSales) AS SalesGrowth
FROM YearlySales CurrentYear
LEFT JOIN YearlySales PreviousYear
    ON CurrentYear.SalesYear = PreviousYear.SalesYear + 1;

-- Find Products not sold
selecr 
    P.ProductID,
    P.Name AS ProductName
FROM Production.Product P
LEFT JOIN Sales.SalesOrderDetail SOD
    ON P.ProductID = SOD.ProductID
WHERE SOD.ProductID IS NULL;

-- Rank Customers by Total Purchase
-- Demonstrates window function
select
    C.CustomerID,
    SUM(SOH.SubTotal) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(SOH.SubTotal) DESC) AS RankBySpending
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader SOH
    ON C.CustomerID = SOH.CustomerID
GROUP BY C.CustomerID
ORDER BY TotalSpent DESC;

-- Use Case statement for conditional logic
select* from Person.Person
select
    FirstName,
    LastName,
    CASE 
        WHEN BusinessEntityID BETWEEN 1 and 5000 THEN 'Old'
        WHEN BusinessEntityID BETWEEN 5000 AND 12000 THEN 'New'
        ELSE 'Super New'
    END AS CustomerJoined
FROM Person.Person
WHERE BusinessEntityID IS NOT NULL;

-- View for Summarizing Product Sales
CREATE VIEW ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    SUM(sd.OrderQty) AS TotalQuantitySold,
    SUM(sd.LineTotal) AS TotalSales
FROM Production.Product p
JOIN Sales.SalesOrderDetail sd
    ON p.ProductID = sd.ProductID
GROUP BY p.ProductID, p.Name;

-- Query the view
SELECT * 
FROM ProductSalesSummary
WHERE TotalSales > 10000;

-- Create a temporary table
CREATE TABLE #TempProductList (
    ProductID INT,
    ProductName NVARCHAR(100),
    ListPrice DECIMAL(10, 2)
);

-- Insert data into the temporary table
INSERT INTO #TempProductList (ProductID, ProductName, ListPrice)
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > 500;

-- Query the temporary table
SELECT * FROM #TempProductList;

-- Drop the temporary table (optional, as it's automatically dropped at session end)
DROP TABLE #TempProductList;



-- Trigger for Preventing Negative Inventory
-- Doesn't allow negative inventory quantity
CREATE TRIGGER trg_PreventNegativeInventory
ON Production.ProductInventory
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.Quantity < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50000, 'Inventory cannot be negative.', 1;
    END
END;

-- Update to test the trigger
UPDATE Production.ProductInventory
SET Quantity = -10
WHERE ProductID = 707; -- This will throw an error

-- Stored Procedures
-- using joins to fetch data from 3 different tables
select* from Production.Product
select* from Production.ProductCategory
select* from Production.ProductSubcategory

Create Procedure UpdateProductPrices
	@CategoryName nvarchar(50),
	@PercentageIncrease decimal(5,2)
as
begin
	set nocount on;--to supress messages that indicate number of rows affected(Can minimize network traffic)
	update p
	set ListPrice = ListPrice * (1+ @PercentageIncrease/100)
	from Production.Product p
	inner join Production.ProductSubcategory ps
		on p.ProductSubcategoryID = ps.ProductSubcategoryID
	inner join Production.ProductCategory pc
		on ps.ProductSubcategoryID = pc.ProductCategoryID
	where pc.Name = @CategoryName;
end;

-- Execute the Procedure
EXEC UpdateProductPrices @CategoryName = 'Bikes', @PercentageIncrease = 5.0;



