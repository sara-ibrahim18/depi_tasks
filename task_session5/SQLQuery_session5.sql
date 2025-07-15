
SELECT 
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Economy'
        WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
        WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
        WHEN list_price >= 2500 THEN 'Luxury'
    END AS price_category
FROM 
    production.products
ORDER BY 
    list_price;
	-----------------


SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.required_date,
    o.shipped_date,
    CASE 
        WHEN o.order_status = 1 THEN 'Order Received'
        WHEN o.order_status = 2 THEN 'In Preparation'
        WHEN o.order_status = 3 THEN 'Order Cancelled'
        WHEN o.order_status = 4 THEN 'Order Delivered'
        ELSE 'Unknown Status'
    END AS status_description,

   
    CASE 
        WHEN o.order_status = 1 AND DATEDIFF(DAY, o.order_date, GETDATE()) > 5 THEN 'URGENT'
        WHEN o.order_status = 2 AND DATEDIFF(DAY, o.order_date, GETDATE()) > 3 THEN 'HIGH'
        ELSE 'NORMAL'
    END AS priority_level

FROM 
    sales.orders o
ORDER BY 
    priority_level DESC, o.order_date;
	-------
	
SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(o.order_id) AS order_count,

    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
    END AS staff_level

FROM 
    sales.staffs s
LEFT JOIN 
    sales.orders o ON s.staff_id = o.staff_id

GROUP BY 
    s.staff_id,
    s.first_name,
    s.last_name

ORDER BY 
    order_count DESC;

	-----------------------------------
	
SELECT 
    customer_id,
    first_name,
    last_name,
    ISNULL(phone, 'Phone Not Available') AS phone,
    email,
    city,
    state,
   
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact
FROM 
    sales.customers;
	-----------------
	
SELECT 
    p.product_name,
    s.quantity,
    p.list_price,

    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit,
    CASE 
        WHEN s.quantity = 0 THEN 'Out of Stock'
        WHEN s.quantity BETWEEN 1 AND 20 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status

FROM 
    production.stocks s
JOIN 
    production.products p ON s.product_id = p.product_id

WHERE 
    s.store_id = 1;
	---------------------------

SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    email,

    COALESCE(street, '') AS street,
    COALESCE(city, '') AS city,
    COALESCE(state, '') AS state,
    COALESCE(zip_code, '') AS zip_code,

    COALESCE(street, '') + 
    CASE WHEN city IS NOT NULL THEN ', ' + city ELSE '' END +
    CASE WHEN state IS NOT NULL THEN ', ' + state ELSE '' END +
    CASE WHEN zip_code IS NOT NULL THEN ' - ' + zip_code ELSE '' END AS formatted_address

FROM 
    sales.customers;
	----------------

WITH CustomerSpending AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_spent
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        o.customer_id
)

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    c.email,
    cs.total_spent
FROM 
    CustomerSpending cs
JOIN 
    sales.customers c ON cs.customer_id = c.customer_id
WHERE 
    cs.total_spent > 1500
ORDER BY 
    cs.total_spent DESC;
	-----------
	
WITH CategoryRevenue AS (
    SELECT 
        c.category_id,
        c.category_name,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_revenue
    FROM 
        sales.order_items oi
    JOIN 
        production.products p ON oi.product_id = p.product_id
    JOIN 
        production.categories c ON p.category_id = c.category_id
    GROUP BY 
        c.category_id, c.category_name
),


CategoryAvgOrderValue AS (
    SELECT 
        c.category_id,
        AVG(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS avg_order_value
    FROM 
        sales.order_items oi
    JOIN 
        production.products p ON oi.product_id = p.product_id
    JOIN 
        production.categories c ON p.category_id = c.category_id
    GROUP BY 
        c.category_id
)


SELECT 
    cr.category_id,
    cr.category_name,
    cr.total_revenue,
    ao.avg_order_value,


    CASE 
        WHEN cr.total_revenue > 50000 THEN 'Excellent'
        WHEN cr.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_rating

FROM 
    CategoryRevenue cr
JOIN 
    CategoryAvgOrderValue ao ON cr.category_id = ao.category_id
ORDER BY 
    cr.total_revenue DESC;


	---------------------

	
WITH MonthlySales AS (
    SELECT 
        FORMAT(o.order_date, 'yyyy-MM') AS sales_month,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_sales
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        FORMAT(o.order_date, 'yyyy-MM')
),


MonthlySalesWithComparison AS (
    SELECT 
        sales_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales
    FROM 
        MonthlySales
)


SELECT 
    sales_month,
    total_sales,
    previous_month_sales,
    
    
    CASE 
        WHEN previous_month_sales IS NULL THEN NULL
        WHEN previous_month_sales = 0 THEN NULL
        ELSE ROUND(((total_sales - previous_month_sales) / previous_month_sales) * 100, 2)
    END AS growth_percentage

FROM 
    MonthlySalesWithComparison
ORDER BY 
    sales_month;

	---------------
	

WITH CustomerSpending AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_spent
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        o.customer_id
),

