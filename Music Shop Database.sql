/* The following SQL queries analyze data from various tables within the Music Shop database
and aim to answer questions related to customer behavior, sales patterns, and employee performance.*/

--Show Customers (their full names, customer ID, and country) who are not in the US. 

SELECT FirstName, LastName, CustomerId, Country
FROM chinook.customers
WHERE Country <> "USA";

--Show only the Customers from Brazil.

SELECT * FROM chinook.customers 
WHERE Country = "Brazil" ;


/*Find the Invoices of customers who are from Brazil. 
The resulting table should show the customer's full name, 
Invoice ID, Date of the invoice, and billing country.*/

SELECT FirstName, LastName, InvoiceId, InvoiceDate, BillingCountry
FROM chinook.customers c
JOIN chinook.invoices i 
ON c.CustomerId = i.CustomerId
WHERE Country = "Brazil";

--Show the Employees who are Sales Agents.

SELECT * FROM chinook.Employees
WHERE Title = "Sales Support Agent" ;

--Find a unique/distinct list of billing countries from the Invoice table.

SELECT DISTINCT BillingCountry
FROM chinook.invoices;

/*Provide a query that shows the invoices associated with each sales agent. 
The resulting table should include the Sales Agent's full name.*/

SELECT emp.LastName, emp.Firstname, inv.InvoiceId
FROM chinook.Employees emp 
JOIN chinook.Customers cust ON cust.SupportRepId = emp.EmployeeId
JOIN chinook.Invoices Inv ON Inv.CustomerId = cust.CustomerId;

/*Show the Invoice Total, Customer name, Country, and Sales Agent name
 for all invoices and customers.*/
 
SELECT i.Total AS Invoice_total, c.FirstName, c.LastName, c.Country, 
e.FirstName AS employee_first_name,
e.LastName AS employee_last_name
FROM chinook.employees e 
JOIN chinook.customers c 
ON c.SupportRepId = e.EmployeeId
JOIN chinook.invoices i 
ON i.CustomerId = c.CustomerId;
 
 /*How many Invoices were there in 2009?*/
 
SELECT COUNT(Total)
FROM chinook.invoices
WHERE InvoiceDate LIKE "2009%";

/*What are the total sales for 2009?*/

SELECT SUM(Total)
FROM chinook.invoices
WHERE InvoiceDate LIKE "2009%";

/*Write a query that includes the purchased track name with each invoice line ID.*/

SELECT t.Name, i.InvoiceLineId
FROM chinook.tracks t
JOIN chinook.invoice_items i
ON t.TrackId = i.TrackId;

/*Write a query that includes the purchased track name AND artist name with each invoice line ID.*/

SELECT t.Name AS Track ,ar.Name AS Artist, i.InvoiceLineId
FROM chinook.tracks t
LEFT JOIN chinook.invoice_items i
ON t.TrackId = i.TrackId
INNER JOIN chinook.albums a
ON t.AlbumId = a.AlbumId
LEFT JOIN chinook.artists ar
ON a.ArtistId = ar.ArtistId;

/*Provide a query that shows all the Tracks, and include the Album name, Media type, and Genre.*/

SELECT t.Name AS Track , a.Title AS Album, m.Name AS Media_type, g.Name AS Genre
FROM chinook.tracks t 

INNER JOIN chinook.albums a 
ON a.AlbumId = t.AlbumId

INNER JOIN chinook.media_types m
ON t.MediaTypeId = m.MediaTypeId

INNER JOIN chinook.genres g
ON t.GenreId = g.GenreId;

/*Show the total sales made by each sales agent.*/

SELECT e.FirstName, e.LastName, ROUND(SUM(i.Total), 2) AS 'Total Sales'
FROM chinook.employees e
JOIN chinook.customers c
ON c.SupportRepId = e.EmployeeId
JOIN chinook.invoices i 
ON c.CustomerId = i.CustomerId
WHERE Title LIKE "%Sales%"
GROUP BY e.FirstName, e.LastName;

/*Which sales agent made the most dollars in sales in 2009?*/

SELECT e.FirstName, e.LastName, (ROUND(SUM(i.Total), 2)) AS 'TotalSales'
FROM chinook.employees e
JOIN chinook.customers c
ON c.SupportRepId = e.EmployeeId

JOIN chinook.invoices i 
ON c.CustomerId = i.CustomerId

WHERE Title LIKE "%Sales%"
AND InvoiceDate LIKE "%2009%"

GROUP BY e.FirstName, e.LastName
ORDER BY TotalSales DESC
LIMIT 1;