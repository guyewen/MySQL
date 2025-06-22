/*
Task 1:  Create the Staff table with the following PRIMARY KEY and NOT NULL constraints:
Staff ID should be INT, NOT NULL and PRIMARY KEY
PhoneNumber should be INT, NOT NULL and UNIQUE 
FullName: VARCHAR(100) NOT NULL.


Task 2: Create the 'ContractInfo' table with the following key and domain constraints:
Contract ID should be INT, NOT NULL and PRIMARY KEY
StaffID should be INT, NOT NULL. 
Salary should be DECIMAL (7,2), NOT NULL.
Location should be VARCHAR (50) NOT NULL with DEFAULT = "Texas". 
StaffType should be VARCHAR (20) NOT NULL and should accept a "Junior" or a "Senior" value.


Task 3: Create a foreign key that links the Staff table with the ContractInfo table. In this example, you need to apply the referential integrity rule as follows:
Link each member of staff in the Staff table to a specific contract in the Contract Info table. 
Each staff ID existing in the 'Contract Info' table is expected to exist as well in the Staff table. 
The staff ID in the 'Contract Info' table should be defined as a foreign key to reference the Staff ID in the Staff table.
*/
CREATE DATABASE IF NOT EXISTS Mangata_Gallo;
USE Mangata_Gallo;

-- Task 1
CREATE TABLE Staff (
Staff_ID INT NOT NULL PRIMARY KEY,
PhoneNumber INT NOT NULL UNIQUE,
FullName VARCHAR(100) NOT NULL
);

SHOW COLUMNS FROM Staff;

-- Task 2
CREATE TABLE ContractInfo (
Contract_ID INT NOT NULL PRIMARY KEY,
Staff_ID INT NOT NULL,
Salary DECIMAL (7,2) NOT NULL,
Location  VARCHAR (50) NOT NULL DEFAULT 'Texas',
StaffType VARCHAR (20) NOT NULL CHECK(StaffType = 'Junior' OR StaffType = 'Senior')
);

SHOW COLUMNS FROM ContractInfo;

-- Task 3
ALTER TABLE ContractInfo 
ADD CONSTRAINT FK_Staff_ID_ContractInfo
FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE;

SHOW COLUMNS FROM ContractInfo;

-- Other exercises
-- Create tables with different constraints
/*
CREATE TABLE Clients (ClientID INT NOT NULL PRIMARY KEY, FullName  VARCHAR(100) NOT NULL, PhoneNumber INT NOT NULL UNIQUE);
CREATE TABLE Items (ItemID INT PRIMARY KEY, ItemName VARCHAR(100) NOT NULL, Price DECIMAL(5,2) NOT NULL);
CREATE TABLE Orders 
(
OrderID INT NOT NULL PRIMARY KEY,
ClientID INT NOT NULL,
ItemID INT NOT NULL,
Quantity INT NOT NULL CHECK(Quantity <= 3),
Cost DECIMAL(6,2) NOT NULL,
FOREIGN KEY(ClientID) REFERENCES Clients (ClientID),
FOREIGN KEY(ItemID) REFERENCES Items (ItemID)
);
*/

