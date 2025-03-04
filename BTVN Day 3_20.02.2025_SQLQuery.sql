-- Ex 1: Từ bảng dbo.FactInternetSales và dbo.DimSalesTerritory, lấy ra thông tin SalesOrderNumber, SalesOrderLineNumber, ProductKey, SalesTerritoryCountry
của các bản ghi có SalesAmount trên 1000 


SELECT FS.SalesOrderNumber 
 , FS.SalesOrderLineNumber 
 , FS.ProductKey 
 , FS.SalesAmount 
 , DS.SalesTerritoryCountry 
 FROM [dbo].[FactInternetSales] AS FS  
 RIGHT JOIN[dbo].[DimSalesTerritory] AS DS  
 ON DS.SalesTerritoryKey = FS.SalesTerritoryKey 
 WHERE SalesAmount > 1000 

-- Ex 2: Từ bảng dbo.DimProduct và dbo.DimProductSubCategory. Lấy ra ProductKey, EnglishProductName và Color
của các sản phẩm thoả mãn EnglishProductSubCategoryName chứa chữ 'Bikes' và ListPrice có phần nguyên là 3399


SELECT DP.ProductKey
, DP.EnglishProductName
, DP.Color
, DS.EnglishProductSubCategoryName
FROM DimProductSubCategory AS DS
JOIN Dimproduct AS DP
ON DP. ProductSubcategoryKey = DS.ProductSubcategoryKey
WHERE EnglishProductSubCategoryName LIKE '%Bikes'
AND FLOOR (DP.ListPrice) = 3399


-- Ex 3: Từ bảng dbo.DimPromotion, dbo.FactInternetSales, lấy ra ProductKey, SalesOrderNumber, SalesAmount 
từ các bản ghi thoả mãn DiscountPct >= 20%  


SELECT FI.ProductKey
, FI.SalesOrderNumber
, FI.SalesAmount
FROM DimPromotion AS DP 
JOIN FactInternetSales AS FI 
ON DP.PromotionKey = FI.PromotionKey
WHERE DiscountPct >= 0.20


Ex 4: Từ bảng dbo.DimCustomer, dbo.DimGeography,
lấy ra cột Phone, FullName (kết hợp FirstName, MiddleName, LastName kèm khoảng cách ở giữa) 
và City của các khách hàng có YearlyInCome > 150000 và CommuteDistance nhỏ hơn 5 Miles 

SELECT DC.Phone
, CONCAT (DC.FirstName, ' ', DC.MiddleName, ' ', DC.LastName) AS FullName "---> Cách khác gom gọn ' ' : CONCACT_WS(FirstNam, MiddleName, LastName)"
, DG.City
, DC.YearlyInCome
, DC.CommuteDistance
FROM DimCustomer AS DC 
JOIN DimGeography AS DG 
ON DC.GeographyKey = DG.GeographyKey
WHERE YearlyInCome > 150000
AND CommuteDistance LIKE '[0-4]-[0-5]%'




Ex 6: Từ bảng FactInternetSales, FactResellerSale và DimProduct.
Tìm tất cả SalesOrderNumber có EnglishProductName chứa từ 'Road' và có màu vàng (Yellow) 

-- FactInternetSales: đơn hàng kênh online --> SalesOrderNumber: SO1, SO2,...

-- FactResellerSale: đơn hàng kênh offline --> SalesOrderNumber: SO1, SO2, ...

----> Tìm tất cả SalesOrderumber ~ lấy đơn hàng tất cả từ 2 kênh --> Hóa đơn SO01 kênh Onl <> SO01 kênh Offline

"Thầy Sửa"

SELECT FIS.SalesOrderNumber
FROM FactInternetSales AS FIS
LEFT JOIN DimProduct AS DP
ON FIS.ProductKey = DP.ProductKey
WHERE DP. EnglishProductName LIKE '%Road%'
AND DP.Color = 'Yellow'

UNION ALL

SELECT FIS.SalesOrderNumber
FROM [dbo].[FactResellerSales] AS FRS 
LEFT JOIN DimProduct AS DP
ON FRS.ProductKey = DP.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%'
AND DP.Color = 'Yellow'




SELECT FI.SalesOrderNumber
, DP.EnglishProductName
, DP.Color
FROM [dbo].[FactInternetSales] AS FI
JOIN DimProduct AS DP 
ON DP.ProductKey = FI.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%'
AND DP.Color = 'Yellow'
UNION
SELECT R.SalesOrderNumber 
, DP.EnglishProductName
, DP.Color
FROM FactResellerSales AS R
JOIN DimProduct AS DP 
ON R.ProductKey = DP.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%'
AND DP.Color = 'Yellow'

 

-- LogicalExpression  
-- Ex 5: Từ bảng dbo.DimCustomer, lấy ra CustomerKey và thực hiện các yêu cầu sau:  
a. Tạo cột mới đặt tên là YearlyInComeRange từ các điều kiện sau:  
- Nếu YearlyIncome từ 0 đến 50000 thì gán giá trị "Low Income"  

SELECT CustomerKey
, YearlyIncome, 
CASE ----> "Trước CASE WHEN" phải có dấu phẩy ","
WHEN YearlyIncome BETWEEN 0 AND 50000 THEN 'Low Income'
WHEN YearlyIncome BETWEEN 50001 AND 90000 THEN 'Middle Income'
WHEN YearlyIncome >= 90001 THEN 'High Income'
END AS YearlyIncomeRange
FROM DimCustomer

b. Tạo cột mới đặt tên là AgeRange từ các điều kiện sau:  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 đến 39 tuổi thì gán giá trị "Young Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 từ 40 đến 59 tuổi thì gán giá trị "Middle-Aged Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 lớn hơn 60 tuổi thì gán giá trị "Old Adults"

SELECT CustomerKey
, [Birthdate]
, DATEDIFF(YEAR, Birthdate, '2019-12-31') AS Age ,
CASE
WHEN DATEDIFF(YEAR, Birthdate, '2019-12-31') <= 39 THEN 'Young Adults'
WHEN DATEDIFF(YEAR, Birthdate, '2019-12-31') BETWEEN 40 AND 59 THEN 'Middle-Aged Adults'
WHEN DATEDIFF(YEAR, Birthdate, '2019-12-31') > 60 THEN 'Old Adults'
END AS AgeRange
FROM DimCustomer
