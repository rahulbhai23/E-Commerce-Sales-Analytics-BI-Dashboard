
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(gross_sales), 2) AS gross_revenue,
    ROUND(SUM(discount_amount), 2) AS total_discount,
    ROUND(SUM(net_sales), 2) AS net_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(profit) / NULLIF(SUM(net_sales), 0), 2
    ) AS profit_margin_pct,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2
    ) AS average_order_value
FROM fact_order_items;

2. Monthly Sales Trend

SELECT
    d.year,
    d.month_number,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.net_sales), 2) AS net_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit
FROM fact_order_items f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month_number, d.month_name
ORDER BY d.year, d.month_number;

3. Product Category Performance

SELECT
    p.product_category,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.net_sales), 2) AS net_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(f.profit) / NULLIF(SUM(f.net_sales), 0), 2
    ) AS profit_margin_pct
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY net_revenue DESC;

4. Sales Channel Performance

SELECT
    o.sales_channel,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(i.net_sales), 2) AS net_revenue,
    ROUND(SUM(i.profit), 2) AS total_profit,
    ROUND(
        SUM(i.net_sales) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS average_order_value
FROM fact_orders o
JOIN fact_order_items i ON o.order_id = i.order_id
GROUP BY o.sales_channel
ORDER BY net_revenue DESC;

5. Customer Segment Analysis

SELECT
    c.customer_segment,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(i.net_sales), 2) AS net_revenue,
    ROUND(SUM(i.profit), 2) AS total_profit
FROM fact_orders o
JOIN dim_customer c ON o.customer_id = c.customer_id
JOIN fact_order_items i ON o.order_id = i.order_id
GROUP BY c.customer_segment
ORDER BY net_revenue DESC;

6. Repeat Customer Rate

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM fact_orders
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS repeat_customer_rate_pct
FROM customer_orders;

7. Return Rate

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN return_status = 'Returned' THEN order_id
    END) AS returned_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN return_status = 'Returned' THEN order_id
        END) / NULLIF(COUNT(DISTINCT order_id), 0), 2
    ) AS return_rate_pct
FROM fact_orders;

8. Delivery Performance

SELECT
    COUNT(*) AS orders_with_delivery_data,
    ROUND(AVG(delivery_days), 2) AS average_delivery_days,
    SUM(CASE
        WHEN delivery_days > estimated_delivery_days THEN 1
        ELSE 0
    END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN delivery_days > estimated_delivery_days THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS late_delivery_rate_pct
FROM fact_orders
WHERE delivery_days IS NOT NULL
  AND estimated_delivery_days IS NOT NULL;

9. Top 10 Products by Revenue

SELECT
    p.product_id,
    p.product_name,
    p.product_category,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.net_sales), 2) AS net_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.product_category
ORDER BY net_revenue DESC
LIMIT 10;

10. Marketing Channel Performance

SELECT
    o.marketing_channel,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(i.net_sales), 2) AS net_revenue,
    ROUND(SUM(i.profit), 2) AS total_profit
FROM fact_orders o
JOIN fact_order_items i ON o.order_id = i.order_id
GROUP BY o.marketing_channel
ORDER BY net_revenue DESC;

11. Customer Ratings and Sentiment

SELECT
    review_sentiment,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(customer_rating), 2) AS average_rating
FROM fact_orders
WHERE customer_rating IS NOT NULL
GROUP BY review_sentiment
ORDER BY reviewed_orders DESC;

12. Payment Failure Rate

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN payment_status = 'Failed' THEN order_id
    END) AS failed_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN payment_status = 'Failed' THEN order_id
        END) / NULLIF(COUNT(DISTINCT order_id), 0), 2
    ) AS payment_failure_rate_pct
FROM fact_orders
GROUP BY payment_method
ORDER BY total_orders DESC;