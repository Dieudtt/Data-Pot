-- Ex1: Từ bảng DimEmployee, tính BaseRate trung bình của từng Title có trong công ty
SELECT Title 
, AVG(BaseRate) AvgBaseRate
FROM DimEmployee
GROUP BY Title

SELECT *
FROM DimEmployee


--  Ex 2: Từ bảng FactInternetSales, lấy ra cột TotalOrderQuantity, sử dụng cột OrderQuantity tính tổng số lượng bán ra với từng ProductKey và từng ngày OrderDate

SELECT *
FROM FactInternetSales

Lấy ra cột : Total Order Quantity
Sử dụng cột : Order Quantity --> tính tổng : SỐ LƯỢNG BÁN RA với từng ProductKey & từng ngày Order Date

------------------------------------------

SELECT SUM(OrderQuantity)
FROM FactInternetSales

SELECT 
    ProductKey, 
    OrderDate, 
    SUM(OrderQuantity) AS TotalOrderQuantity
FROM FactInternetSales
GROUP BY ProductKey, OrderDate
ORDER BY OrderDate, ProductKey

SELECT 
FROM FactInternetSales

-- Ex3: Từ bảng DimProduct, FactInternetSales, DimProductCategory và các bảng liên quan nếu cần thiết 

Lấy ra thông tin ngành hàng gồm: CategoryKey, EnglishCategoryName của các dòng thoả mãn điều kiện OrderDate trong năm 2012 và tính toán các cột sau đối với từng ngành hàng:  

- TotalRevenue sử dụng cột SalesAmount 
- TotalCost sử dụng cột TotalProductCost 
- TotalProfit được tính từ (TotalRevenue - TotalCost) 
Chỉ hiển thị ra những bản ghi có TotalRevenue > 5000

-------------------------------
FactInternetSales --> DimProduct --> DimProductSubcategory --> DimProductCategory


// FactInternetSales : SalesAmount ; OrderDateKey (FK3) ; TotalProductCost ; ProductKey (FK2)
// DimProduct : ProductKey (PK) ;  ProductSubCategoryKey (FK1)
// DimProductSubcategory :  ProductSubCategoryKey (PK) ; ProductCategoryKey (FK1)
// DimProductCategory : ProductCategoryKey (PK) ; EnglishProductCategoryName


Lấy thông tin gồm : Category ; EnglishCategoryName
Thỏa mãn điều kiện : 
-- OrderDate trong năm 2012
-- Tính toánh các cột với từng ngành hàng :
    -->> TotalRevenue sử dụng cột SalesAmount 
    -->> TotalCost sử dụng cột TotalProductCost
    -->> TotalProfit được tính từ (TotalRevenue - TotalCost)
-->> Chỉ hiển thị kết quả TotalRevenue > 5000

==========================================

SELECT PS.ProductCategoryKey, PC.EnglishProductCategoryName
, YEAR(FI.OrderDate) AS OrdYear
, SUM(FI.SalesAmount) AS TotalRevenue
, SUM(FI.TotalProductCost) AS TotalCost
, SUM(FI.SalesAmount) - SUM(FI.TotalProductCost) AS TotalProfit
FROM FactInternetSales AS FI 
LEFT JOIN DimProduct AS DP ON FI.ProductKey = DP.ProductKey
LEFT JOIN DimProductSubcategory AS PS ON DP.ProductSubCategoryKey = PS.ProductSubCategoryKey
LEFT JOIN DimProductCategory AS PC ON PS.ProductCategoryKey = PC.ProductCategoryKey
WHERE YEAR(FI.OrderDate) = 2012
GROUP BY YEAR(FI.OrderDate), PS.ProductCategoryKey, PC.EnglishProductCategoryName
HAVING SUM(FI.SalesAmount) > 5000

SELECT *
FROM FactInternetSales


-- Ex 4: Từ bảng FactInternetSales, DimProduct, 

- Tạo ra cột Color_group từ cột Color, nếu Color là 'Black' hoặc 'Silver' gán giá trị 'Basic' cho cột Color_group, nếu không lấy nguyên giá trị cột Color sang 
- Sau đó tính toán cột TotalRevenue từ cột SalesAmount đối với từng Color_group mới này  

SELECT 
    CASE 
        WHEN DP.Color IN ('Black', 'Silver') THEN 'Basic' 
        ELSE DP.Color 
    END AS Color_group,
    SUM(FI.SalesAmount) AS TotalRevenue
FROM FactInternetSales FI
JOIN DimProduct DP ON FI.ProductKey = DP.ProductKey
GROUP BY 
    CASE 
        WHEN DP.Color IN ('Black', 'Silver') THEN 'Basic' 
        ELSE DP.Color 
    END
ORDER BY TotalRevenue DESC


-- Ex 5 (nâng cao) Từ bảng FactInternetSales, FactResellerSales và các bảng liên quan nếu cần, sử dụng cột SalesAmount tính toán doanh thu ứng với từng tháng của 2 kênh bán Internet và Reseller 

Kết quả trả ra sẽ gồm các cột sau: Year, Month, InternSales, Reseller_Sales 
Gợi ý: Tính doanh thu theo từng tháng ở mỗi bảng độc lập FactInternetSales và FactResllerSales bằng sử dụng CTE  

Lưu ý khi có nhiều hơn 1 CTE trong mệnh đề thì viết syntax như sau:  

WITH Name_CTE_1 AS ( 
SELECT statement 
) 
, Name_CTE_2 AS ( 
SELECT statement 
)  

SELECT statement 

==========================================================


WITH InternetSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS InternetSales
    FROM FactInternetSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
), 
ResellerSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS Reseller_Sales
    FROM FactResellerSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT I.YEAR
R.MONTH
FROM InternetSales I
FULL JOIN ResellerSales R
    ON I.Year = R.Year 
    AND I.Month = R.Month
ORDER BY Year, Month
