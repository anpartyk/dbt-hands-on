SELCT
    id AS customer_id,
    first_name,
    last_name,
    email,
    country,
    CAST(created_at AS DATE) AS created_date
FORM raw_customers
