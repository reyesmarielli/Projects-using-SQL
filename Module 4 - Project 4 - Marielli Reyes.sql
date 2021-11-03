--Project 4 - JOINs
--Marielli Reyes
--10/07/2018


--1.  Show the Supplier companyname, then Suppliers.supplierID, then Products.supplierID, then the productname. Order by SupplierID. Use JOIN and verify that the records match up appropriately.

SELECT		Suppliers.CompanyName,
			Suppliers.SupplierID,
			Products.SupplierID,
			Products.ProductName
FROM		Products
	JOIN	Suppliers	ON	Suppliers.SupplierID = Products.SupplierID
ORDER BY	Suppliers.SupplierID


--2.  Show the ProductID, ProductName, and Supplier Company Name of the supplier for all Products. Order by ProductID. 

SELECT		Products.ProductID,
			Products.ProductName,
			Suppliers.CompanyName
FROM		Products
	JOIN	Suppliers	ON	Products.SupplierID = Suppliers.SupplierID
ORDER BY	Products.ProductID


--3.  Show the Supplier Company Name, ProductName, and unitprice for all products. unitprice descending, then by productID.

SELECT		Suppliers.CompanyName,
			Products.ProductName,
			Products.UnitPrice
FROM		Products
	JOIN	Suppliers				  ON	Suppliers.SupplierID = Products.SupplierID
ORDER BY	Products.UnitPrice		DESC,
			Products.ProductID	


--4.  For only discontinued products with non-zero unitsinstock, show the productID, productname, and Supplier companyname.

SELECT		Products.ProductID,
			Products.ProductName,
			Suppliers.CompanyName
FROM		Products
	JOIN	Suppliers	ON	Products.SupplierID = Suppliers.SupplierID
WHERE		Discontinued = 1
	 AND	UnitsInStock > 0
ORDER BY	Products.ProductID	


--5.  We need a report that tells us everything we need to place an order. This should be only non-discontinued products whose (unitsInstock + unitsOnOrder) is less than or equal to the Reorderlevel. As the final column, it should show how many to order. We usually order enough so that (unitsInStock+UnitsOnOrder) is equal to twice the reorderlevel. Columns should be SupplierID, CompanyName, companyphone, productID, productName, amount to order. Order by SupplierID, then by productID.

SELECT		Suppliers.SupplierID,
			Suppliers.CompanyName,
			Suppliers.Phone											AS  [CompanyPhone],
			Products.ProductID,
			Products.ProductName,
			((2 * ReorderLevel) - (UnitsInStock + UnitsOnOrder))	AS  [AmountToOrder]
FROM		Suppliers
	JOIN	Products												ON	Suppliers.SupplierID = Products.SupplierID
WHERE		Discontinued = 0
	 AND	UnitsInStock + UnitsOnOrder <= ReorderLevel
ORDER BY	Suppliers.SupplierID,
			Products.ProductID


--6.  Do # 5 again, but also add the cost, which will be the order amount multiplied by the unitprice.

SELECT		Suppliers.SupplierID,
			Suppliers.CompanyName,
			Suppliers.Phone														AS  [CompanyPhone],
			Products.ProductID,
			Products.ProductName,
			((2 * ReorderLevel) - (UnitsInStock + UnitsOnOrder))				AS  [AmountToOrder],
			((2 * ReorderLevel) - (UnitsInStock + UnitsOnOrder)) * UnitPrice	AS  [CostOfOrder]
FROM		Suppliers
	JOIN	Products															ON	Suppliers.SupplierID = Products.SupplierID
WHERE		Discontinued = 0
	 AND	UnitsInStock + UnitsOnOrder <= ReorderLevel
ORDER BY	Suppliers.SupplierID,
			Products.ProductID


--7.  (shifting to categories and products) Show the productID, productname, unitprice, and categoryname of all products.

SELECT		Products.ProductID,
			Products.ProductName,
			Products.UnitPrice,
			Categories.CategoryName
FROM		Products
	JOIN	Categories	ON	Products.CategoryID	= Categories.CategoryID
ORDER BY	Products.ProductID


--8.  Show the categoryName, productID, productname, and unitprice of all products. Only show products whose inventory value is greater than $200.

SELECT		Categories.CategoryName,
			Products.ProductID,
			Products.ProductName,
			Products.UnitPrice
FROM		Products
	JOIN	Categories	ON	Categories.CategoryID = Products.CategoryID
WHERE		UnitsInStock * UnitPrice > 200
ORDER BY	Categories.CategoryName 


--9.  Show the CategoryName, productID, productName, and supplierName of all products. Order columns from left to right.(Note this is a 3-table join.)

SELECT		Categories.CategoryName,
			Products.ProductID,
			Products.ProductName,
			Suppliers.CompanyName		AS	[SupplierName]
FROM		Products
	JOIN	Suppliers					ON	Products.SupplierID	  = Suppliers.SupplierID
	JOIN	Categories					ON	Products.CategoryID   = Categories.CategoryID
ORDER BY	Categories.CategoryName,
			Products.ProductID,
			Products.ProductName,
			Suppliers.CompanyName


--10. Show the SupplierName, CategoryName, ProductID, and productName of all products. Order columns from left to right.

SELECT		Suppliers.CompanyName		AS SupplierName,
			Categories.CategoryName,
			Products.ProductID,
			Products.ProductName
FROM		Products
	JOIN	Suppliers					ON	Suppliers.SupplierID  = Products.SupplierID
	JOIN	Categories					ON	Categories.CategoryID = Products.CategoryID
ORDER BY	Suppliers.CompanyName,
			Categories.CategoryName,
			Products.ProductID,
			Products.ProductName


	
	
