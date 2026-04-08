CREATE DATABASE AVANCED;
USE AVANCED;


CREATE TABLE Products (
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(100), 
    Category VARCHAR(50), 
    Price DECIMAL(10,2) 
);
SELECT * FROM PRODUCTS;

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200), 
(2, 'Mouse', 'Electronics', 800), 
(3, 'Chair', 'Furniture', 2500), 
(4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT, 
    Quantity INT, 
    SaleDate DATE, 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'), 
(2, 2, 10, '2024-01-06'), 
(3, 3, 2, '2024-01-10'), 
(4, 4, 1, '2024-01-11');




-- Q6. Write a CTE to calculate the total revenue for each product
-- (Revenues = Price × Quantity), and return only products where  revenue > 3000.

WITH ProductRevenue AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        (p.Price * s.Quantity) AS Revenue
    FROM Products p
    JOIN Sales s 
    ON p.ProductID = s.ProductID
)

SELECT 
    ProductID,
    ProductName,
    Revenue
FROM ProductRevenue
WHERE Revenue > 3000;


-- Q7.  Create a view named VW_CATEGORYSUMMARY that shows:
-- Category, TotalProducts, AveragePrice.


CREATE VIEW vw_CategorySummary AS
SELECT 
Category,
COUNT(*) AS TotalProducts,
AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

  
 --  Q8. Create an updatable view containing ProductID, ProductName, and Price 
 --  Then update the price of ProductID = 1 using the view.
  
  
CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;

UPDATE vw_ProductDetails
SET Price = 55000
WHERE ProductID = 1;

-- Q9. Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT 
        ProductID,
        ProductName,
        Category,
        Price
    FROM Products
    WHERE Category = cat_name;
END //

DELIMITER ;
CALL GetProductsByCategory('Electronics');




-- Q10.Create an AFTER DELETE trigger on the PRODUCTS table that archives deleted product rows into a new table PRODUCTARCHEIVE  The archive should store ProductID, ProductName, Category, Price, and DeletedAttimestamp.


CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price INT,
    DeletedAt DATETIME
);

DELIMITER //
CREATE TRIGGER after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END //
DELIMITER ;
