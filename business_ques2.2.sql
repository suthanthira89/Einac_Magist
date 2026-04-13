USE magist;

/*How many months of data are included in the magist database?*/
select timestampdiff
             (month, min(order_purchase_timestamp),
                max(order_purchase_timestamp)) as total_months
 from orders;
 
/* How many sellers are there? How many Tech sellers are there? 
What percentage of overall sellers are Tech sellers?*/

/* How many sellers are there?*/
SELECT COUNT(*) FROM sellers;

/*How many Tech sellers are there?*/
SELECT COUNT(DISTINCT seller_id)
FROM sellers
LEFT JOIN order_items oi USING(seller_id)
LEFT JOIN products p USING(product_id)
LEFT JOIN product_category_name_translation t USING(product_category_name)
WHERE
    t.product_category_name_english IN ('audio','electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
        
   /*What percentage of overall sellers are Tech sellers? */   
   
   SELECT ROUND((454/3095) *100,2);
   
  /* What is the total amount earned by all sellers?*/
  
  SELECT ROUND(SUM(oi.price),2) AS total
  FROM order_items oi
  LEFT JOIN orders o USING(order_id)
  WHERE 
       o.order_status NOT IN ("unavailable" , "canceled");
       
/*What is the total amount earned by all Tech sellers?*/

  SELECT ROUND(SUM(oi.price),2) AS total
  FROM order_items oi
  LEFT JOIN orders o USING(order_id)
  LEFT JOIN products p USING(product_id)
  LEFT JOIN product_category_name_translation t USING(product_category_name)
  WHERE 
       o.order_status NOT IN ("unavailable" , "canceled") 
	AND t.product_category_name_english IN ('audio','electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
        
/*Can you work out the average monthly income of all sellers?*/

SELECT ROUND(13494400.74/3095/25,2) AS avg_month_income_all;

/* Can you work out the average monthly income of Tech sellers?*/
SELECT ROUND(1666211.28 / 454 / 25,2) AS avg_month_income_tech;
