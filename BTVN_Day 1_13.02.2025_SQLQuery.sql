

EX 1 ---------------------
SELECT *
FROM [dbo].[DimEmployee]

SELECT EmployeeKey
, FirstName
, LastName
, BaseRate
, VacationHours
, SickLeaveHours
FROM [dbo].[DimEmployee]

SELECT EmployeeKey
, FirstName
, LastName
, BaseRate
, VacationHours
, SickLeaveHours
, BaseRate * VacationHours AS 'VacationLeavePay' 
FROM [dbo].[DimEmployee]

SELECT EmployeeKey
, FirstName
, LastName
, BaseRate
, VacationHours
, SickLeaveHours
, BaseRate * SickLeaveHours AS 'SickLeavePay'
FROM [dbo].[DimEmployee]

SELECT EmployeeKey
, FirstName
, LastName
, BaseRate
, VacationHours
, SickLeaveHours
, BaseRate * VacationHours AS 'VacationLeavePay' 
, BaseRate * SickLeaveHours AS 'SickLeavePay'
, (BaseRate * VacationHours) + (BaseRate * SickLeaveHours) AS 'TotalLeavePay'
FROM [dbo].[DimEmployee]

-/-/-/- CÁCH 3

WITH Temp_CTE AS
(
    SELECT
    EmployeeKey,
    FirstName,
    LastName,
    BaseRate,
    VacationHours,
    SickLeaveHours,
    FirstName + ' ' + LastName AS FullName,
    BaseRate * VacationHours AS VacationLeavePay,
    BaseRate * SickLeaveHours AS SickLeavePay
FROM dbo.DimEmployee
)
 
SELECT
    EmployeeKey,
    FirstName
FROM Temp_CTE


EX 2 --------------------------------------------------------

SELECT *
FROM [dbo].[FactInternetSales]

SELECT SalesOrderNumber
, ProductKey
, OrderDate 
, OrderQuantity 
, UnitPrice 
, OrderQuantity * UnitPrice AS 'TotalRevenue' 
FROM [dbo].[FactInternetSales]

SELECT SalesOrderNumber
, ProductKey
, OrderDate
, ProductStandardCost
, DiscountAmount 
, ProductStandardCost + DiscountAmount  AS 'TotalCost'
FROM [dbo].[FactInternetSales]

SELECT SalesOrderNumber
, ProductKey
, OrderDate
, OrderQuantity * UnitPrice AS 'TotalRevenue' 
, ProductStandardCost + DiscountAmount  AS 'TotalCost'
, (OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount)  AS 'Profit'
FROM [dbo].[FactInternetSales]

SELECT SalesOrderNumber
, ProductKey
, OrderDate
, OrderQuantity * UnitPrice AS 'TotalRevenue' 
, ProductStandardCost + DiscountAmount  AS 'TotalCost'
, OrderQuantity * UnitPrice - ProductStandardCost + DiscountAmount  AS 'Profit'
, (OrderQuantity * UnitPrice - ProductStandardCost + DiscountAmount)/(OrderQuantity * UnitPrice) * 100 AS 'Profit Margin'
FROM [dbo].[FactInternetSales]





EX 3 -------------------------------
SELECT *
FROM [dbo].[FactProductInventory]

SELECT MovementDate
, ProductKey
, UnitsBalance
, UnitsIn
, UnitsOut 
, UnitsBalance + UnitsIn - UnitsOut AS 'NoProductEOD'
FROM [dbo].[FactProductInventory]

SELECT MovementDate
, ProductKey
, UnitsBalance
, UnitsIn
, UnitsOut 
, UnitsBalance + UnitsIn - UnitsOut AS 'NoProductEOD'
, UnitsBalance + UnitsIn - UnitsOut * UnitCost AS 'TotalCost'
FROM [dbo].[FactProductInventory]


EX 4---------------------------------------------------------------
SELECT *
FROM [dbo].[DimGeography]

SELECT EnglishCountryRegionName
, City
, StateProvinceName
FROM [dbo].[DimGeography]



SELECT EnglishCountryRegionName
, City
, StateProvinceName
FROM [dbo].[DimGeography]
ORDER BY EnglishCountryRegionName ASC, City DESC

SELECT DISTINCT EnglishCountryRegionName
, City
, StateProvinceName
FROM [dbo].[DimGeography]
ORDER BY EnglishCountryRegionName ASC, City DESC



EX 5 ---------------------------------------------------------
SELECT *
FROM [dbo].[DimProduct]

SELECT TOP 10 PERCENT EnglishProductName, ListPrice
FROM [dbo].[DimProduct]
ORDER BY ListPrice DESC



