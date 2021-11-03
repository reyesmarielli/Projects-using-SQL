--Project 6 - Ranking and Conversions
--Marielli Reyes
--10/21/2018


--1.  Show the CategoryName, CategoryDescription, and number of products in each category. You will have trouble grouping by CategoryDescription, because of its data type.

SELECT		Categories.CategoryName,
			CAST(Categories.[Description] AS VARCHAR)	AS [CategoryDescription],
			COUNT(Products.ProductID)					AS [Number of Products]	
FROM		Products
	JOIN	Categories									ON	Categories.CategoryID = Products.CategoryID
GROUP BY	Categories.CategoryName,
			CAST(Categories.[Description] AS VARCHAR),
			Categories.CategoryID
ORDER BY	Categories.CategoryName,
			Categories.CategoryID

--2.  We want to know the percentage of buffer stock we hold on every product. We want to see this as a percentage above/below the reorderLevel. Show the ProductID, productname, unitsInstock, reOrderLevel, and the percent above/below the reorderlevel. So if unitsInstock is 13 and the reorderLevel level is 10, the percent above/below would be 0.30. Make sure you convert at the appropriate times to ensure no rounding occurs. Check your work carefully.

SELECT		ProductID,
			ProductName,
			UnitsInStock,
			ReorderLevel, 
			(UnitsInStock - ReorderLevel)/CAST(ReorderLevel AS FLOAT) AS [Percent Above/Below ReorderLevel]
FROM		Products
WHERE		UnitsInStock <> 0
	AND		ReorderLevel <> 0
ORDER BY	ProductID

--3.  Show the orderID, orderdate, and total amount due for each order, including freight. Make sure that the amount due is a money data type and that there is no loss in accuracy as conversions happen. Do not do any unnecessary conversions. The trickiest part of this is the making sure that freight is NOT in the SUM.

SELECT		Orders.OrderID,
			Orders.OrderDate,
			SUM(([Order Details].UnitPrice  * [Order Details].Quantity) 
				* (1 - CAST([Order Details].Discount AS MONEY))) 
				+ Orders.Freight AS [Total Amount Due]
FROM		[Order Details]
	JOIN	Orders	ON	 Orders.OrderID = [Order Details].OrderID
GROUP BY	Orders.OrderID,
			Orders.OrderDate,
			Orders.Freight
ORDER BY	Orders.OrderID

--4.  Our company is located in Wilmington NC, the eastern time zone (UTC-5). We've been mostly local, but are now doing business in other time zones. Right now all of our dates in the orders table are actually our server time, and the server is located in an Amazon data center outside San Francisco, in the pacific time zone (UTC-8). For only the orders we ship to France, show the orderID, customerID, orderdate in UTC-5, and the shipped date in UTC+1 (France's time zone.) You might find the TODATETIMEOFFSET() function helpful in this regard. Remember the implied time zone (EST) when you do this.

SELECT		OrderID,
			CustomerID,
			TODATETIMEOFFSET(DateADD(hour, -8, OrderDate), '-05:00'),
			TODATETIMEOFFSET(DateADD(hour, -8, ShippedDate), '+01:00')
FROM		Orders
WHERE		ShipCountry = 'France'
ORDER BY	OrderID

--5.  We are realizing that our data is taking up more space than necessary, which is making some of our regular data become "big data", in other words, difficult to deal with. In preparation for a data migration, we'd like to convert many of the fields in the Customers table to smaller data types. We anticipate having 1 million customers, and this conversion could save us up to 58MB on just this table. Do a SELECT statement that shows all fields in the table, in their original order, and rows ordered by customerID, with these fields converted:
--    a. CustomerID converted to CHAR(5) - saves at least 5 bytes per record
--    b. PostalCode converted to VARCHAR(10) - saves up to 5 bytes per record
--    c. Phone converted to VARCHAR(24) - saves up to 24 bytes per record
--    d. Fax converted to VARCHAR(24) - saves up to 24 bytes per record

SELECT		CustomerID,
			CompanyName,
			ContactName,
			ContactTitle,
			[Address],
			City,
			Region,
			PostalCode,
			Country,
			Phone,
			Fax,
			CAST(CustomerID AS CHAR(5))			AS [Converted CustomerID],
			CAST(PostalCode AS VARCHAR(10))		AS [Converted PostalCode],	
			CAST(Phone AS VARCHAR(24))			AS [Converted Phone],
			CAST(Fax AS VARCHAR(24))			AS [Converted Fax]
FROM		Customers
ORDER BY	CustomerID
			
--6.  Show a list of products, their unit price, and their ROW_NUMBER() based on price, ASC. Order the records by productname.

SELECT		ProductName,
			ProductID,
			UnitPrice,
			ROW_NUMBER() OVER (ORDER BY UnitPrice ASC) AS [Row]
FROM		Products
ORDER BY	ProductName,
			ProductID

--7.  Do #6, but show the DENSE_RANK() based on price, ASC, rather than ROW_NUMBER().

SELECT		ProductName,
			ProductID,
			UnitPrice,
			DENSE_RANK() OVER (ORDER BY UnitPrice ASC) AS [DRank]
FROM		Products
ORDER BY	ProductName,
			ProductID

--8.  Show a list of products ranked by price into three categories based on price: 1, 2, 3. The highest 1/3 of the products will be marked with a 1, the second 1/3 as 2, the last 1/3 as 3. HINT: this is NTILE(3), order by unitprice ASC.

SELECT		ProductID,
			ProductName,
			NTILE(3) OVER (ORDER BY UnitPrice DESC) AS [Rank]
FROM		Products
ORDER BY	UnitPrice ASC

--9.  Show a list of products from categories 1, 2 7, 4 and 5. Show their RANK() based on value in inventory.

SELECT		ProductID,
			ProductName,
			Rank() OVER (ORDER BY UnitsInStock*UnitPrice ASC) AS [Rank]
FROM		Products
WHERE		CategoryID IN (1,2,7,4,5) 
ORDER BY	ProductID

--10. Show a list of orders, ranked based on freight cost, highest to lowest. Order the orders by the orderdate.

SELECT		OrderDate,
			OrderID,
			Rank() OVER (ORDER BY Freight DESC) AS [Rank based on Freight]
FROM		Orders
ORDER BY	OrderDate
