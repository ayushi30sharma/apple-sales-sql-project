# 🍎 Apple Sales & Warranty Analysis using PostgreSQL

## 📌 Project Overview

This project analyzes Apple product sales and warranty claims using **PostgreSQL**. The database is designed from an Entity Relationship (ER) diagram and contains multiple related tables representing products, stores, sales transactions, categories, and warranty claims.

The project focuses on solving real-world business problems using SQL, including sales analysis, warranty trends, growth analysis, and product performance.

---

## 🗂️ Database Schema

### **category**

Stores product category details.

| Column        |
| ------------- |
| category_id   |
| category_name |

---

### **products**

Stores product information.

| Column       |
| ------------ |
| product_id   |
| product_name |
| category_id  |
| launch_date  |
| price        |

---

### **stores**

Stores Apple store details.

| Column     |
| ---------- |
| store_id   |
| store_name |
| city       |
| country    |

---

### **sales**

Stores sales transaction details.

| Column     |
| ---------- |
| sale_id    |
| sale_date  |
| store_id   |
| product_id |
| quantity   |

---

### **warranty**

Stores warranty claim details.

| Column        |
| ------------- |
| claim_id      |
| claim_date    |
| sale_id       |
| repair_status |

---

# 📊 Business Problems Solved

✔️ Find the number of stores in each country.

✔️ Determine how many stores have never had a warranty claim filed.

✔️ Calculate the percentage of warranty claims marked as **"Warranty Void."**

✔️ Identify which store had the highest total units sold in the last year.

✔️ Count the number of unique products sold in the last year.

✔️ For each store, identify the best-selling day based on the highest quantity sold.

✔️ List the months in the last three years where sales exceeded **5,000 units** in the USA.

✔️ Identify the product category with the most warranty claims filed in the last two years.

✔️ Determine the percentage chance of receiving warranty claims after each purchase for each country.

✔️ Analyze the year-by-year sales growth ratio for each store.

✔️ Calculate the relationship between product price and warranty claims for products sold in the last five years, segmented by price range.

✔️ Calculate the monthly running total of sales for each store over the past four years and compare sales trends.

---

# 🛠 SQL Concepts Used

* Database Creation
* Table Creation
* Primary Keys
* Foreign Keys
* Data Import using CSV
* INNER JOIN
* LEFT JOIN
* GROUP BY
* ORDER BY
* HAVING
* Aggregate Functions
* Date & Time Functions
* Window Functions
* Common Table Expressions (CTEs)
* Running Totals
* Ranking Functions (RANK, DENSE_RANK)
* LAG Function
* Percentage Calculations
* Conditional Aggregation
* Sales Growth Analysis
* Warranty Claim Analysis

---

# 📚 Key Learnings

Through this project, I learned how to:

* Design a relational database from an ER diagram.
* Create normalized PostgreSQL tables using primary and foreign keys.
* Import CSV datasets into PostgreSQL.
* Understand relationships between multiple tables.
* Solve real-world business problems using SQL.
* Perform multi-table joins for data analysis.
* Analyze sales by country, store, month, and year.
* Use window functions such as **RANK**, **LAG**, and running totals.
* Calculate warranty claim percentages.
* Analyze sales growth across multiple years.
* Evaluate product and category performance using SQL analytics.

---

# 💻 Technologies Used

* PostgreSQL
* SQL
* pgAdmin
* CSV Data Import

---

# 🚀 Skills Demonstrated

* SQL Query Writing
* Relational Database Design
* Data Analysis
* Business Intelligence
* Data Aggregation
* Window Functions
* CTEs
* Sales Analytics
* Warranty Analytics
* Time-Series Analysis
* Performance Reporting

---

## ⭐ If you found this project useful, consider giving it a Star!
