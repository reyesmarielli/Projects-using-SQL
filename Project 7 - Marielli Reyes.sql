--Project 7 - Common Tasks
--Marielli Reyes
--10/27/2018


--1.  Find any products that have not appeared on an order, ever. (LEFT JOIN, WHERE IS NULL)

SELECT			Products.ProductID,
				Products.ProductName,
				[Order Details].OrderID,
				[Order Details].ProductID
FROM			Products
  LEFT JOIN		[Order Details]	ON	[Order Details].ProductID = Products.ProductID
WHERE			[Order Details].ProductID IS NULL
ORDER BY		Products.ProductID

--2.  Find any products that have not appeared on an order in 1996. (subquery with NOT IN)

SELECT		DISTINCT Products.ProductID,
			Products.ProductName
FROM		Products
   JOIN		[Order Details]	ON	[Order Details].ProductID = Products.ProductID
WHERE		[Order Details].ProductID NOT IN 
			   (SELECT	Products.ProductID
				FROM	[Order Details]
				  JOIN	Products ON	[Order Details].ProductID = Products.ProductID
				  JOIN	Orders	 ON	 Orders.OrderID = [Order Details].OrderID
				WHERE	YEAR(Orders.OrderDate)  = 1996)
ORDER BY	Products.ProductID

--3.  Find any customers who have not placed an order, ever (similar to #1).

SELECT			Customers.CustomerID,
				Customers.CompanyName,
				Orders.OrderID,
				Orders.CustomerID		
FROM			Customers
	LEFT JOIN	Orders	ON	Orders.CustomerID = Customers.CustomerID
WHERE			Orders.CustomerID IS NULL
ORDER BY		Customers.CustomerID

--4.  Find any customers that did not place an order in 1996 (similar to #2).

SELECT		DISTINCT Customers.CustomerID,
			Customers.CompanyName
FROM		Customers
   JOIN		Orders	ON	Orders.CustomerID = Customers.CustomerID
WHERE		Orders.CustomerID NOT IN 
			   (SELECT	Customers.CustomerID
				FROM	Customers
				  JOIN	Orders ON Customers.CustomerID = Orders.CustomerID
				WHERE	YEAR(Orders.OrderDate) = 1996)
ORDER BY	Customers.CustomerID

--5.  List all products that have been sold (any date). We need this to run fast, and we don't really want to see anything from the [order details] table, so use EXISTS.

SELECT		ProductID,	
			ProductName
FROM		Products
WHERE		EXISTS 
			   (SELECT	ProductID
				FROM    [Order Details]
				WHERE	Products.ProductID = [Order Details].ProductID)
ORDER BY	ProductID					

--6.  (DON"T DO THIS ONE! )Show all products, and a count of how many were sold across all orders in 1996. Make sure to show even products where none were sold in 1996. (OUTER JOIN)

--7.  Give all details of all the above-average priced products. (simple subquery)

SELECT		*
FROM		Products
WHERE		unitPrice > (SELECT AVG(unitPrice)
                         FROM        Products)ORDER BY	ProductID

--8.  Find all orders where the ShipName has non-ASCII characters in it (trick: WHERE shipname <> CAST(ShipName AS VARCHAR).

SELECT		OrderID
FROM		Orders
WHERE		Shipname <> CAST(ShipName AS VARCHAR)
ORDER BY	OrderID

--9.  Show all Customers' CompanyName and region. Replace any NULL region with the word 'unknown'. Use the ISNULL() function. (Do a search on SQL ISNULL)

SELECT		CompanyName,
			ISNULL(Region, 'unknown') AS Region
FROM		Customers
ORDER BY	CompanyName,
			CustomerID

--10. We need to know a list of customers (companyname) who paid more than $100 for freight on an order in 1996 (based on orderdate). Use the ANY operator to get this list. (We are expecting this to have to run often on billions of records. This could be done much less efficiently with a JOIN and DISTINCT.)

SELECT		CompanyName
FROM		Customers
WHERE		$100 < ANY (SELECT	Freight
						FROM	Orders
						WHERE	Orders.CustomerID = Customers.CustomerID
						  AND	YEAR(Orders.OrderDate) = 1996)
ORDER BY	CompanyName
							
--11. We want to know a list of customers (companyname) who paid more than $100 for freight on all of their orders in 1996 (based on orderdate). Use the ALL operator. (We are expecting this to have to run often on billions of records. This could be done much less efficiently using COUNTs.)

SELECT		CompanyName
FROM		Customers
WHERE		$100 < ALL  (SELECT	Freight
						 FROM	Orders
						 WHERE	Orders.CustomerID = Customers.CustomerID
						   AND	YEAR(Orders.OrderDate) = 1996)
ORDER BY	CompanyName

--12. Darn! These unicode characters are messing up a downstream system. How bad is the problem? List all orders where the shipName has characters in it that are not upper case letters A-Z or lower case letters a-z. Use LIKE to do this. (see the LIKE video, and use '%[^a-zA-Z]%'

SELECT		OrderID
FROM		Orders
WHERE		ShipName LIKE '%[^a-zA-Z]%'
ORDER BY	OrderID