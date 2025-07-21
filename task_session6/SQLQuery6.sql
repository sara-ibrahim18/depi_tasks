USE StoreDB;
GO

DECLARE @CustomerId INT = 1;
DECLARE @TotalSpent DECIMAL(10, 2);
DECLARE @CustomerStatus VARCHAR(50);


SELECT @TotalSpent = SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount)))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = @CustomerId;


IF @TotalSpent > 5000
    SET @CustomerStatus = 'VIP Customer';
ELSE
    SET @CustomerStatus = 'Regular Customer';


PRINT 'Customer ID: ' + CAST(@CustomerId AS VARCHAR);
PRINT 'Total Amount Spent: $' + CAST(@TotalSpent AS VARCHAR);
PRINT 'Customer Status: ' + @CustomerStatus;

---------------------


DECLARE @ThresholdPrice DECIMAL(10, 2) = 1500.00;
DECLARE @ProductCount INT;


SELECT @ProductCount = COUNT(*)
FROM production.products
WHERE list_price > @ThresholdPrice;

PRINT 'Threshold Price: $' + CAST(@ThresholdPrice AS VARCHAR);
PRINT 'Number of products costing more than $' + CAST(@ThresholdPrice AS VARCHAR) + ': ' + CAST(@ProductCount AS VARCHAR);
---------------------------------------

DECLARE @StaffId INT = 2;
DECLARE @SalesYear INT = 2017;
DECLARE @TotalSales DECIMAL(10, 2);

SELECT @TotalSales = SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount)))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.staff_id = @StaffId
  AND YEAR(o.order_date) = @SalesYear;


PRINT 'Staff ID: ' + CAST(@StaffId AS VARCHAR);
PRINT 'Sales Year: ' + CAST(@SalesYear AS VARCHAR);
PRINT 'Total Sales: $' + CAST(ISNULL(@TotalSales, 0) AS VARCHAR);
-----------------------------
SELECT 
    @@SERVERNAME AS ServerName,
    @@VERSION AS SqlServerVersion,
    @@ROWCOUNT AS RowsAffected;
	------------------------------------------------------
DECLARE @ProductId INT = 1;
DECLARE @StoreId INT = 1;
DECLARE @Quantity INT;


SELECT @Quantity = quantity
FROM production.stocks
WHERE product_id = @ProductId AND store_id = @StoreId;

IF @Quantity IS NULL
    PRINT 'Product not found in this store';
ELSE
BEGIN
    
    IF @Quantity > 20
        PRINT 'Well stocked';
    ELSE IF @Quantity BETWEEN 10 AND 20
        PRINT 'Moderate stock';
    ELSE
        PRINT 'Low stock - reorder needed';
END

----------------------------------------

DECLARE @BatchSize INT = 3;
DECLARE @RowsAffected INT = 1;


WHILE @RowsAffected > 0
BEGIN
    
    UPDATE TOP (@BatchSize) production.stocks
    SET quantity = quantity + 10
    WHERE quantity < 5;

  
    SET @RowsAffected = @@ROWCOUNT;

   
    PRINT 'Updated a batch of ' + CAST(@RowsAffected AS VARCHAR) + ' low-stock items.';
END


--------------------------------------------
SELECT 
    product_id,
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Budget'
        WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
        WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
        WHEN list_price > 2000 THEN 'Luxury'
        ELSE 'Uncategorized'
    END AS price_category
FROM 
    production.products;
	---------------------------------------------
DECLARE @CustomerID INT = 5;

IF EXISTS (
    SELECT 1
    FROM sales.customers
    WHERE customer_id = @CustomerID
)
BEGIN
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        COUNT(o.order_id) AS order_count
    FROM 
        sales.customers c
        LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
    WHERE 
        c.customer_id = @CustomerID
    GROUP BY 
        c.customer_id, c.first_name, c.last_name;
END
ELSE
BEGIN
    PRINT 'Customer with ID 5 does not exist.';
