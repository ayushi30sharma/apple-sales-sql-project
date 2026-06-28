SELECT
    country,
    COUNT(*) AS total_stores
FROM stores
GROUP BY country
ORDER BY total_stores DESC;

SELECT
    COUNT(*) AS stores_without_warranty_claim
FROM stores st
WHERE NOT EXISTS (
    SELECT 1
    FROM sales s
    JOIN warranty w
        ON w.sale_id = s.sale_id
    WHERE s.store_id = st.store_id
);

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE repair_status = 'Warranty Void')
        / COUNT(*),
        2
    ) AS warranty_void_percentage
FROM warranty;

SELECT
    st.store_id,
    st.store_name,
    st.city,
    st.country,
    SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN stores st
    ON st.store_id = s.store_id
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY
    st.store_id,
    st.store_name,
    st.city,
    st.country
ORDER BY total_units_sold DESC
LIMIT 1;

SELECT
    COUNT(DISTINCT product_id) AS unique_products_sold
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '1 year';

WITH daily_store_sales AS (
    SELECT
        st.store_id,
        st.store_name,
        s.sale_date,
        SUM(s.quantity) AS total_quantity_sold
    FROM sales s
    JOIN stores st
        ON st.store_id = s.store_id
    GROUP BY
        st.store_id,
        st.store_name,
        s.sale_date
),
ranked_days AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY store_id
            ORDER BY total_quantity_sold DESC
        ) AS day_rank
    FROM daily_store_sales
)
SELECT
    store_id,
    store_name,
    sale_date AS best_selling_day,
    total_quantity_sold
FROM ranked_days
WHERE day_rank = 1
ORDER BY store_id;

SELECT
    TO_CHAR(DATE_TRUNC('month', s.sale_date), 'YYYY-MM') AS sales_month,
    SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN stores st
    ON st.store_id = s.store_id
WHERE st.country = 'USA'
  AND s.sale_date >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY DATE_TRUNC('month', s.sale_date)
HAVING SUM(s.quantity) > 5000
ORDER BY sales_month;

SELECT
    c.category_id,
    c.category_name,
    COUNT(w.claim_id) AS total_warranty_claims
FROM warranty w
JOIN sales s
    ON s.sale_id = w.sale_id
JOIN products p
    ON p.product_id = s.product_id
JOIN category c
    ON c.category_id = p.category_id
WHERE w.claim_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_warranty_claims DESC
LIMIT 1;


SELECT
    st.country,
    COUNT(DISTINCT s.sale_id) AS total_purchases,
    COUNT(DISTINCT w.claim_id) AS total_warranty_claims,
    ROUND(
        100.0 * COUNT(DISTINCT w.claim_id)
        / COUNT(DISTINCT s.sale_id),
        2
    ) AS warranty_claim_percentage
FROM sales s
JOIN stores st
    ON st.store_id = s.store_id
LEFT JOIN warranty w
    ON w.sale_id = s.sale_id
GROUP BY st.country
ORDER BY warranty_claim_percentage DESC;


WITH yearly_sales AS (
    SELECT
        st.store_id,
        st.store_name,
        EXTRACT(YEAR FROM s.sale_date) AS sales_year,
        SUM(s.quantity) AS total_units_sold
    FROM sales s
    JOIN stores st
        ON st.store_id = s.store_id
    GROUP BY
        st.store_id,
        st.store_name,
        EXTRACT(YEAR FROM s.sale_date)
),
growth AS (
    SELECT
        *,
        LAG(total_units_sold) OVER (
            PARTITION BY store_id
            ORDER BY sales_year
        ) AS previous_year_units
    FROM yearly_sales
)
SELECT
    store_id,
    store_name,
    sales_year,
    total_units_sold,
    previous_year_units,
    ROUND(
        total_units_sold::numeric / NULLIF(previous_year_units, 0),
        2
    ) AS growth_ratio,
    ROUND(
        100.0 * (total_units_sold - previous_year_units)
        / NULLIF(previous_year_units, 0),
        2
    ) AS growth_percentage
FROM growth
ORDER BY store_id, sales_year;


WITH product_sales_claims AS (
    SELECT
        p.product_id,
        p.product_name,
        p.price,
        CASE
            WHEN p.price < 500 THEN 'Below 500'
            WHEN p.price BETWEEN 500 AND 999.99 THEN '500-999'
            WHEN p.price BETWEEN 1000 AND 1499.99 THEN '1000-1499'
            ELSE '1500 and above'
        END AS price_range,
        COUNT(DISTINCT s.sale_id) AS total_sales,
        COUNT(DISTINCT w.claim_id) AS total_claims
    FROM products p
    JOIN sales s
        ON s.product_id = p.product_id
    LEFT JOIN warranty w
        ON w.sale_id = s.sale_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '5 years'
    GROUP BY
        p.product_id,
        p.product_name,
        p.price
)
SELECT
    price_range,
    COUNT(*) AS total_products,
    ROUND(AVG(price)::numeric, 2) AS avg_price,
    SUM(total_sales) AS total_sales,
    SUM(total_claims) AS total_warranty_claims,
    ROUND(
        100.0 * SUM(total_claims) / NULLIF(SUM(total_sales), 0),
        2
    ) AS claim_percentage,
    ROUND(
        CORR(price, total_claims)::numeric,
        4
    ) AS price_claim_correlation
FROM product_sales_claims
GROUP BY price_range
ORDER BY MIN(price);

WITH monthly_sales AS (
    SELECT
        st.store_id,
        st.store_name,
        DATE_TRUNC('month', s.sale_date) AS sales_month,
        SUM(s.quantity) AS monthly_units_sold
    FROM sales s
    JOIN stores st
        ON st.store_id = s.store_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '4 years'
    GROUP BY
        st.store_id,
        st.store_name,
        DATE_TRUNC('month', s.sale_date)
),
running_sales AS (
    SELECT
        store_id,
        store_name,
        sales_month,
        monthly_units_sold,
        SUM(monthly_units_sold) OVER (
            PARTITION BY store_id
            ORDER BY sales_month
        ) AS running_total_units,
        LAG(monthly_units_sold) OVER (
            PARTITION BY store_id
            ORDER BY sales_month
        ) AS previous_month_units
    FROM monthly_sales
)
SELECT
    store_id,
    store_name,
    TO_CHAR(sales_month, 'YYYY-MM') AS sales_month,
    monthly_units_sold,
    running_total_units,
    previous_month_units,
    ROUND(
        100.0 * (monthly_units_sold - previous_month_units)
        / NULLIF(previous_month_units, 0),
        2
    ) AS month_over_month_growth_percentage
FROM running_sales
ORDER BY store_id, sales_month;
