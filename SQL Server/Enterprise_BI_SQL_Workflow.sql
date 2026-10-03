--Understand the Business Data Structure(explore data)

USE AdventureWorks2022;
GO

SELECT TOP 10 *
FROM Sales.SalesOrderHeader;

SELECT TOP 10 *
FROM Sales.SalesOrderDetail;

SELECT TOP 10 *
FROM Sales.Customer;

SELECT TOP 10 *
FROM Person.Person;

SELECT TOP 10 *
FROM Production.Product;

SELECT TOP 10 *
FROM Production.ProductCategory;

SELECT TOP 10 *
FROM Production.ProductSubcategory;

SELECT TOP 10 *
FROM Sales.SalesTerritory;

USE AdventureWorks2022;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

USE AdventureWorks2022;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Sales%'
   OR TABLE_NAME LIKE '%Customer%'
   OR TABLE_NAME LIKE '%Product%'
   OR TABLE_NAME LIKE '%Address%'
   OR TABLE_NAME LIKE '%Territory%'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

--check null

USE AdventureWorks2022;
GO

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID_NULL,
    SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS TerritoryID_NULL,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS OrderDate_NULL,
    SUM(CASE WHEN TotalDue IS NULL THEN 1 ELSE 0 END) AS TotalDue_NULL
FROM Sales.SalesOrderHeader;

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID_NULL,
    SUM(CASE WHEN OrderQty IS NULL THEN 1 ELSE 0 END) AS OrderQty_NULL,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS UnitPrice_NULL,
    SUM(CASE WHEN LineTotal IS NULL THEN 1 ELSE 0 END) AS LineTotal_NULL
FROM Sales.SalesOrderDetail;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS ProductName_NULL,
    SUM(CASE WHEN ProductNumber IS NULL THEN 1 ELSE 0 END) AS ProductNumber_NULL,
    SUM(CASE WHEN Color IS NULL THEN 1 ELSE 0 END) AS Color_NULL
FROM Production.Product;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN PersonID IS NULL THEN 1 ELSE 0 END) AS PersonID_NULL,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS StoreID_NULL
FROM Sales.Customer;


--Data Quality Check

SELECT 
    CustomerID,
    COUNT(*) AS Count_Record
FROM Sales.Customer
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT 
    SalesOrderID,
    COUNT(*) AS Count_Record
FROM Sales.SalesOrderHeader
GROUP BY SalesOrderID
HAVING COUNT(*) > 1;

--Data Relationship Validation
USE AdventureWorks2022;
GO

SELECT COUNT(*) AS Missing_Customers
FROM Sales.SalesOrderHeader s
LEFT JOIN Sales.Customer c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS Missing_Products
FROM Sales.SalesOrderDetail d
LEFT JOIN Production.Product p
ON d.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

SELECT COUNT(*) AS Missing_Order_Details
FROM Sales.SalesOrderHeader h
LEFT JOIN Sales.SalesOrderDetail d
ON h.SalesOrderID = d.SalesOrderID
WHERE d.SalesOrderID IS NULL;

--Check Data Volume

USE AdventureWorks2022;
GO

SELECT 
    'SalesOrderHeader' AS Table_Name,
    COUNT(*) AS Total_Rows
FROM Sales.SalesOrderHeader

UNION ALL

SELECT 
    'SalesOrderDetail',
    COUNT(*)
FROM Sales.SalesOrderDetail

UNION ALL

SELECT 
    'Customer',
    COUNT(*)
FROM Sales.Customer

UNION ALL

SELECT 
    'Product',
    COUNT(*)
FROM Production.Product;

--Understand Sales Period

SELECT
    MIN(OrderDate) AS First_Order_Date,
    MAX(OrderDate) AS Last_Order_Date
FROM Sales.SalesOrderHeader;

--Check Key Business Metrics

SELECT
    COUNT(DISTINCT CustomerID) AS Total_Customers,
    COUNT(DISTINCT SalesOrderID) AS Total_Orders,
    SUM(TotalDue) AS Total_Revenue
FROM Sales.SalesOrderHeader;

--Create the Data Warehouse Model

CREATE DATABASE BI_Enterprise_Analytics;
GO

