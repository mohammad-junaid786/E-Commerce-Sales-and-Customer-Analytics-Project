# 🛒 E-Commerce Sales & Customer Analytics – SQL Project  

## 📌 Project Overview  

This project analyzes an **e-commerce transactional dataset (Online Retail II – UCI)** to uncover insights related to **sales performance, product behavior, and customer value**.

The objective is to simulate a **real-world business intelligence workflow** using SQL — from **raw data preparation** → **data validation & modeling** → **structured business analysis**.

This project focuses purely on **SQL analytics and business logic design**.

---

## 📂 Dataset Used  

**Source:** Online Retail II (UCI Machine Learning Repository)

- 📊 1,000,000+ transaction records  
- 🌍 Multiple countries  
- 🛒 Invoice-level transactional data  

The dataset contains transactional data including:

- `InvoiceNo`
- `StockCode`
- `Description`
- `Quantity`
- `InvoiceDate`
- `UnitPrice`
- `CustomerID`
- `Country`

---

## ⚙️ Project Workflow  

### 1️⃣ Data Preparation  
- Created database and raw transaction table  
- Imported CSV data into SQL Server  
- Performed validation checks (row counts, null checks, date range verification)  

### 2️⃣ Data Modeling  
- Created analytical view: `vw_transactions`  
- Implemented a **Net Revenue Model**:
  - Revenue includes returns and cancellations  
  - Completed orders exclude cancelled invoices (`invoice_no NOT LIKE 'C%'`)  
  - Customer-level metrics exclude `NULL` `customer_id` where required  

### 3️⃣ Business Analysis  
Structured SQL scripts were written to analyze:

- Sales performance  
- Product performance  
- Customer behavior  
- Revenue concentration  

All analysis scripts are organized in the `/scripts` folder.

---

## 🎯 Business Objectives & Key Questions  

### 🔹 Sales Performance  
- What is the total revenue generated?  
- How do revenue, orders, and customers trend monthly and yearly?  
- What is the Average Order Value (AOV)?  
- Which countries generate the highest revenue?  

---

### 🔹 Product Analysis  
- Which products generate the highest revenue?  
- Which products sell the most quantity?  
- Which products appear in the most orders?  
- Which products have high return rates?  
- Are there premium vs fast-moving products?  
- Do top products show seasonal trends?  

---

### 🔹 Customer Analysis  
- How many unique customers are there?  
- What is the average revenue and orders per customer?  
- Who are the top customers by revenue?  
- What is the repeat vs one-time customer split?  
- Do a small percentage of customers generate most revenue (Pareto analysis)?  
- How can customers be segmented based on revenue contribution?  
- What is the basic Customer Lifetime Value (CLV)?  

---

## 🛠️ Tools & Skills Used  

- **SQL Server (T-SQL)**  
- Data validation & modeling  
- Aggregations & grouping  
- Conditional aggregation  
- Window functions (`RANK`, `NTILE`, `SUM OVER`)  
- Revenue modeling & safe division (`NULLIF`)  
- Business KPI calculation  
- Structured query design  

---

## 📂 Repository Structure  
```
E-Commerce-Sales-Analytics/
│
├── datasets/
│ └── online_retail_ii.csv
│
├── scripts/
│ ├── 01_database_setup.sql
│ ├── 02_validation.sql
│ ├── 03_create_view.sql
│ │
│ ├── 04_sales_analysis.sql
│ ├── 05_product_analysis.sql
│ └── 06_customer_analysis.sql
│
└── README.md
```

---

## 📊 Key Insights Generated  

- Revenue shows strong seasonality with peak months in Q4  
- A small percentage of customers contribute a large share of total revenue  
- Repeat customers generate significantly higher lifetime value  
- Certain products show high return rates, indicating potential quality issues  
- Clear distinction between premium products and high-volume fast movers  

---

## ✅ Conclusion  

This project demonstrates a **complete SQL analytics workflow**, including:

- Data preparation and validation  
- Business-focused KPI modeling  
- Product performance evaluation  
- Customer retention and segmentation analysis  
- Revenue concentration modeling using window functions  

The structured approach reflects real-world BI and analytics practices, focusing on clarity, business alignment, and scalable query design.

---

## 🚀 Future Extension  

This project will be extended into an interactive **Tableau dashboard** for executive-level visualization and storytelling.

---

## 🌟 About Me  

Hi, I’m **Mohammad Junaid**, passionate about data analytics, structured problem-solving, and building end-to-end analytical projects.

I enjoy working on real-world datasets to:
- Strengthen technical skills  
- Think from a business perspective  
- Deliver meaningful, actionable insights  

Always learning and continuously improving.

