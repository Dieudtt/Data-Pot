
-- Ex 1: Từ các bảng dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, lấy ra ProductKey, EnglishProductName của các dòng thoả mãn Discount Pct >= 20%.

"   FactInternetSales --> DimProduct
    FactInternetSales --> DimPromotion "

// DimProduct - PD : ProductKey (PK) ; EnglishProductName
// DimPromotion - PT : PromotionKey (Pk) ; DiscountPct
// FactInternetSales - FI : ProductKey (FK) ; PromotionKey (FK)

Lấy ra : ProductKey (PK: DimProduct ; FK: FactInternetSales) , EnglishProductName
Thỏa mãn : DiscountPct >= 20% ~ 0.2

-----------------------------------

SELECT PD.ProductKey
, PD.EnglishProductName
, PT.DiscountPct
FROM FactInternetSales AS FI 
LEFT JOIN DimProduct AS PD
    ON FI.ProductKey = PD.ProductKey
LEFT JOIN DimPromotion AS PT 
    ON FI.PromotionKey = PT.PromotionKey
WHERE PT.DiscountPct >= 0.2

================================================

-- Ex 2: Từ các bảng DimProduct, DimProductSubcategory, DimProductCategory, 
lấy ra các cột Productkey, EnglishProductName, EnglishProductSubCategoryName, EnglishProductCategoryName 
của sản phẩm thoả mãn điều kiện EnglishProductCategoryName là 'Clothing'.  

" DimProduct --> DimProductSubcategory --> DimProductCategory "

// DimProduct - PD : ProductKey (PK) ; ProductSubcategoryKey (FK) ; EnglishProductName
// DimProductSubcategory - PS : ProductSubcategoryKey (PK) ; ProductCategoryKey (FK); EnglishProductSubcategoryName
// DimProductCategory - PC : ProductCategoryKey (PK) ; EnglishProductCategoryName

Lấy ra : Productkey, EnglishProductName, EnglishProductSubCategoryName, EnglishProductCategoryName
Thỏa mãn: EnglishProductCategoryName IN 'Clothing'

-----------------------------------

SELECT PD.Productkey
, PD.EnglishProductName
, PS.EnglishProductSubCategoryName
, PC.EnglishProductCategoryName
FROM DimProduct AS PD
LEFT JOIN DimProductSubcategory AS PS 
ON PD.ProductSubcategoryKey = PS.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS PC 
ON PS.ProductCategoryKey = PC.ProductCategoryKey
WHERE PC.EnglishProductCategoryName IN ('Clothing')

================================================

-- Ex 3: Từ bảng FactInternetSales và DimProduct, lấy ra ProductKey, EnglishProductName, ListPrice của những sản phẩm chưa từng được bán.  

Sử dụng 2 cách: toán tử IN và phép JOIN

 "FactInternetSales --> DimProduct" 

 // FactInternetSales - FI : ProductKey (FK) ; PromotionKey (FK)
 // DimProduct -DP : ProductKey (PK) ; EnglishProductName ; ListPrice


 Lấy ra : ProductKey, EnglishProductName, ListPrice những sản phẩm chưa được bán

-----------------------------------
-- Phép JOIN 
WITH SoldProduct AS 
(
SELECT DISTINCT ProductKey
FROM FactInternetSales
) 
SELECT DP.ProductKey
, DP.EnglishProductName
, DP.ListPrice
FROM DimProduct AS DP 
LEFT JOIN SoldProduct AS SP 
ON SP.ProductKey = DP.ProductKey
WHERE SP.ProductKey IS NULL 

-- Toán tử IN

SELECT ProductKey
, EnglishProductName
, ListPrice
FROM DimProduct
WHERE ProductKey NOT IN 
(
    SELECT DISTINCT ProductKey
    FROM FactInternetSales
)


================================================

-- Ex 4: Từ bảng DimDepartmentGroup, lấy ra thông tin DepartmentGroupKey (PK), DepartmentGroupName, ParentDepartmentGroupKey (FK1)
và thực hiện self-join lấy ra ParentDepartmentGroupName.

SELECT Child.DepartmentGroupKey
, Child.ParentDepartmentGroupKey
, Child.DepartmentGroupName
, Parent.DepartmentGroupName ParentDepartmentGroupName
FROM DimDepartmentGroup AS Child
LEFT JOIN DimDepartmentGroup AS Parent
ON Child.ParentDepartmentGroupKey = Parent.DepartmentGroupKey



================================================

-- Ex 5: Từ bảng FactFinance, DimOrganization, DimScenario, lấy ra OrganizationKey, OrganizationName, Parent OrganizationKey,
và thực hiện self-join lấy ra Parent OrganizationName, Amount thoả mãn điều kiện ScenarioName là 'Actual'. 

" FactFinance --> DimScenario 
  FactFinance --> DimOrganization "

// FactFinance - FF : FinanceKey (PK) ; OrganizationKey (FK3) ; ScenarioKey (FK4) ; Amount
// DimOrganization - DO  : OrganizationKey (PK) ; ParentOrganizationKey (FK1) ; OrganizationName ;  "PHÂN CẤP"
// DimScenario - DS : ScenarioKey (PK) ; ScenarioName

Lấy ra: OrganizationKey, OrganizationName, Parent OrganizationKey
Thực hiện SELF JOIN lấy ra : ParentOrganizationName, Amount
Thỏa mãn điều kiện: ScenarioName là 'Actual'


*******************************************

SELECT FF.OrganizationKey
, FF.Amount
, DO.OrganizationName
, DS.ScenarioName
FROM FactFinance AS FF 
LEFT JOIN DimScenario AS DS 
ON FF.ScenarioKey = DS.ScenarioKey
LEFT JOIN DimOrganization AS DO 
ON FF.OrganizationKey = Do.OrganizationKey
WHERE DS.ScenarioName IN ('Actual')

****************************************

-----------------------------------

WITH OrgCTE AS
(
    SELECT Child.OrganizationKey
, Child.OrganizationName
, Child.ParentOrganizationKey
, Parent.OrganizationName ParentOrganizationName
FROM DimOrganization AS Child
LEFT JOIN DimOrganization AS Parent
ON Child.ParentOrganizationKey = Parent.OrganizationKey
), ScenarioCTE AS 
(
 SELECT FF.OrganizationKey
, FF.Amount
, DO.OrganizationName
, DS.ScenarioName
FROM FactFinance AS FF 
LEFT JOIN DimScenario AS DS 
ON FF.ScenarioKey = DS.ScenarioKey
LEFT JOIN DimOrganization AS DO 
ON FF.OrganizationKey = Do.OrganizationKey
WHERE DS.ScenarioName IN ('Actual')   
)
SELECT 
OrgCTE.OrganizationKey
, OrgCTE.OrganizationName
, OrgCTE.ParentOrganizationKey
, OrgCTE.ParentOrganizationName
, ScenarioCTE.Amount
, ScenarioCTE.ScenarioName
FROM OrgCTE
JOIN ScenarioCTE
    ON OrgCTE.OrganizationKey = ScenarioCTE.OrganizationKey

