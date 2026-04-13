USE magist;
/*1.What categories of tech products does Magist have?*/

SELECT DISTINCT 
       t.product_category_name_english,
       COUNT(*) AS num_of_products
FROM products p
JOIN product_category_name_translation t
 ON  p.product_category_name = t.product_category_name
 WHERE t.product_category_name_english IN('audio', 
        'electronics', 
        'computers_accessories', 
        'pc_gamer', 
        'computers', 
        'telephony'
    )
       GROUP BY t.product_category_name_english
       ORDER BY num_of_products DESC;
       
       
       #order count by category
SELECT COUNT(products.product_id) as count, product_category_name as cat
FROM orders
LEFT JOIN order_items on orders.order_id = order_items.order_id
LEFT JOIN products on order_items.product_id = products.product_id
GROUP BY cat ORDER BY count DESC;

#before filtering, explore:

SELECT DISTINCT 
 t.product_category_name_english
 FROM product_category_name_translation t
 ORDER BY 1;

/*2.How many products of these tech categories have been sold (within the time window of the database snapshot)? 
What percentage does that represent from the overall number of products sold?*/

SELECT 
    COUNT(oi.product_id) AS tech_products_sold,
    ROUND(COUNT(oi.product_id) * 100.0 / (SELECT COUNT(*) FROM order_items), 2) AS percentage_of_total
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE 
    t.product_category_name_english IN (
        'audio', 
        'electronics', 
        'computers_accessories', 
        'pc_gamer', 
        'computers', 
        'tablets_printing_image',
        'telephony'
    );
 
 #How many products of these tech categories have been sold (within the time window of the database snapshot)? 

SELECT COUNT(DISTINCT(oi.product_id)) AS tech_products_sold
FROM order_items oi
LEFT JOIN products p 
	USING (product_id)
LEFT JOIN product_category_name_translation t
	USING (product_category_name)
WHERE product_category_name_english = "audio"
OR product_category_name_english =  "electronics"
OR product_category_name_english =  "computers_accessories"
OR product_category_name_english =  "pc_gamer"
OR product_category_name_english =  "computers"
OR product_category_name_english =  "tablets_printing_image"
OR product_category_name_english =  "telephony";

# What percentage does that represent from the overall number of products sold?

SELECT COUNT(DISTINCT(product_id)) AS products_sold
FROM order_items;
	SELECT ROUND(3390*100.0/32951);
 
 /* 3.What’s the average price of the products being sold?*/
  
SELECT 
    ROUND(AVG(price),2) AS average_price_all
FROM 
    order_items;
    
 /*------same average price but separating by year*/   
    SELECT 
    purchased_year,
    ROUND(AVG(price), 2) AS avg_catalog_price
FROM (
    SELECT DISTINCT 
        product_id, 
        price, 
        CASE 
            WHEN YEAR(o.order_purchase_timestamp) = 2018 THEN "2018"
            WHEN YEAR(o.order_purchase_timestamp) = 2017 THEN "2017"
            ELSE "2016"
        END AS purchased_year
    FROM order_items oi
    JOIN orders o USING (order_id) -- The "bridge" to get the dates
) AS unique_product_sold
GROUP BY purchased_year
ORDER BY purchased_year DESC;

/*4.Are expensive tech products popular? */
SELECT COUNT(oi.product_id),
       CASE
           WHEN price > 1000 THEN "Expensive"
           WHEN price > 100 THEN "Mid_range"
           ELSE "Cheap"
       END AS "Price_range"
FROM order_items oi
LEFT JOIN products p
                ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t
	USING (product_category_name)
WHERE t.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range
ORDER BY 1 DESC;



