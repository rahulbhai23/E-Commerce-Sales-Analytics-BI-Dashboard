CREATE TABLE dim_customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(150),
    customer_age INT,
    gender VARCHAR(20),
    customer_segment VARCHAR(50),
    customer_city VARCHAR(100),
    customer_state VARCHAR(100),
    customer_country VARCHAR(100),
    region VARCHAR(50),
    customer_postal_code VARCHAR(20),
    customer_acquisition_cost DECIMAL(12,2)
);


CREATE TABLE dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    product_category VARCHAR(100),
    product_subcategory VARCHAR(100),
    brand VARCHAR(100),
    supplier VARCHAR(150),
    list_unit_price DECIMAL(12,2),
    standard_cost DECIMAL(12,2),
    product_rating DECIMAL(3,2)
);


CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INT,
    quarter VARCHAR(5),
    month_number INT,
    month_name VARCHAR(20),
    week_of_year INT,
    day_name VARCHAR(15),
    is_weekend BOOLEAN
);


CREATE TABLE fact_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    date_key INT NOT NULL,

    order_status VARCHAR(30),
    sales_channel VARCHAR(50),
    customer_type VARCHAR(50),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    currency VARCHAR(10),
    shipping_method VARCHAR(50),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(50),
    return_status VARCHAR(50),
    return_reason VARCHAR(255),
    marketing_channel VARCHAR(100),
    campaign_name VARCHAR(150),
    coupon_code VARCHAR(100),

    delivery_days SMALLINT,
    estimated_delivery_days SMALLINT,
    customer_rating DECIMAL(3,2),
    review_sentiment VARCHAR(50),
    customer_review TEXT,

    loyalty_points_earned BIGINT,
    loyalty_points_redeemed BIGINT,
    profit_margin_percentage DECIMAL(8,4),
    customer_lifetime_value DECIMAL(14,2),
    is_repeat_customer BOOLEAN,
    customer_order_count BIGINT,

    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id). REFERENCES dim_customer(customer_id),

    CONSTRAINT fk_orders_date FOREIGN KEY (date_key). REFERENCES dim_date(date_key)
);


CREATE TABLE fact_order_items (
    order_item_key BIGINT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    date_key INT NOT NULL,

    quantity INT NOT NULL,
    unit_price DECIMAL(12,2),
    discount_percentage DECIMAL(8,4),
    discount_amount DECIMAL(14,2),
    gross_sales DECIMAL(14,2),
    tax_amount DECIMAL(14,2),
    shipping_cost DECIMAL(14,2),
    net_sales DECIMAL(14,2),
    product_cost DECIMAL(14,2),
    profit DECIMAL(14,2),

    CONSTRAINT fk_items_order  FOREIGN KEY (order_id) REFERENCES fact_orders(order_id),

    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id),

    CONSTRAINT fk_items_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),

    CONSTRAINT fk_items_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
