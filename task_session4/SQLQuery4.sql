use StoreDB;
select count(*)
from production.products;
--
select 
    MIN(list_price),
	MAX(list_price),
	AVG(list_price)
from production.products
--
select count(product_id)as num_of_products,category_name
from production.products p
left join production.categories c on p.category_id= c.category_id
group by category_name
--
select COUNT(order_id) as count_orders ,store_name
from sales.orders o
left join sales.stores s on s.store_id=o.store_id
group by store_name

--
select  UPPER(first_name),UPPER (last_name)
from sales.customers
order by customer_id
OFFSET 0 ROWS fetch next 10 rows only;


 select   product_name,LEN(product_name)
 from production.products
 order by product_id
 offset 0 rows fetch next 10 rows only;

 select top 15 LEFT(phone,3) area_code
 from sales.customers

 --
 select top 10 getdate () as currentdate,year(order_date) as year_date ,month(order_date)as month_date
 from sales.orders

 select c.category_name,product_name
 from production.categories c
 join production.products p
 on c.category_id= p.category_id
 order by p.product_id
 OFFSET 0 ROWS fetch next 10 rows only;

 SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM 
    sales.orders o
JOIN 
    sales.customers c ON o.customer_id = c.customer_id
ORDER BY 
    o.order_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
--


SELECT 
    p.product_name,
    ISNULL(b.brand_name, 'No Brand') AS brand_name
FROM 
    production.products p
LEFT JOIN 
    production.brands b ON p.brand_id = b.brand_id;

	--
SELECT product_name, list_price
FROM production.products
WHERE list_price > (
  SELECT AVG(list_price) FROM production.products
);
--
SELECT 
    customer_id,
    first_name + ' ' + last_name AS customer_name
FROM 
    sales.customers
WHERE 
    customer_id IN (
        SELECT DISTINCT customer_id 
        FROM sales.orders
        WHERE customer_id IS NOT NULL
    );
	------
	SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    (
        SELECT COUNT(*) 
        FROM sales.orders o 
        WHERE o.customer_id = c.customer_id
    ) AS total_orders
   FROM 
    sales.customers c;

	--
	

CREATE VIEW easy_product_list AS
SELECT 
    p.product_name,
    c.category_name,
    p.list_price
FROM 
    production.products p
JOIN 
    production.categories c ON p.category_id = c.category_id;

SELECT *
FROM easy_product_list
WHERE list_price > 100;
---
CREATE VIEW customer_info AS
SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    email,
    city + ', ' + state AS location
FROM 
    sales.customers;

SELECT *
FROM customer_info
WHERE location LIKE '%, CA';

SELECT 
    product_name,
    list_price
FROM 
    production.products
WHERE 
    list_price BETWEEN 50 AND 200
ORDER BY 
    list_price ASC;

select state ,count (state) customer_count
from sales.customers
group by state
ORDER BY 
customer_count DESC;


SELECT 
    c.category_name,
    p.product_name,
    p.list_price
FROM 
    production.products p
JOIN 
    production.categories c ON p.category_id = c.category_id
WHERE 
    p.list_price = (
        SELECT MAX(p2.list_price)
        FROM production.products p2
        WHERE p2.category_id = p.category_id
    )
ORDER BY 
    c.category_name;
	
