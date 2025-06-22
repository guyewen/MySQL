/*
Task 1: Use the ALTER TABLE statement with MODIFY command to make the OrderID the primary key of the 'FoodOrders' table. 

Task 2: Apply the NOT NULL constraint to the quantity and cost columns.

Task 3: Create two new columns, OrderDate with a DATE datatype and CustomerID with an INT datatype. Declare both must as NOT NULL. Declare the CustomerID as a foreign key in the FoodOrders table to reference the CustomerID column existing in the Customers table.

Task 4: Use the DROP command with ALTER statement to delete the OrderDate column from the 'FoodOrder' table. 

Task 5: Use the CHANGE command with ALTER statement to rename the column Order_Status in the OrderStatus table to DeliveryStatus. 

Task 6: Use the RENAME command with ALTER statement to change the table name from OrderStatus to OrderDeliveryStatus.
*/

CREATE DATABASE IF NOT EXISTS little_lemon; 
USE little_lemon;
CREATE TABLE FoodOrders (OrderID INT, Quantity INT, Order_Status VARCHAR(15), Cost Decimal(4,2));
SHOW COLUMNS FROM FoodOrders;

CREATE TABLE Customers (CustomerID INT PRIMARY KEY, FullName VARCHAR(100), PhoneNumber INT NOT NULL UNIQUE);

-- Task 1
ALTER TABLE FoodOrders
MODIFY COLUMN OrderID INT PRIMARY KEY;
SHOW COLUMNS FROM FoodOrders;

-- Task 2
ALTER TABLE FoodOrders
MODIFY COLUMN Quantity INT NOT NULL, MODIFY COLUMN Cost Decimal(4,2) NOT NULL;
SHOW COLUMNS FROM FoodOrders;

-- Task 3
ALTER TABLE FoodOrders
ADD COLUMN OrderDate DATE NOT NULL, 
ADD COLUMN CustomerID INT NOT NULL, 
ADD FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID);
SHOW COLUMNS FROM FoodOrders;

-- Task 4
ALTER TABLE FoodOrders
DROP COLUMN OrderDate;
SHOW COLUMNS FROM FoodOrders;

-- Task 5
ALTER TABLE FoodOrders
CHANGE COLUMN Order_Status DeliveryStatus VARCHAR(15);
SHOW COLUMNS FROM FoodOrders;

-- Task 6
ALTER TABLE FoodOrders
RENAME TO OrderDeliveryStatus;
SHOW COLUMNS FROM OrderDeliveryStatus;