RankedCustomers AS (
    SELECT 
        cs.customer_id,
        c.first_name + ' ' + c.last_name AS full_name,
        cs.total_spent,
        
        
        RANK() OVER (ORDER BY cs.total_spent DESC) AS customer_rank,

     
        NTILE(5) OVER (ORDER BY cs.total_spent DESC) AS spending_group
    FROM 
        CustomerSpending cs
    JOIN 
        sales.customers c ON cs.customer_id = c.customer_id
)


SELECT 
    customer_id,
    full_name,
    total_spent,
    customer_rank,
    spending_group,

    CASE 
        WHEN spending_group = 1 THEN 'VIP'
        WHEN spending_group = 2 THEN 'Gold'
        WHEN spending_group = 3 THEN 'Silver'
        WHEN spending_group = 4 THEN 'Bronze'
        ELSE 'Standard'
    END AS tier

FROM 
    RankedCustomers
ORDER BY 
    customer_rank;

	--------------
	

WITH StorePerformance AS (
    SELECT 
        s.store_id,
        s.store_name,
        s.city,
  
        SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) AS total_revenue,

        
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM 
        sales.stores s
    LEFT JOIN 
        sales.orders o ON s.store_id = o.store_id
    LEFT JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        s.store_id, s.store_name, s.city
),

RankedStores AS (
    SELECT 
        store_id,
        store_name,
        city,
        total_revenue,
        total_orders,

        
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,

        
        RANK() OVER (ORDER BY total_orders DESC) AS orders_rank,

       
        PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_percentile
    FROM 
        StorePerformance
)


SELECT 
    store_id,
    store_name,
    city,
    total_revenue,
    total_orders,
    revenue_rank,
    orders_rank,
    ROUND(revenue_percentile * 100, 2) AS revenue_percentile_percent
FROM 
    RankedStores
ORDER BY 
    revenue_rank;

	-------------
	
SELECT *
FROM (
    SELECT 
        c.category_name,
        b.brand_name
    FROM 
        production.products p
    JOIN 
        production.categories c ON p.category_id = c.category_id
    JOIN 
        production.brands b ON p.brand_id = b.brand_id
    WHERE 
        b.brand_name IN ('Electra', 'Haro', 'Trek', 'Surly')
) AS source_table

PIVOT (
    COUNT(brand_name)
    FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS pivot_table;
-----------------

SELECT 
    store_name,
    ISNULL([January], 0) + ISNULL([February], 0) + ISNULL([March], 0) +
    ISNULL([April], 0) + ISNULL([May], 0) + ISNULL([June], 0) +
    ISNULL([July], 0) + ISNULL([August], 0) + ISNULL([September], 0) +
    ISNULL([October], 0) + ISNULL([November], 0) + ISNULL([December], 0) 
    AS Total_Revenue,
    ISNULL([January], 0) AS Jan,
    ISNULL([February], 0) AS Feb,
    ISNULL([March], 0) AS Mar,
    ISNULL([April], 0) AS Apr,
    ISNULL([May], 0) AS May,
    ISNULL([June], 0) AS Jun,
    ISNULL([July], 0) AS Jul,
    ISNULL([August], 0) AS Aug,
    ISNULL([September], 0) AS Sep,
    ISNULL([October], 0) AS Oct,
    ISNULL([November], 0) AS Nov,
    ISNULL([December], 0) AS Dec
FROM (
    SELECT 
        s.store_name,
        DATENAME(MONTH, o.order_date) AS sales_month,
        oi.quantity * (oi.list_price - (oi.list_price * oi.discount)) AS revenue
    FROM 
        sales.orders o
    JOIN 
        sales.stores s ON o.store_id = s.store_id
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
) AS SourceTable

PIVOT (
    SUM(revenue)
    FOR sales_month IN (
        [January], [February], [March], [April], [May], [June],
        [July], [August], [September], [October], [November], [December]
    )
) AS PivotTable

ORDER BY Total_Revenue DESC;

-----------------------------

SELECT 
    store_name,
    ISNULL([Pending], 0) AS Pending,
    ISNULL([Processing], 0) AS Processing,
    ISNULL([Completed], 0) AS Completed,
    ISNULL([Rejected], 0) AS Rejected
FROM (
    SELECT 
        s.store_name,
   
        CASE o.order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Completed'
        END AS status
    FROM 
        sales.orders o
    JOIN 
        sales.stores s ON o.store_id = s.store_id
) AS SourceTable

PIVOT (
    COUNT(status)
    FOR status IN ([Pending], [Processing], [Completed], [Rejected])
) AS PivotTable

ORDER BY store_name;
------------------

WITH BrandSales AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        oi.quantity * (oi.list_price - (oi.list_price * oi.discount)) AS revenue
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    JOIN 
        production.products p ON oi.product_id = p.product_id
    JOIN 
        production.brands b ON p.brand_id = b.brand_id
    WHERE 
        YEAR(o.order_date) IN (2016, 2017, 2018)
),

