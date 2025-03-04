
/* Ex1: Từ bộ AdventureWorksDW2019, bảng FactInternetSales,  lấy tất cả các bản ghi có OrderDate từ ngày '2011-01-01' về sau và ShipDate trong năm 2011  */  

SELECT OrderDate
, YEAR (ShipDate) AS YearShipDateShipDate
FROM [dbo].[FactInternetSales]
WHERE OrderDate >= '2011-01-01'
AND (YEAR (ShipDate)) = '2011'

/*Ex2: Từ bộ AdventureWorksDW2019, bảng DimProduct, Lấy ra thông tin ProductKey, ProductAlternateKey và EnglishProductName của các sản phẩm.  
Lọc các sản phẩn có ProductAlternasteKey bắt đầu bằng chữ 'BK-' theo sau đó là 1 ký tự bất kỳ khác chữ T và kết thúc bằng 2 con số bất kỳ 
Đồng thời, thoả mãn điều kiện Color là Black hoặc Red hoặc White  */  

SELECT ProductKey
, ProductAlternateKey
, EnglishProductName
FROM DimProduct
WHERE ProductAlternateKey LIKE '%BK-[^T]%[0-9][0-9]'
AND Color IN ('Black', 'Red', 'White')


/* Ex3: Từ bộ AdventureWorksDW2019, bảng DimProduct, lấy ra tất cả các sản phẩm có cột Color là Red */  

SELECT ProductKey
, ProductAlternateKey
, Color
FROM DimProduct
WHERE Color IN ('Red')


/* Ex4: Từ bộ AdventureWorksDW2019, bảng FactInternetSales chứa thông tin bán hàng, lấy ra tất cả các bản ghi bán các sản phẩm có màu là Red */  

SELECT
 FactInternetSales.ProductKey
, ProductAlternateKey
, DimProduct.Color
FROM FactInternetSales
JOIN DimProduct ON FactInternetSales.ProductKey = DimProduct.ProductKey
WHERE DimProduct.Color IN ('Red')


SELECT ProductKey
FROM [dbo].[FactInternetSales] 
WHERE [ProductKey] IN ( 
    SELECT ProductKey
    FROM [dbo].[DimProduct] 
    WHERE Color = 'RED'
)





/* Ex5: Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra EmployeeKey, FirstName, LastName, MiddleName
của những nhân viên có MiddleName không bị Null và cột Phone có độ dài 12 ký tự */  

SELECT EmployeeKey
, FirstName
, LastName
, MiddleName
, Phone
FROM DimEmployee
WHERE MiddleName IS NOT NULL
AND (LEN(Phone) = '12')


--- EX 6:

SELECT FirstName
, MiddleName
, LastName
, FirstName + '-' + MiddleName + '-' + LastName AS FullName
FROM DimEmployee

SELECT FirstName
, MiddleName
, LastName
, CONCAT (FirstName, '-', MiddleName, '-', LastName) AS FullName
FROM DimEmployee

-- Cột AgeHired tính tuổi nhân viên tại thời điểm được tuyển, sử dụng cột HireDate và BirthDate

SELECT FirstName
, MiddleName
, LastName
, CONCAT (FirstName, '-', MiddleName, '-', LastName) AS FullName
, HireDate
, BirthDate
, DATEDIFF(year,BirthDate, HireDate) AS 'AgeHired'
FROM DimEmployee

-- Cột AgeNow tính tuổi nhân viên đến thời điểm hiện tại, sử dụng cột BirthDate 

SELECT FirstName
, MiddleName
, LastName
, CONCAT (FirstName, '-', MiddleName, '-', LastName) AS FullName
, HireDate
, BirthDate
, DATEDIFF(year,BirthDate, HireDate) AS 'AgeHired'
, DATEDIFF(year,BirthDate, '2025-02-16') AS 'AgeNow'
FROM DimEmployee

-- Cột UserName được lấy ra từ phần đằng sau dấu "\" của cột LoginID  

SELECT LoginID
, SUBSTRING(LoginID, CHARINDEX('\', LoginID) + 1, LEN(LoginID)) AS UserName 
, FirstName
, MiddleName
, LastName
, CONCAT (FirstName, '-', MiddleName, '-', LastName) AS FullName
, HireDate
, BirthDate
, DATEDIFF(year,BirthDate, HireDate) AS 'AgeHired'
, DATEDIFF(year,BirthDate, '2025-02-16') AS 'AgeNow'
FROM DimEmployee