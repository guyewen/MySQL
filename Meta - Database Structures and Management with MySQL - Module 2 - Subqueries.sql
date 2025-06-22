CREATE DATABASE littlelemon_db;
USE littlelemon_db;

CREATE TABLE MenuItems (
  ItemID int NOT NULL,
  Name varchar(200) DEFAULT NULL,
  Type varchar(100) DEFAULT NULL,
  Price int DEFAULT NULL,
  PRIMARY KEY (ItemID)
);

INSERT INTO MenuItems VALUES
(1,'Olives','Starters',5),
(2,'Flatbread','Starters',5),
(3,'Minestrone','Starters',8),
(4,'Tomato bread','Starters',8),
(5,'Falafel','Starters',7),
(6,'Hummus','Starters',5),
(7,'Greek salad','Main Courses',15),
(8,'Bean soup','Main Courses',12),
(9,'Pizza','Main Courses',15),
(10,'Greek yoghurt','Desserts',7),
(11,'Ice cream','Desserts',6),
(12,'Cheesecake','Desserts',4),
(13,'Athens White wine','Drinks',25),
(14,'Corfu Red Wine','Drinks',30),
(15,'Turkish Coffee','Drinks',10),
(16,'Turkish Coffee','Drinks',10),
(17,'Kabasa','Main Courses',17);

CREATE TABLE LowCostMenuItems
(ItemID INT, Name VARCHAR(200), Price INT, PRIMARY KEY(ItemID));

-- Task 1: Find the minimum and the maximum average prices at which the customers can purchase food and drinks.
SELECT ROUND(MIN(avg_price),2), ROUND(MAX(avg_price),2) 
FROM 
(
SELECT `Type`, AVG(Price) as avg_price
FROM menuitems
GROUP BY `Type` ORDER BY avg_price
) AS avg_prices;

-- Other ways way
WITH avg_prices AS
(
SELECT `Type`, AVG(Price) as avg_price
FROM menuitems
GROUP BY `Type` ORDER BY avg_price
),
min_max AS (
  SELECT MIN(avg_price) AS min_price, MAX(avg_price) AS max_price
  FROM avg_prices
)
SELECT `Type`, avg_price
FROM avg_prices, min_max
WHERE avg_prices.avg_price = min_max.min_price OR avg_prices.avg_price = min_max.max_price
;

WITH avg_prices AS (
  SELECT `Type`, AVG(Price) AS avg_price
  FROM menuitems
  GROUP BY `Type`
)
SELECT *
FROM avg_prices
WHERE avg_price = (SELECT MIN(avg_price) FROM avg_prices)
   OR avg_price = (SELECT MAX(avg_price) FROM avg_prices);

-- Task 2 Insert data of menu items with a minimum price based on the 'Type' into the LowCostMenuItems table.
INSERT lowcostmenuitems
SELECT ItemID, Name, Price
FROM
(
WITH cheap_food AS
(
SELECT `Type`, MIN(price) as min_price
FROM menuitems
GROUP by `Type`
)
SELECT menuitems.*
FROM menuitems, cheap_food
WHERE menuitems.`Type` = cheap_food.`Type` AND menuitems.price = cheap_food.min_price
) AS cheap;

SELECT *
FROM lowcostmenuitems;

-- Task 3 Delete all the low-cost menu items whose price is more than the minimum price of menu items that have a price between $5 and $10.
DELETE FROM LowCostMenuItems 
WHERE Price > ALL(SELECT MIN(Price) as p 
FROM menuitems 
GROUP BY Type 
HAVING p BETWEEN 5 AND 10);