PivotTable AS (
    SELECT 
        brand_name,
        ISNULL([2016], 0) AS Revenue_2016,
        ISNULL([2017], 0) AS Revenue_2017,
        ISNULL([2018], 0) AS Revenue_2018
    FROM 
        BrandSales
    PIVOT (
        SUM(revenue)
        FOR sales_year IN ([2016], [2017], [2018])
    ) AS Pivoted
)


SELECT 
    brand_name,
    Revenue_2016,
    Revenue_2017,
    Revenue_2018,

  
    ROUND(
        (Revenue_2017 - Revenue_2016) * 100.0 / NULLIF(Revenue_2016, 0),
        2
    ) AS Growth_2017_vs_2016_Percent,


    ROUND(
        (Revenue_2018 - Revenue_2017) * 100.0 / NULLIF(Revenue_2017, 0),
        2
    ) AS Growth_2018_vs_2017_Percent

FROM 
    PivotTable
ORDER BY 
    brand_name;

	--------------
	
SELECT 
    p.product_id,
    p.product_name,
    'In Stock' AS availability_status
FROM 
    production.products p
JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    s.quantity > 0

UNION ALL


SELECT 
    p.product_id,
    p.product_name,
    'Out of Stock' AS availability_status
FROM 
    production.products p
JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    ISNULL(s.quantity, 0) = 0

UNION ALL


SELECT 
    p.product_id,
    p.product_name,
    'Discontinued' AS availability_status
FROM 
    production.products p
LEFT JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    s.product_id IS NULL;
	-----------------------------

SELECT DISTINCT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2017

INTERSECT

SELECT DISTINCT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2018;

------------------

SELECT 
    product_id,
    'Available in All Stores' AS status
FROM 
    production.stocks
WHERE 
    store_id = 1

INTERSECT

SELECT 
    product_id,
    'Available in All Stores' AS status
FROM 
    production.stocks
WHERE 
    store_id = 2

INTERSECT

SELECT 
    product_id,
    'Available in All Stores' AS status
FROM 
    production.stocks
WHERE 
    store_id = 3


UNION

SELECT 
    product_id,
    'Only in Store 1' AS status
FROM 
    production.stocks
WHERE 
    store_id = 1

EXCEPT

SELECT 
    product_id,
    'Only in Store 1' AS status
FROM 
    production.stocks
WHERE 
    store_id = 2
	----------------------------------
	WITH CategorizedCustomers AS (
    -- Retained
    SELECT customer_id, 'Retained Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2016
    INTERSECT
    SELECT customer_id, 'Retained Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2017

    UNION ALL

    -- Lost
    SELECT customer_id, 'Lost Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2016
    EXCEPT
    SELECT customer_id, 'Lost Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2017

    UNION ALL

    -- New
    SELECT customer_id, 'New Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2017
    EXCEPT
    SELECT customer_id, 'New Customer' AS status
    FROM sales.orders
    WHERE YEAR(order_date) = 2016
)

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    cc.status
FROM 
    CategorizedCustomers cc
JOIN 
    sales.customers c ON cc.customer_id = c.customer_id
ORDER BY 
    cc.status, full_name;
	