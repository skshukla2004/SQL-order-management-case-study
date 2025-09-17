

--1. List all customers
select * from customer_Day4
 
--2. List the first name, last name, and city of all customers 
 select firstname ,lastname,city from customer_Day4
--3. List the customers in Sweden. Remember it is "Sweden" and NOT "sweden" because filtering 
--value is case sensitive in Redshift.
select*from customer_Day4
where country='Sweden'

--4. Create a copy of Supplier table. Update the city to Sydney for supplier starting
--with letter P.
select * into supplier_Day4_copy from Supplier_Day4
select * from supplier_day4_copy where ContactName ='p%'
update supplier_day4_copy set city ='Sydney' where ContactName ='p%'
drop  table supplier_day4_copy


 
--5. Create a copy of Products table and Delete all products with unit price higher than $50. 
select * into product_day4_copy  from product_day4
 
--6. List the number of customers in each country 
SELECT COUNTRY , COUNT( ID) AS NO_PERSON FROM Customer_Day4
GROUP BY COUNTRY

 
--7. List the number of customers in each country sorted high to low 
SELECT COUNTRY , COUNT( ID) AS NO_PERSON FROM Customer_Day4
GROUP BY COUNTRY
ORDER BY NO_PERSON DESC





--8. List the total amount for items ordered by each customer (i can give the output in customer id or customer 
SELECT concat(firstname ,LastName)as cust_name,SUM(TotalAmount) AS TOT_AMT FROM Orders_Day4 o
join customer_Day4 as c on c.id=o.id
group by concat(firstname ,LastName)--complete question

 
--9. List the number of customers in each country. Only include countries with more than 10
--customers.
select Country , count (id) customer_count from Customer_Day4
group by  Country 
having count(id)>10

 
--10. List the number of customers in each country, except the USA, sorted high to low. Only 
--include countries with 9 or more customers. 
select Country , count (id) customer_count
from Customer_Day4
where country <> 'USA'
group by  Country 
having count(id)>8
ORDER BY count (id) DESC


 
--11. List all customers whose first name or last name contains "ill". 
SELECT * FROM Customer_Day4
 WHERE FIRSTNAME LIKE '%ILL%' OR LASTNAME LIKE '%ILL%'


--12. List all customers whose average of their total order amount is between $1000 and 
--$1200.Limit your output to 5 results.

SELECT TOP 5 customerId,AVG(TotalAmount) AS AVG_AMT 
FROM  Orders_Day4
group by customerId
having AVG(TotalAmount) between 1000 and 1200
order by AVG_AMT DESC

select*from OrderItem_Day4

 
--13. List all suppliers in the 'USA', 'Japan', and 'Germany', ordered by country from A-Z, and then 
--by company name in reverse order.
select * from Supplier_Day4
where country in( 'USA', 'Japan', 'Germany')
order by country asc ,companyname desc
 
--14. Show all orders, sorted by total amount (the largest amount first), within each year. 
select   Datepart (year , OrderDate)  as years, id, TotalAmount
from Orders_Day4 
order by Datepart (year , OrderDate) asc, TotalAmount desc
 
--15. Products with UnitPrice greater than 50 are not selling despite promotions. You are asked to 
--discontinue products over $25. Write a query to relfelct this. Do this in the copy of the Product 
--table. DO NOT perform the update operation in the Product table.

 
--16. List top 10 most expensive products.
SELECT  top 1 UnitPrice from Product_Day4 
order by UnitPrice desc

 
--17. Get all but the 10 most expensive products sorted by price 
SELECT  top 1 totalamount from OrderItem_Day4 as o
join Product_Day4 as p
order by totalamount desc

 
--18. Get the 10th to 15th most expensive products sorted by price 
SELECT  * from Product_Day4 
order by UnitPrice desc
offset 9 row
fetch next 6 rows only
 
--19. Write a query to get the number of supplier countries. Do not count duplicate values.
select distinct country from Supplier_Day4

--20. Find the total sales cost in each month of the year 2013. 
select  datepart(month , orderdate),sum(Totalamount) sales from 
Orders_Day4 
where  datepart(year,OrderDate) =2013
group by  datepart(month , orderdate)
 
--21. List all products with names that start with 'Ca'. 
 select  * from Product_Day4
  where productname like 'Ca%'
--22.list all product that start with 'cha' or 'chan' and have one more character.
select * from Product_Day4
where productname like 'Cha_%' or ProductName  like 'chan_%'

--23. List all orders, their orderDates with product names, quantities, and prices. 
 select O.Orderdate,P.Productname,Quantity,O.TotalAmount from Orders_Day4 as O
 join OrderItem_Day4 as OI  ON O.ID = OI.Id
 JOIN Product_Day4 AS P ON P.Id=O.Id
 GROUP BY O.Orderdate,P.Productname,Quantity,O.TotalAmount
--24. List all customers who have not placed any Orders.
SELECT CONCAT(FIRSTNAME,LASTNAME) AS CUST_NAME FROM Customer_Day4 AS C
LEFT JOIN Orders_Day4 AS O ON C.Id=O.CustomerId
WHERE OrderNumber IS NULL

 
--25. List suppliers that have no customers in their country, and customers that have no suppliers 
--in their country, and customers and suppliers that are from the same country.  
  select firstname , lastname ,c.country  as customer_country ,s.country as supplier_country , s.companyname 
  from Customer_Day4 c
  left join  Supplier_Day4 as s  on c.country= s.country
  where s.CompanyName is null
  union all
  select s.firstname , s.lastname ,c.country  as customer_country ,s.country as supplier_country , s.companyname 
  from Supplier_Day4 s 
  left join Customer_Day4 as c  on c.country= s.country
  where c.id  is null
  union all
  select firstname , lastname ,c.country  as customer_country ,s.country as supplier_country , s.companyname from Supplier_Day4 
  inner join Customer_Day4 as c on c.country = s.country 


--- 26. Match customers that are from the same city and country. That is you are asked to give a list
--of customers that are from same country and city. Display firstname, lastname, city and
--coutntry of such customers.
--Hint See sample output for your reference.

--- same city and country --- cutomers
--- First name & last name, city and country

select A.FirstName Firstname1,A.LastName LastName1, B.FirstName FirstName2,B.LastName LastName2,
A.City,A.Country
from Customer1 A
inner join Customer1 B on A.Country=B.Country and A.City=B.City
where A.FirstName <> B.FirstName and A.LastName<> B.LastName
order by country,city
--- 

/*--- 27. List all Suppliers and Customers. Give a Label in a separate column as 'Suppliers' if he is a
supplier and 'Customer' if he is a customer accordingly. Also, do not display firstname and
lastname as twoi fields; Display Full name of customer or supplier.
Hint: See sample output for your reference.*/

--list of supplier and customer 
-- create a column where you will assign the label as customer or supplier - column name - Type
--- concat the customer (first and Last Name) ,City, Country Phone
-- 1ST WAY
select 'Customer' as [Type],CONCAT(Firstname, ' ', LastName) ContactName,City,Country,Phone from Customer1
UNION
select 'Supplier' as [Type],CompanyName as ContactName,City,Country,Phone from Supplier1

-- 2ND WAY
select CASE WHEN ContactName IN (SELECT COMPANYNAME AS CONTACTNAME FROM Supplier1) THEN 'SUPPLIER'
ELSE 'CUSTOMER' END AS [TYPE],*
from (
select CONCAT(Firstname, ' ', LastName) ContactName,City,Country,Phone from Customer1
UNION
select CompanyName as ContactName,City,Country,Phone from Supplier1) AS TEMP_TABLE


--28. Create a copy of orders table. In this copy table, now add a column city of type varchar (40).
--Update this city column using the city info in customers table.

SELECT * INTO ORDER_COPY
FROM Orders1

ALTER TABLE ORDER_COPY
ADD CITY VARCHAR(40)

SELECT * FROM Customer1

SELECT * FROM ORDER_COPY

UPDATE ORDER_COPY SET CITY = (SELECT CITY FROM Customer1 WHERE ORDER_COPY.CustomerId=Customer1.Id)



/*---29. Suppose a company would like to do some targeted marketing where it would contact
customers in the country with the fewest number of orders. It is hoped that this targeted
marketing will increase the overall sales in the targeted country. You are asked to write a query
to get all details of such customers from top 5 countries with fewest numbers of orders. Use
Subqueries.

1. top 5 countries with fewest numbers of orders.
2. all details of such customers 
3. Use Subqueries.*/

SELECT * FROM Customer1
WHERE COUNTRY IN (
					SELECT COUNTRY FROM (
											SELECT TOP 5 COUNTRY , COUNT(O.ID) ORDER_COUNT FROM Orders1 O
											LEFT JOIN  Customer1 C ON C.Id=O.CustomerId
											GROUP BY Country
											ORDER BY ORDER_COUNT ASC) AS X
											) 



/*30. Let's say you want report of all distinct "OrderIDs" where the customer did not purchase
more than 10% of the average quantity sold for a given product. This way you could review
these orders, and possibly contact the customers, to help determine if there was a reason for
the low quantity order. Write a query to report such orderIDs.

distinct "OrderIDs"
CONDITION = customer did not purchase more than 10% of the average quantity sold for a given product

*/

select DISTINCT OrderId from OrderItem1 O
inner join 
(SELECT ProductId , AVG(Quantity) AVG_QTY
FROM ORDERITEM1
GROUP BY ProductId) X on x.ProductId=O.ProductId
WHERE  O.Quantity < 0.1 * AVG_QTY


/*31. Find Customers whose total orderitem amount is greater than 7500$ for the year 2013. The
total order item amount for 1 order for a customer is calculated using the formula UnitPrice *
Quantity * (1 - Discount). DO NOT consider the total amount column from 'Order' table to
calculate the total orderItem for a customer.

1.Find Customers whose total orderitem amount is greater than 7500$
2.year 2013
3.TOTAL AMT = unitPrice *Quantity * (1 - Discount)
*/


SELECT CONCAT(FIRSTNAME,' ', LastName) CUSTOMER_NAME FROM Customer1
WHERE ID IN 
(
SELECT CUSTOMERID AS ID
FROM (
SELECT CUSTOMERID,ORDERID, SUM(UNITPRICE * QUANTITY* (1 - Discount)) AS TOTAL_AMT 
FROM OrderItem I
INNER JOIN Orders1 O ON I.ORDERID=O.ID
WHERE YEAR(OrderDate)=2013
GROUP BY ORDERID,CUSTOMERID
HAVING SUM(UNITPRICE * QUANTITY* (1 - Discount)) >7500) X)


/*
32. Write a store procedure that performs the following action:
Check if Product_copy table (this is a copy of Product table) is present. If table exists, the
procedure should drop this table first and recreated.
Add a column Supplier_name in this copy table. Update this column with that of
'CompanyName' column from Supplier tab

1.Check if Product_copy table (this is a copy of Product table) is present
2.If table exists, the procedure should drop this table first and recreated.
3.Add a column Supplier_name in this copy table. Update this column with that of
'CompanyName' column from Supplier tab

*/
;
CREATE PROCEDURE
				test
				AS
						IF 'PRODUCT_COPY' IN ( SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES)
				BEGIN
						DROP TABLE PRODUCT_COPY
						SELECT P.*,S.CompanyName AS SUPPLIER_NAME INTO PRODUCT_COPY_1
						FROM Product1 P
						LEFT JOIN Supplier1 S ON P.SupplierId=S.Id
				END

					EXEC test

--Table Name

SELECT * FROM Customer_Day4
select * from Orders_Day4
select * from OrderItem_Day4
select * from product_Day4
select * from Supplier_Day4