END;
-----------------------------------
CREATE FUNCTION dbo.CalculateShipping (@OrderTotal DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @ShippingCost DECIMAL(10, 2);

    SET @ShippingCost = 
        CASE 
            WHEN @OrderTotal > 100 THEN 0.00
            WHEN @OrderTotal BETWEEN 50 AND 99.99 THEN 5.99
            ELSE 12.99
        END;

    RETURN @ShippingCost;
END;

---------------------------------------
CREATE FUNCTION dbo.GetProductsByPriceRange
(
    @MinPrice DECIMAL(10,2),
    @MaxPrice DECIMAL(10,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        b.brand_name,
        c.category_name
    FROM 
        production.products p
        INNER JOIN production.brands b ON p.brand_id = b.brand_id
        INNER JOIN production.categories c ON p.category_id = c.category_id
    WHERE 
        p.list_price BETWEEN @MinPrice AND @MaxPrice
);
------------------------------------------------
CREATE FUNCTION dbo.GetCustomerYearlySummary
(
    @CustomerID INT
)
RETURNS @Summary TABLE
(
    OrderYear INT,
    TotalOrders INT,
    TotalSpent DECIMAL(18, 2),
    AverageOrderValue DECIMAL(18, 2)
)
AS
BEGIN
    INSERT INTO @Summary
    SELECT 
        YEAR(o.order_date) AS OrderYear,
        COUNT(o.order_id) AS TotalOrders,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS TotalSpent,
        AVG(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS AverageOrderValue
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerID
    GROUP BY YEAR(o.order_date);

    RETURN;
END;


------------------------
CREATE FUNCTION CalculateBulkDiscount (@Quantity INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Discount DECIMAL(5,2)

    IF @Quantity BETWEEN 1 AND 2
        SET @Discount = 0.00
    ELSE IF @Quantity BETWEEN 3 AND 5
        SET @Discount = 5.00
    ELSE IF @Quantity BETWEEN 6 AND 9
        SET @Discount = 10.00
    ELSE IF @Quantity >= 10
        SET @Discount = 15.00
    ELSE
        SET @Discount = 0.00  

    RETURN @Discount
END
--------------------------------------
CREATE PROCEDURE sp_GetCustomerOrderHistory
    @CustomerID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
   -- SET NOCOUNT ON;

    SELECT 
        o.order_id,
        o.order_date,
        o.order_status,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS order_total
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerID
      AND (@StartDate IS NULL OR o.order_date >= @StartDate)
      AND (@EndDate IS NULL OR o.order_date <= @EndDate)
    GROUP BY o.order_id, o.order_date, o.order_status
    ORDER BY o.order_date;
END
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_RestockProduct
@storeID int,
@productID int,
@restockquantity int,
@OldQty INT OUTPUT,
@NewQty INT OUTPUT,
@Success BIT OUTPUT
AS
begin 
   if EXISTS(
       select 1
	   from production.stocks
	   where store_id=@storeID and product_id=@productID)
     BEGIN
	    select @OldQty=quantity
	    from production.stocks
	    where store_id=@storeID and product_id=@productID;

	  update production.stocks
	  set quantity=quantity+@restockquantity
	  where store_id=@storeID and product_id=@productID;

	  select @NewQty=quantity
	  from production.stocks
	  where store_id=@storeID and product_id=@productID;
	  SET @Success = 1;
	 END
    ELSE
    BEGIN
    
        SET @OldQty = NULL;
        SET @NewQty = NULL;
        SET @Success = 0;
    END
END;
--------------------------------------------------
CREATE PROCEDURE sp_ProcessNewOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT,
    @StoreID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;
    DECLARE @ItemID INT = 1;
    DECLARE @OrderDate DATE = GETDATE();
    DECLARE @RequiredDate DATE = DATEADD(DAY, 3, GETDATE());
    DECLARE @StaffID INT;
    DECLARE @ListPrice DECIMAL(10, 2);
    DECLARE @StockQty INT;
    DECLARE @ErrorMessage NVARCHAR(500);

    BEGIN TRY
        BEGIN TRANSACTION;

 
        SELECT @StockQty = quantity 
        FROM production.stocks 
        WHERE store_id = @StoreID AND product_id = @ProductID;

        IF @StockQty IS NULL
        BEGIN
            SET @ErrorMessage = 'The product is not available in this store''s stock.';
            THROW 51000, @ErrorMessage, 1;
        END

        IF @StockQty < @Quantity
        BEGIN
            SET @ErrorMessage = 'Insufficient stock quantity.';
            THROW 51001, @ErrorMessage, 1;
        END

       
        SELECT TOP 1 @StaffID = staff_id 
        FROM sales.staffs 
        WHERE store_id = @StoreID;

        IF @StaffID IS NULL
        BEGIN
            SET @ErrorMessage = 'No staff member assigned to this store.';
            THROW 51002, @ErrorMessage, 1;
        END

        
        INSERT INTO sales.orders (customer_id, order_status, order_date, required_date, store_id, staff_id)
        VALUES (@CustomerID, 1, @OrderDate, @RequiredDate, @StoreID, @StaffID);

        SET @OrderID = SCOPE_IDENTITY();

        
        SELECT @ListPrice = list_price 
        FROM production.products 
        WHERE product_id = @ProductID;

      
        INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (@OrderID, @ItemID, @ProductID, @Quantity, @ListPrice, 0);

       
        UPDATE production.stocks
        SET quantity = quantity - @Quantity
        WHERE store_id = @StoreID AND product_id = @ProductID;

       
        COMMIT TRANSACTION;
        PRINT 'Order created successfully.';

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
----------------------------------------------------------------------------------------
CREATE PROCEDURE sp_SearchProducts
    @ProductName NVARCHAR(100) = NULL,
    @CategoryID INT = NULL,
    @MinPrice DECIMAL(10, 2) = NULL,
    @MaxPrice DECIMAL(10, 2) = NULL,
    @SortColumn NVARCHAR(50) = 'product_name'  -- default sorting
AS
BEGIN


    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Where NVARCHAR(MAX) = 'WHERE 1=1'; 

    
    IF @ProductName IS NOT NULL
        SET @Where += ' AND product_name LIKE ''%' + @ProductName + '%''';

    IF @CategoryID IS NOT NULL
        SET @Where += ' AND category_id = ' + CAST(@CategoryID AS NVARCHAR);

    IF @MinPrice IS NOT NULL
        SET @Where += ' AND list_price >= ' + CAST(@MinPrice AS NVARCHAR);

    IF @MaxPrice IS NOT NULL
        SET @Where += ' AND list_price <= ' + CAST(@MaxPrice AS NVARCHAR);

    
    IF @SortColumn NOT IN ('product_name', 'list_price', 'product_id')
        SET @SortColumn = 'product_name';

   
    SET @SQL = '
        SELECT product_id, product_name, category_id, list_price
        FROM production.products
        ' + @Where + '
        ORDER BY ' + QUOTENAME(@SortColumn) + ';';

    
    EXEC sp_executesql @SQL;
END;
----------------------------------------------------------------------------------
CREATE PROCEDURE sp_CalculateQuarterlyBonuses
AS
BEGIN
   
    
    DECLARE @StartDate DATE = '2025-04-01';  
    DECLARE @EndDate   DATE = '2025-06-30'; 
   
    DECLARE @BonusTier1 DECIMAL(5,2) = 0.10; 
    DECLARE @BonusTier2 DECIMAL(5,2) = 0.05; 
    DECLARE @BonusTier3 DECIMAL(5,2) = 0.02; 

  
    DECLARE @BonusTable TABLE (
        staff_id INT,
        total_sales DECIMAL(18,2),
        bonus_amount DECIMAL(18,2)
    );

    
    INSERT INTO @BonusTable (staff_id, total_sales, bonus_amount)
    SELECT
        s.staff_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
        CASE 
            WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 100000 THEN 
                SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @BonusTier1
            WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 50000 THEN 
                SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @BonusTier2
            WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN 
                SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @BonusTier3
            ELSE 0
        END AS bonus_amount
    FROM sales.staffs s
    INNER JOIN sales.orders o ON s.staff_id = o.staff_id
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_date BETWEEN @StartDate AND @EndDate
    GROUP BY s.staff_id;

  
    SELECT * FROM @BonusTable;
END;

------------------------------------------------------------------------------------------------------
SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    s.quantity AS current_stock,
    
  
    CASE 
       
        WHEN s.quantity < 20 AND p.category_id = 1 THEN 100

       
        WHEN s.quantity < 30 AND p.category_id = 2 THEN 75

     
        WHEN s.quantity < 50 AND p.category_id = 3 THEN 50

    
        ELSE 0
    END AS reorder_quantity

FROM 
    production.products p
JOIN 
    production.stocks s ON p.product_id = s.product_id
	---------------------------------------------------------------
	SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    ISNULL(SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))), 0) AS total_spent,
    CASE 
        WHEN SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) IS NULL OR SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) = 0 THEN 'No Tier'
        WHEN SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) BETWEEN 1 AND 1000 THEN 'Bronze'
        WHEN SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) BETWEEN 1001 AND 5000 THEN 'Silver'
        WHEN SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) BETWEEN 5001 AND 10000 THEN 'Gold'
        WHEN SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) > 10000 THEN 'Platinum'
    END AS loyalty_tier
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.DiscontinueProduct
    @ProductId INT,
    @ReplacementProductId INT = NULL
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM sales.orders o
        INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
        WHERE oi.product_id = @ProductId
          AND o.order_status IN (1, 2) 
    )
    BEGIN
        IF @ReplacementProductId IS NOT NULL
        BEGIN
            
            UPDATE oi
            SET product_id = @ReplacementProductId
            FROM sales.orders o
            INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
            WHERE oi.product_id = @ProductId
              AND o.order_status IN (1, 2);

            PRINT ' Product replaced in pending orders.';
        END
        ELSE
        BEGIN
            PRINT ' Cannot discontinue: Product is in pending orders and no replacement provided.';
            RETURN;
        END
    END
    ELSE
    BEGIN
        PRINT ' No pending orders for the product.';
    END

  
    DELETE FROM production.stocks
    WHERE product_id = @ProductId;

    PRINT ' Inventory cleared for the product.';

    

    PRINT ' Product discontinued successfully.';