USE BI_Enterprise_Analytics;
GO

CREATE TABLE DimCustomer
(
    Customer_Key INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT,
    Customer_Name NVARCHAR(200),
    Customer_Type VARCHAR(50),
    Gender VARCHAR(20),
    Country NVARCHAR(100),
    Region NVARCHAR(100)
);
GO

CREATE TABLE DimProduct
(
    Product_Key INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID INT,
    Product_Name NVARCHAR(200),
    Category NVARCHAR(100),
    Subcategory NVARCHAR(100),
    Color NVARCHAR(50),
    Cost MONEY,
    Price MONEY
);
GO

CREATE TABLE DimDate
(
    Date_Key INT PRIMARY KEY,
    Full_Date DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Month_Name VARCHAR(20)
);
GO

CREATE TABLE DimTerritory
(
    Territory_Key INT IDENTITY(1,1) PRIMARY KEY,
    Territory_ID INT,
    Territory_Name NVARCHAR(100),
    Country NVARCHAR(100),
    Region NVARCHAR(100)
);
GO

CREATE TABLE FactSales
(
    Sales_Key INT IDENTITY(1,1) PRIMARY KEY,

    Customer_Key INT,
    Product_Key INT,
    Territory_Key INT,
    Date_Key INT,

    Order_Quantity INT,
    Sales_Amount MONEY,
    Discount MONEY,
    Profit MONEY,

    FOREIGN KEY (Customer_Key)
    REFERENCES DimCustomer(Customer_Key),

    FOREIGN KEY (Product_Key)
    REFERENCES DimProduct(Product_Key),

    FOREIGN KEY (Territory_Key)
    REFERENCES DimTerritory(Territory_Key),

    FOREIGN KEY (Date_Key)
    REFERENCES DimDate(Date_Key)
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

--ETL Process

USE BI_Enterprise_Analytics;
GO


INSERT INTO DimCustomer
(
    Customer_ID,
    Customer_Name,
    Customer_Type
)
SELECT
    c.CustomerID,

    ISNULL(
        p.FirstName + ' ' + p.LastName,
        s.Name
    ) AS Customer_Name,

    CASE
        WHEN c.PersonID IS NOT NULL 
        THEN 'Individual'
        WHEN c.StoreID IS NOT NULL
        THEN 'Store'
        ELSE 'Unknown'
    END AS Customer_Type

FROM AdventureWorks2022.Sales.Customer c

LEFT JOIN AdventureWorks2022.Person.Person p
ON c.PersonID = p.BusinessEntityID

LEFT JOIN AdventureWorks2022.Sales.Store s
ON c.StoreID = s.BusinessEntityID;
GO

SELECT TOP 10 *
FROM DimCustomer;

--Load DimProduct

INSERT INTO DimProduct
(
    Product_ID,
    Product_Name,
    Category,
    Subcategory,
    Color,
    Cost,
    Price
)

SELECT

p.ProductID,

p.Name,

pc.Name AS Category,

psc.Name AS Subcategory,

ISNULL(p.Color,'Unknown') AS Color,

p.StandardCost,

p.ListPrice


FROM AdventureWorks2022.Production.Product p

LEFT JOIN AdventureWorks2022.Production.ProductSubcategory psc
ON p.ProductSubcategoryID = psc.ProductSubcategoryID

LEFT JOIN AdventureWorks2022.Production.ProductCategory pc
ON psc.ProductCategoryID = pc.ProductCategoryID;

GO

SELECT TOP 10 *
FROM DimProduct;

--Load DimTerritory

INSERT INTO DimTerritory
(
    Territory_ID,
    Territory_Name,
    Country,
    Region
)

SELECT

TerritoryID,

Name,

CountryRegionCode,

[Group]

FROM AdventureWorks2022.Sales.SalesTerritory;

GO

SELECT * FROM DimTerritory;

--Load DimDate

USE BI_Enterprise_Analytics;
GO

DECLARE @StartDate DATE = '2011-01-01';
DECLARE @EndDate DATE = '2014-12-31';


WHILE @StartDate <= @EndDate
BEGIN

INSERT INTO DimDate
(
    Date_Key,
    Full_Date,
    Year,
    Quarter,
    Month,
    Month_Name
)

VALUES
(
    CONVERT(INT, FORMAT(@StartDate,'yyyyMMdd')),
    @StartDate,
    YEAR(@StartDate),
    DATEPART(QUARTER,@StartDate),
    MONTH(@StartDate),
    DATENAME(MONTH,@StartDate)
);


SET @StartDate = DATEADD(DAY,1,@StartDate);

END;

GO

SELECT TOP 10 *
FROM DimDate;

--Load FactSales

USE BI_Enterprise_Analytics;
GO


INSERT INTO FactSales
(
    Customer_Key,
    Product_Key,
    Territory_Key,
    Date_Key,
    Order_Quantity,
    Sales_Amount,
    Discount,
    Profit
)


SELECT

dc.Customer_Key,

dp.Product_Key,

dt.Territory_Key,

dd.Date_Key,


sod.OrderQty,

sod.LineTotal,

sod.UnitPriceDiscount,

(sod.LineTotal - 
(sod.OrderQty * p.StandardCost)
) AS Profit


FROM AdventureWorks2022.Sales.SalesOrderDetail sod


INNER JOIN AdventureWorks2022.Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID


LEFT JOIN DimCustomer dc
ON soh.CustomerID = dc.Customer_ID


LEFT JOIN DimProduct dp
ON sod.ProductID = dp.Product_ID


LEFT JOIN DimTerritory dt
ON soh.TerritoryID = dt.Territory_ID


LEFT JOIN DimDate dd
ON CONVERT(DATE,soh.OrderDate)=dd.Full_Date


LEFT JOIN AdventureWorks2022.Production.Product p
ON sod.ProductID=p.ProductID;


GO


SELECT TOP 10 *
FROM FactSales;

--Check Warehouse Summary

SELECT 
'DimCustomer' AS Table_Name,
COUNT(*) AS Rows
FROM DimCustomer

UNION ALL

SELECT 
'DimProduct',
COUNT(*)
FROM DimProduct

UNION ALL

SELECT 
'DimDate',
COUNT(*)
FROM DimDate

UNION ALL

SELECT 
'FactSales',
COUNT(*)
FROM FactSales;

--Revenue Performance View

USE BI_Enterprise_Analytics;
GO

CREATE VIEW vw_Revenue_Performance
AS

SELECT

d.Year,
d.Month,
d.Month_Name,

SUM(f.Sales_Amount) AS Total_Revenue,

SUM(f.Profit) AS Total_Profit,

SUM(f.Order_Quantity) AS Total_Quantity

FROM FactSales f

JOIN DimDate d
ON f.Date_Key = d.Date_Key

GROUP BY
d.Year,
d.Month,
d.Month_Name;

GO

SELECT *
FROM vw_Revenue_Performance
ORDER BY Year, Month;

--Customer Intelligence View

CREATE VIEW vw_Customer_Intelligence
AS

SELECT

c.Customer_ID,

c.Customer_Name,

c.Customer_Type,

COUNT(f.Sales_Key) AS Total_Orders,

SUM(f.Sales_Amount) AS Total_Spending,

SUM(f.Profit) AS Total_Profit

FROM FactSales f

JOIN DimCustomer c
ON f.Customer_Key=c.Customer_Key

GROUP BY

c.Customer_ID,
c.Customer_Name,
c.Customer_Type;

GO

SELECT TOP 10 *
FROM vw_Customer_Intelligence
ORDER BY Total_Spending DESC;

--Product Performance View

CREATE VIEW vw_Product_Performance
AS

SELECT

p.Category,

p.Subcategory,

p.Product_Name,

SUM(f.Order_Quantity) AS Units_Sold,

SUM(f.Sales_Amount) AS Revenue,

SUM(f.Profit) AS Profit

FROM FactSales f

JOIN DimProduct p
ON f.Product_Key=p.Product_Key


GROUP BY

p.Category,
p.Subcategory,
p.Product_Name;

GO

--Regional Sales View

CREATE VIEW vw_Regional_Performance
AS

SELECT

t.Region,

t.Country,

SUM(f.Sales_Amount) AS Revenue,

SUM(f.Profit) AS Profit,

COUNT(f.Sales_Key) AS Orders

FROM FactSales f

JOIN DimTerritory t
ON f.Territory_Key=t.Territory_Key

GROUP BY

t.Region,
t.Country;

GO

USE BI_Enterprise_Analytics;
GO

ALTER TABLE FactSales
ADD Order_ID INT;
GO

USE BI_Enterprise_Analytics;
GO

SELECT TOP 5 *
FROM vw_Customer_Intelligence;

USE BI_Enterprise_Analytics;
GO

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactSales'
  AND COLUMN_NAME = 'Order_ID';

USE BI_Enterprise_Analytics;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'FactSales';


USE BI_Enterprise_Analytics;
GO

SELECT
    COUNT(*) AS Fact_Rows,
    COUNT(Order_ID) AS Rows_With_Order_ID,
    COUNT(DISTINCT Order_ID) AS True_Orders,
    SUM(
        CASE
            WHEN Order_ID IS NULL THEN 1
            ELSE 0
        END
    ) AS Null_Order_ID
FROM dbo.FactSales;

USE BI_Enterprise_Analytics;
GO

TRUNCATE TABLE dbo.FactSales;
GO

INSERT INTO dbo.FactSales
(
    Order_ID,
    Customer_Key,
    Product_Key,
    Territory_Key,
    Date_Key,
    Order_Quantity,
    Sales_Amount,
    Discount,
    Profit
)
SELECT
    soh.SalesOrderID,

    dc.Customer_Key,
    dp.Product_Key,
    dt.Territory_Key,
    dd.Date_Key,

    sod.OrderQty,
    sod.LineTotal,
    sod.UnitPriceDiscount,

    sod.LineTotal -
    (sod.OrderQty * p.StandardCost) AS Profit

FROM AdventureWorks2022.Sales.SalesOrderDetail sod

INNER JOIN AdventureWorks2022.Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID

LEFT JOIN dbo.DimCustomer dc
    ON soh.CustomerID = dc.Customer_ID

LEFT JOIN dbo.DimProduct dp
    ON sod.ProductID = dp.Product_ID

LEFT JOIN dbo.DimTerritory dt
    ON soh.TerritoryID = dt.Territory_ID

LEFT JOIN dbo.DimDate dd
    ON CONVERT(DATE, soh.OrderDate) = dd.Full_Date

LEFT JOIN AdventureWorks2022.Production.Product p
    ON sod.ProductID = p.ProductID;
GO

SELECT TOP 20
    Sales_Key,
    Order_ID,
    Customer_Key,
    Product_Key,
    Sales_Amount
FROM dbo.FactSales;

SELECT
    COUNT(*) AS Fact_Rows,
    COUNT(DISTINCT Order_ID) AS True_Orders,
    SUM(
        CASE WHEN Order_ID IS NULL
        THEN 1 ELSE 0 END
    ) AS Null_Order_ID
FROM dbo.FactSales;

CREATE OR ALTER VIEW dbo.vw_Customer_Intelligence
AS

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Type,

    COUNT(DISTINCT f.Order_ID) AS Total_Orders,

    SUM(f.Sales_Amount) AS Total_Spending,
    SUM(f.Profit) AS Total_Profit

FROM dbo.FactSales f

JOIN dbo.DimCustomer c
    ON f.Customer_Key = c.Customer_Key

GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Type;
GO

CREATE OR ALTER VIEW dbo.vw_Regional_Performance
AS

SELECT
    t.Region,
    t.Country,

    SUM(f.Sales_Amount) AS Revenue,
    SUM(f.Profit) AS Profit,

    COUNT(DISTINCT f.Order_ID) AS Orders

FROM dbo.FactSales f

JOIN dbo.DimTerritory t
    ON f.Territory_Key = t.Territory_Key

GROUP BY
    t.Region,
    t.Country;
GO

USE BI_Enterprise_Analytics;
GO

SELECT
    COUNT(*) AS Total_Customers,

    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_NULL,

    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Country_NULL,

    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Region_NULL

FROM dbo.DimCustomer;

USE BI_Enterprise_Analytics;
GO

ALTER TABLE dbo.DimCustomer
DROP COLUMN Gender, Country, Region;
GO

SELECT TOP 5 *
FROM dbo.DimCustomer;