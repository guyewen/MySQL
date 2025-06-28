/*
Task 1: Use the MySQL CEIL function to express the cost after the discount in the form of the smallest integer as follows:

Give a 5% discount to the clients who have ordered luxury watches. 
Express the cost after the discount in the form of the smallest integer, which is not less than the value shown in the afterDiscount column in the result table given below. 
Use the MySQL CEIL function to do this.
*/
SELECT *, CEIL(afterDiscount) roundedPrice
FROM
(
SELECT ClientID, OrderID, (Cost -(Cost * 5 /100)) As afterDiscount FROM client_orders WHERE ItemID = 4
) AS discount_price;

-- Task 2: Format the afterDiscount column value from the earlier result for 5% discount in '#,###,###.##' format rounded to 2 decimal places using the FORMAT function.
SELECT *, FORMAT(afterDiscount, 2) formatPrice
FROM
(
SELECT ClientID, OrderID, (Cost -(Cost * 5 /100)) As afterDiscount FROM client_orders WHERE ItemID = 4
) AS discount_price;

-- Task 3: Find the expected delivery dates for their orders. The scheduled delivery date is 30 days after the order date. Use the ADDDATE function.
SELECT *, ADDDATE(OrderDate, INTERVAL 30 DAY) Expected_Delivery
FROM mg_orders;

/*
Task 4: Generate data required for a report with details of all orders that have not yet been delivered. 
The DeliveryDate column has a NULL value for orders not yet delivered. 
It would help if you showed a value of 'NOT DELIVERED' instead of showing NULL for orders that are not yet delivered. Use the COALESCE function to do this.
*/
SELECT OrderID, ItemID, Quantity, Cost, OrderDate, COALESCE (DeliveryDate,'NOT DELIVERED') DeliveryDate, OrderStatus 
FROM mg_orders;

-- Task 5: Generate data required for the report by retrieving a list of M&G orders yet to be delivered. These orders have an 'In Progress' status using the NULLIF function.
SELECT *
FROM mg_orders
WHERE NULLIF(OrderStatus, 'In Progress') IS NULL;