END;
-------------------------------------------------------------------------------------------

-------------------------------Bonus Challenges----------------------------------------------
WITH MonthlySales AS (
    SELECT
        DATEPART(YEAR, o.order_date) AS sales_year,
        DATEPART(MONTH, o.order_date) AS sales_month,
        s.staff_id,
        s.first_name + ' ' + s.last_name AS staff_name,
        c.category_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_sales
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
    INNER JOIN production.products p ON oi.product_id = p.product_id
    INNER JOIN production.categories c ON p.category_id = c.category_id
    WHERE o.order_status = 4  -- Completed
    GROUP BY 
        DATEPART(YEAR, o.order_date),
        DATEPART(MONTH, o.order_date),
        s.staff_id,
        s.first_name,
        s.last_name,
        c.category_name
)

SELECT
    sales_year,
    sales_month,
    staff_id,
    staff_name,
    category_name,
    total_orders,
    total_sales
FROM MonthlySales
ORDER BY sales_year, sales_month, staff_name, category_name;
-----------------------------------------------------------------
CREATE FUNCTION fn_customer_exists (@customer_id INT)
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @customer_id)
        RETURN 1;
    RETURN 0;
END;

CREATE FUNCTION fn_staff_exists (@staff_id INT)
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sales.staffs WHERE staff_id = @staff_id)
        RETURN 1;
    RETURN 0;
