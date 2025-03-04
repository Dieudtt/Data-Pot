-- Ex1: Dựa và bảng FactInternetSales, tính tổng số lượng sản phẩm (OrderQuantity) đã được bán cho mỗi khách hàng (CustomerKey).
Hiển thị kết quả theo thứ tự giảm dần của tổng số lượng

SELECT CustomerKey
, SUM(OrderQuantity) AS TotalOrdQuantity
FROM FactInternetSales
GROUP BY CustomerKey
ORDER BY TotalOrdQuantity DESC


-- Ex2: Dựa vào bảng FactInternetSales và DimProduct, thống kê tổng số lượng sản phẩm được bán (TotalOrderQuantity) cho mỗi sản phẩm (EnglishProductName).
 Hiển thị kết quả theo thứ tự giảm dần của TotalOrderQuantity

 FactInternetSales --> DimProduct
// FactInternetSales : SalesAmount ; OrderDateKey (FK3) ; TotalProductCost ; ProductKey (FK2)
// DimProduct : ProductKey (PK) ;  ProductSubCategoryKey (FK1)

SELECT DP.EnglishProductName
, SUM(FI.OrderQuantity) AS TotalOrderQuantity 
FROM FactInternetSales AS FI 
LEFT JOIN DimProduct AS DP 
ON FI.ProductKey = DP.ProductKey
GROUP BY DP.EnglishProductName
ORDER BY TotalOrderQuantity DESC

-- Ex3: Dựa vào bảng FactInternetSales, DimCustomer. Tạo ra trường FullName từ (FirstName, MiddleName, LastName và sử dụng dấu cách ' ' để ghép nối)  
 và thống kê số lượng đơn đặt hàng (OrderCount) mà họ đã thực hiện trong năm 2014.
 Và chỉ lấy những khách hàng có ít nhất 2 đơn đặt hàng.
 FactInternetSales --> DimCustomer
 // FactInternetSales : CustomerKey (FK1), OrderDateKey (FK3)
 // DimCustomer : CustomerKey (PK) , FirstName , MiddleName , LastName

SELECT
  CONCAT_WS (' ', DC.FirstName, DC.MiddleName, DC.LastName) AS FullName
, COUNT(FI.SalesOrderNumber) AS OrderCount
FROM FactInternetSales AS FI 
LEFT JOIN DimCustomer AS DC 
ON FI.CustomerKey = DC.CustomerKey 
WHERE YEAR(FI.OrderDate) = 2014
GROUP BY DC.FirstName, DC.MiddleName, DC.LastName
HAVING COUNT(FI.SalesOrderNumber) >= 2

SELECT * FROM FactInternetSales

-- Ex4: Từ bảng DimProduct, DimProductSubCategory, DimProductCategory và FactInternetSales. 
Viết truy vấn lấy ra EnglishProductCategoryName, TotalAmount (tính theo SaleAmount) của 2 danh mục có doanh thu cao nhất trong năm 2014

FactInternetSales -->> DimProduct -->> DimProductSubCategory -->> DimProductCategory

// FactInternetSales : SalesAmount ; OrderDateKey (FK3) ; TotalProductCost ; ProductKey (FK2)
// DimProduct : ProductKey (PK) ;  ProductSubCategoryKey (FK1)
// DimProductSubcategory :  ProductSubCategoryKey (PK) ; ProductCategoryKey (FK1)
// DimProductCategory : ProductCategoryKey (PK) ; EnglishProductCategoryName


SELECT TOP 2
 PC.EnglishProductCategoryName
, SUM(FI.SalesAmount) AS TotalAmount 
FROM FactInternetSales AS FI 
LEFT JOIN DimProduct AS DP
    ON FI.ProductKey = DP.ProductKey
LEFT JOIN DimProductSubcategory AS PS 
    ON DP.ProductSubCategoryKey = PS.ProductSubCategoryKey
LEFT JOIN DimProductCategory AS PC 
    ON PS.ProductCategoryKey = PC.ProductCategoryKey
WHERE YEAR(FI.OrderDate) = 2014
GROUP BY PC.EnglishProductCategoryName


--  Ex5: Từ bảng FactInternetSale và bảng FactResellerSale,
thực hiện từ 2 nguồn bán là Internet và Reseller đưa ra tất cả tất cả các SaleOrderNumber và doanh thu của mỗi SaleOrderNumber

SELECT SalesOrderNumber
, SUM(SalesAmount) AS TotalSales
FROM
(
SELECT SalesOrderNumber, SalesAmount FROM [FactInternetSales]
UNION ALL
SELECT SalesOrderNumber, SalesAmount FROM [FactResellerSales]
) AS CombineSale
GROUP BY SalesOrderNumber
ORDER BY TotalSales DESC 

--  Ex6: Dựa vào 2 bảng DimDepartmentGroup và bảng FactFinace, 
thực hiện lấy ra TotalAmount (dựa vào Amount) của DepartmentGroupName và ParentDepartmentGroupName 

(SELECT Child.DepartmentGroupKey
, Child.ParentDepartmentGroupKey
, Child.DepartmentGroupName
, Parent.DepartmentGroupName ParentDepartmentGroupName
FROM DimDepartmentGroup AS Child
LEFT JOIN DimDepartmentGroup AS Parent
ON Child.ParentDepartmentGroupKey = Parent.DepartmentGroupKey) AS PGroupName 


SELECT FF.Amount
, SUM(FF.Amount) AS TotalAmount
FROM FactFinance AS FF 
LEFT JOIN DimDepartmentGroup AS DG 
ON FF.DepartmentGroupKey = DG.DepartmentGroupKey
LEFT JOIN 
GROUP BY FF.Amount


SELECT DG.DepartmentGroupName
, ParentDG.DepartmentGroupName AS ParentDepartmentGroupName
, SUM(FF.Amount) AS TotalAmount
FROM FactFinance AS FF
JOIN DimDepartmentGroup AS DG 
    ON FF.DepartmentGroupKey = DG.DepartmentGroupKey
LEFT JOIN DimDepartmentGroup AS ParentDG
    ON DG.ParentDepartmentGroupKey = ParentDG.DepartmentGroupKey
GROUP BY DG.DepartmentGroupName, ParentDG.DepartmentGroupName
ORDER BY TotalAmount DESC
