-- Import Data

--Data uploaded by Flat Import

select * from data;

ALTER TABLE data alter column Order_Date datetime;

-- Remove Null Values

 delete from Data where COALESCE (Order_ID, Product, Quantity_Ordered, Price_Each, Order_Date, Purchase_Address) is null

 -- Change the price of the product into dollars and analyze the data accordingly.

begin transaction

update data set Price_Each=concat('$ ', Price_Each);

select*from data
rollback

--Identify Primary Key

select * from SYS.objects where type_desc='PRIMARY_KEY_CONSTRAINT'

ALTER TABLE data add primary key (Order_ID) ;

ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

--Make new columns named as total sales per person

BEGIN TRANSACTION TOTAL_SALES
select *, convert(money,Price_Each )*Quantity_Ordered as Total_Sales from data

COMMIT;

-- Create a Transaction to separate city column from the purchase address column.

BEGIN TRANSACTION CITY;
SELECT*,PARSENAME(REPLACE((Purchase_Address), ',', '.'),2) AS City FROM DATA 
COMMIT;

select * from DATA


-- Create a Transaction to Day,Month,Year column from the purchase Order Date column.

BEGIN TRANSACTION CITY
SELECT*, YEAR(ORDER_DATE) AS YEAR, MONTH(ORDER_DATE) AS MONTH, DAY(ORDER_DATE) AS DAY From DATA
COMMIT;

-- Create a procedure to find top sold Products.

CREATE PROCEDURE TOP_SALE
AS
BEGIN
SELECT SUM(QUANTITY_ORDERED) AS 'Top Sale', PRODUCT FROM DATA
GROUP BY PRODUCT
ORDER BY SUM(QUANTITY_ORDERED) DESC

END;

EXEC TOP_SALE;

DROP PROCEDURE TOP_SALE

-- Create a procedure to find Total Unique Products.

CREATE PROCEDURE UNIQUE_PRODUCTS
AS
BEGIN
SELECT DISTINCT COUNT(Product) 'Unique PRODUCT', Product FROM DATA
GROUP BY PRODUCT
ORDER BY COUNT(PRODUCT) DESC
END;

EXEC UNIQUE_PRODUCTS

--Create a Procedure to find the top cities with the highest sales in descending order.

CREATE PROCEDURE Most_Sale_By_City
AS
BEGIN
SELECT TOP(20) CITY, SUM(Quantity_Ordered) as Sum_Of_Quantity_Ordered
FROM (SELECT*,PARSENAME(REPLACE((Purchase_Address), ',', '.'),2) AS City FROM DATA) as abc
GROUP BY city
ORDER BY Sum_Of_Quantity_Ordered DESC;
END;

EXEC Most_Sale_By_City

drop procedure Most_Sale_By_City


































SELECT SUM(QUANTITY_ORDERED) 'Top Sale', PRODUCT FROM DATA
GROUP BY PRODUCT
ORDER BY SUM(QUANTITY_ORDERED) DESC

CREATE PROCEDURE UNIQUE_PRODUCTS
AS
BEGIN
SELECT DISTINCT COUNT(Product) 'Unique PRODUCT', Product FROM DATA
GROUP BY PRODUCT
ORDER BY COUNT(PRODUCT) DESC
END;

EXEC UNIQUE_PRODUCTS

select * from SYS.objects where type_desc='PRIMARY_KEY_CONSTRAINT'

select * from data group by city