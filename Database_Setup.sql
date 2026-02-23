CREATE DATABASE inventory;
GRANT ALL PRIVILEGES ON inventory.* to 'analytics'@'localhost';
FLUSH PRIVILEGES ;
GRANT FILE ON *.* TO 'analytics'@'localhost';
FLUSH PRIVILEGES;

USE inventory;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/begin_inventory.csv' 
INTO TABLE begin_inventory 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


SELECT * FROM begin_inventory LIMIT 10;

TRUNCATE TABLE begin_inventory;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/begin_inventory.csv' 
INTO TABLE begin_inventory 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT COUNT(*) FROM begin_inventory;

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    InventoryId VARCHAR(255),
    Store INT,
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    SalesQuantity INT,
    SalesDollars DECIMAL(15, 2),
    SalesPrice DECIMAL(15, 2),
    SalesDate VARCHAR(50), 
    Volume DECIMAL(15, 2),
    Classification INT,
    ExciseTax DECIMAL(15, 2),
    VendorNo INT,
    VendorName VARCHAR(255)
);

-- 3. The 1.5GB Import
-- Make sure the filename below is exactly what you have in the /Uploads/ folder
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv' 
INTO TABLE sales 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

CREATE TABLE purchases (
    InventoryId VARCHAR(255),
    Store INT,
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    VendorNumber INT,
    VendorName VARCHAR(255),
    PONumber INT,
    PODate VARCHAR(50),        -- Safe import as text
    ReceivingDate VARCHAR(50), -- Safe import as text
    InvoiceDate VARCHAR(50),   -- Safe import as text
    PayDate VARCHAR(50),       -- Safe import as text
    PurchasePrice DECIMAL(15, 2),
    Quantity INT,
    Dollars DECIMAL(15, 2),
    Classification INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/purchases.csv' 
INTO TABLE purchases 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

CREATE TABLE purchase_price (
    Brand INT,
    Description VARCHAR(255),
    Price DECIMAL(15, 2),        -- The 12.99 in your data row
    Size VARCHAR(50),
    Volume VARCHAR(50),          -- Keeping this as VARCHAR in case of units like '750' or '1L'
    Classification INT,
    PurchasePrice DECIMAL(15, 2), -- The 9.28 in your data row
    VendorNumber INT,
    VendorName VARCHAR(255)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/purchase_prices.csv' 
INTO TABLE purchase_price 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

CREATE TABLE end_inventory (
    InventoryId VARCHAR(255),
    Store INT,
    City VARCHAR(255),
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    onHand INT,
    Price DECIMAL(15, 2),
    endDate VARCHAR(50)  -- Importing as VARCHAR first for safety
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/end_inventory.csv' 
INTO TABLE end_inventory 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

CREATE TABLE vendor_invoice (
    VendorNumber INT,
    VendorName VARCHAR(255),
    InvoiceDate VARCHAR(50), -- Safe import
    PONumber INT,
    PODate VARCHAR(50),      -- Safe import
    PayDate VARCHAR(50),     -- Safe import
    Quantity INT,
    Dollars DECIMAL(15, 2),
    Freight DECIMAL(15, 2),
    Approval VARCHAR(50)     -- To catch "Approved" or empty values
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vendor_invoice.csv' 
INTO TABLE vendor_invoice 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;


SHOW TABLES;

SELECT VendorName, Dollars, Freight, InvoiceDate FROM vendor_invoice LIMIT 10;




SET SQL_SAFE_UPDATES = 0;
SET sql_mode = '';

-- 2. This runs your date fix
UPDATE sales 
SET SalesDate = STR_TO_DATE(SalesDate, '%Y-%m-%d') 
WHERE SalesDate IS NOT NULL AND SalesDate != '';

-- 2. Fix Purchases (4 date columns)
UPDATE purchases SET PODate = STR_TO_DATE(PODate, '%Y-%m-%d');
UPDATE purchases SET ReceivingDate = STR_TO_DATE(ReceivingDate, '%Y-%m-%d');
UPDATE purchases SET InvoiceDate = STR_TO_DATE(InvoiceDate, '%Y-%m-%d');
UPDATE purchases SET PayDate = STR_TO_DATE(PayDate, '%Y-%m-%d');

-- 3. Fix End Inventory
UPDATE end_inventory SET endDate = STR_TO_DATE(endDate, '%Y-%m-%d');

-- 4. Fix Vendor Invoices
UPDATE vendor_invoice SET InvoiceDate = STR_TO_DATE(InvoiceDate, '%Y-%m-%d');
UPDATE vendor_invoice SET PODate = STR_TO_DATE(PODate, '%Y-%m-%d');
UPDATE vendor_invoice SET PayDate = STR_TO_DATE(PayDate, '%Y-%m-%d');

-- 5. Relock
SET SQL_SAFE_UPDATES = 1;


ALTER TABLE sales MODIFY SalesDate DATE;
ALTER TABLE purchases MODIFY PODate DATE, MODIFY ReceivingDate DATE, MODIFY InvoiceDate DATE, MODIFY PayDate DATE;
ALTER TABLE end_inventory MODIFY endDate DATE;
ALTER TABLE vendor_invoice MODIFY InvoiceDate DATE, MODIFY PODate DATE, MODIFY PayDate DATE;