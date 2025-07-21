CREATE NONCLUSTERED INDEX idx_customers_email
ON sales.customers (email);

----------------------
CREATE NONCLUSTERED INDEX IX_Products_Category_Brand
ON production.products (category_id, brand_id);
-----------------------
CREATE NONCLUSTERED INDEX idx_orders_order_date
ON sales.orders (order_date)
INCLUDE (customer_id, store_id, order_status);
-----------------------------------------
CREATE TABLE sales.customer_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    log_message NVARCHAR(255),
    log_date DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_after_customer_insert
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log (customer_id, log_message)
    SELECT 
        i.customer_id,
        'Welcome, new customer with ID ' + CAST(i.customer_id AS NVARCHAR)
    FROM inserted i;
END;
----------------------------------------------------------
CREATE TABLE production.price_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10,2) NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    change_date DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES production.products(product_id)
);
CREATE TRIGGER trg_LogPriceChange
ON production.products
AFTER UPDATE
AS
BEGIN
    INSERT INTO production.price_history (product_id, old_price, new_price, change_date)
    SELECT
        i.product_id,
        d.list_price AS old_price,
        i.list_price AS new_price,
        GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.product_id = d.product_id
    WHERE i.list_price <> d.list_price;
END;
-------------------------
CREATE TRIGGER trg_PreventCategoryDelete
ON production.categories
INSTEAD OF DELETE
AS
BEGIN
  
    IF EXISTS (
        SELECT 1
        FROM production.products p
        INNER JOIN deleted d ON p.category_id = d.category_id
    )
    BEGIN
        RAISERROR('Cannot delete category: there are products associated with this category.', 16, 1);
        RETURN;
    END

   
    DELETE FROM production.categories
    WHERE category_id IN (SELECT category_id FROM deleted);
END;
-----------------------------------------
CREATE TRIGGER trg_reduce_stock_after_order
ON sales.order_items
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET s.quantity = s.quantity - i.quantity
    FROM production.stocks s
    INNER JOIN inserted i ON s.product_id = i.product_id
    INNER JOIN sales.orders o ON i.order_id = o.order_id
    WHERE s.store_id = o.store_id;
END;
-----------------------------------------------------------------------
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_log_new_orders
ON sales.orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO sales.order_audit (
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date,
        audit_timestamp
    )
    SELECT 
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date,
        GETDATE() 
    FROM inserted;
END;



