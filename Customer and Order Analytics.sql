/* #This SQL project involves querying a database with multiple tables to extract various 
statistics related to customer behavior, sales patterns, and product performance */

--#1. How many orders were placed in January?
SELECT COALESCE(COUNT(orderid), 0) AS num_orders
FROM BIT_DB.JanSales
WHERE length(orderid) = 6
AND orderid <> 'Order ID';

--#2. How many of those orders were for an iPhone?
SELECT COALESCE(COUNT(orderid), 0) AS num_orders
FROM BIT_DB.JanSales
WHERE Product='iPhone'
AND length(orderid) = 6
AND orderid <> 'Order ID';

--#3. Select the customer account numbers for all the orders that were placed in February.
SELECT distinct acctnum
FROM BIT_DB.customers cust
INNER JOIN BIT_DB.FebSales Feb
ON cust.order_id=FEB.orderid
WHERE length(orderid) = 6
AND orderid <> 'Order ID';

--#4. Which product was the cheapest one sold in January, and what was the price?
SELECT distinct Product, price
FROM BIT_DB.JanSales
WHERE price IN (SELECT min(price) FROM BIT_DB.JanSales);

--#5. What is the total revenue for each product sold in January?
SELECT sum(quantity)*price as revenue
,product
FROM BIT_DB.JanSales
GROUP BY product;

--#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?
SELECT
SUM(Quantity),
product,
SUM(Quantity)*price as revenue
FROM BIT_DB.FebSales
WHERE location = '548 Lincoln St, Seattle, WA 98101'
GROUP BY product;

--#7. How many customers ordered more than 2 products at a time, and what was the average amount spent for those customers?
SELECT
COALESCE(COUNT(distinct cust.acctnum), 0) as num_customers,
AVG(quantity*price) as avg_spent
FROM BIT_DB.FebSales Feb
LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id
WHERE Feb.Quantity>2
AND length(orderid) = 6
AND orderid <> 'Order ID'

--#8. List all the products sold in Los Angeles in February, and include how many of each were sold.
SELECT Product, SUM(quantity)
FROM BIT_DB.FebSales
WHERE location like '%Los Angeles%'
GROUP BY Product

--#9. Which locations in New York received at least 3 orders in January, and how many orders did they each receive?
SELECT DISTINCT location, COALESCE(COUNT(orderID), 0) AS num_orders
FROM BIT_DB.JanSales
GROUP BY location
HAVING location LIKE '%New York%'
AND COUNT(orderID) >=3
AND length(orderid) = 6
AND orderid <> 'Order ID';

--#10. How many of each type of headphone were sold in February?
SELECT DISTINCT Product, SUM(Quantity)
FROM BIT_DB.FebSales
WHERE Product LIKE '%headphones%'
GROUP BY Product;

--#11. What was the average amount spent per account in February?
SELECT COALESCE(SUM(price*Quantity)/COUNT(acctnum), 0) as avg_spent
FROM BIT_DB.FebSales feb
LEFT JOIN customers cust
ON feb.orderID=cust.order_id
WHERE length(orderid) = 6
AND orderid <> 'Order ID';

--#12. What was the average quantity of products purchased per account in February?

SELECT SUM(Quantity)/COALESCE(COUNT(DISTINCT acctnum), 1)
FROM BIT_DB.FebSales feb
LEFT JOIN customers cust
ON feb.orderID=cust.order_id
WHERE length(orderid) = 6
AND orderid <> 'Order ID';

--#13.Which product brought in the most revenue in January and how much revenue did it bring in total?

SELECT Product, Sum(Quantity*price) AS total_rev
FROM BIT_DB.JanSales
GROUP BY Product
ORDER BY SUM(Quantity*price) DESC
LIMIT 1;