END;

CREATE FUNCTION fn_store_exists (@store_id INT)
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sales.stores WHERE store_id = @store_id)
        RETURN 1;
    RETURN 0;
END;

CREATE FUNCTION fn_check_inventory (
    @store_id INT,
    @product_id INT,
    @required_qty INT
)
RETURNS BIT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM production.stocks
        WHERE store_id = @store_id AND product_id = @product_id AND quantity >= @required_qty
    )
        RETURN 1;
    RETURN 0;
END;

CREATE PROCEDURE usp_insert_order
    @customer_id INT,
    @order_status TINYINT,
    @order_date DATE,
    @required_date DATE,
    @shipped_date DATE = NULL,
    @store_id INT,
    @staff_id INT,
    @product_id INT,
    @quantity INT,
    @list_price DECIMAL(10,2),
    @discount DECIMAL(4,2)
AS
BEGIN
    SET NOCOUNT ON;


    IF dbo.fn_customer_exists(@customer_id) = 0
    BEGIN
        PRINT ' Error: Customer does not exist.';
        RETURN;
    END

    
    IF dbo.fn_staff_exists(@staff_id) = 0
    BEGIN
        PRINT ' Error: Staff does not exist.';
        RETURN;
    END

    
    IF dbo.fn_store_exists(@store_id) = 0
    BEGIN
        PRINT ' Error: Store does not exist.';
        RETURN;
    END

    
    IF dbo.fn_check_inventory(@store_id, @product_id, @quantity) = 0
    BEGIN
        PRINT ' Error: Not enough stock for the product.';
        RETURN;
    END

    
    DECLARE @order_id INT;

    INSERT INTO sales.orders (
        customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id
    ) VALUES (
        @customer_id, @order_status, @order_date, @required_date, @shipped_date, @store_id, @staff_id
    );

    SET @order_id = SCOPE_IDENTITY();

   
    INSERT INTO sales.order_items (
        order_id, item_id, product_id, quantity, list_price, discount
    ) VALUES (
        @order_id, 1, @product_id, @quantity, @list_price, @discount
    );

   
    UPDATE production.stocks
    SET quantity = quantity - @quantity
    WHERE store_id = @store_id AND product_id = @product_id;

    PRINT ' Order inserted successfully with ID = ' + CAST(@order_id AS VARCHAR);
END;




