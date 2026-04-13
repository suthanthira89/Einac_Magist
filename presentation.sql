USE magist;

SELECT 
    t.product_category_name_english,
    COUNT(oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    -- This CASE statement helps you create the "Tech" highlight directly in the data
    CASE 
        WHEN t.product_category_name_english IN ('audio','electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
        THEN 'Tech'
        ELSE 'Non-Tech'
    END AS product_type
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
JOIN product_category_name_translation t 
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english, product_type
ORDER BY total_orders DESC;