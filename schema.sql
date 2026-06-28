/*
    Project Name: Apple Sales SQL Analysis
    File Name: schema.sql
    Database: PostgreSQL

    Description:
    This file contains the SQL commands used to create the database tables
    for the Apple Sales Analysis project. The schema is designed based on
    the ER diagram and includes tables for categories, products, stores,
    sales, and warranty claims.

    Tables Created:
    1. category
    2. products
    3. stores
    4. sales
    5. warranty

    Key Concepts:
    - Primary Keys
    - Foreign Keys
    - Table Relationships
    - Relational Database Design
*/

CREATE TABLE category (
    category_id varchar(10) PRIMARY KEY,
    category_name varchar(20) NOT NULL
);

CREATE TABLE stores (
    store_id varchar(5) PRIMARY KEY,
    store_name varchar(30) NOT NULL,
    city varchar(25) NOT NULL,
    country varchar(25) NOT NULL
);

CREATE TABLE products (
    product_id varchar(10) PRIMARY KEY,
    product_name varchar(35) NOT NULL,
    category_id varchar(10) REFERENCES category(category_id),
    launch_date date,
    price double precision
);

CREATE TABLE sales (
    sale_id varchar(15) PRIMARY KEY,
    sale_date date NOT NULL,
    store_id varchar(10) REFERENCES stores(store_id),
    product_id varchar(10) REFERENCES products(product_id),
    quantity integer
);

CREATE TABLE warranty (
    claim_id varchar(10) PRIMARY KEY,
    claim_date date NOT NULL,
    sale_id varchar(15) REFERENCES sales(sale_id),
    repair_status varchar(15)
);

SELECT 'category' AS table_name, COUNT(*) FROM category
UNION ALL SELECT 'stores', COUNT(*) FROM stores
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sales', COUNT(*) FROM sales
UNION ALL SELECT 'warranty', COUNT(*) FROM warranty;
