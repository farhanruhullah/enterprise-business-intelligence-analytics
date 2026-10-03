# Enterprise Business Intelligence & Analytics System

An end-to-end Business Intelligence portfolio project built with Microsoft SQL Server, Python, and Power BI.

The project transforms raw transactional data from the AdventureWorks2022 database into a structured analytical data warehouse, performs business analysis using Python, and presents interactive insights through Power BI dashboards.

---

## Project Overview

This project demonstrates a complete Business Intelligence workflow:

- Data exploration and quality validation
- Data warehouse design
- ETL development
- Star schema modeling
- SQL analytical views
- Python-based business analysis
- Automated business insight generation
- Interactive Power BI dashboards

The analysis focuses on sales performance, customers, products, and regional performance.

---

## Technology Stack

- Microsoft SQL Server
- SQL Server Management Studio
- Python
- Pandas
- SQLAlchemy
- PyODBC
- Python-dotenv
- Power BI
- DAX
- Git & GitHub

---

## Data Source

The project uses the Microsoft AdventureWorks2022 sample database.

The analytical period covers:

**2011 – 2014**

---

## Data Warehouse Architecture

A star schema was developed in SQL Server.

### Dimension Tables

- DimCustomer
- DimProduct
- DimDate
- DimTerritory

### Fact Table

- FactSales

The FactSales table contains transactional sales data including:

- Order ID
- Customer
- Product
- Territory
- Date
- Order Quantity
- Sales Amount
- Discount
- Profit

Order-level analysis uses the original Order ID so that business orders are counted correctly instead of counting individual sales lines.

---

## ETL Process

SQL Server ETL processes were developed to:

1. Extract data from AdventureWorks2022
2. Clean and validate source data
3. Transform business attributes
4. Populate dimension tables
5. Populate the sales fact table
6. Calculate sales and profit measures
7. Create analytical SQL views

---

## SQL Analytical Views

The following views were created:

### Revenue Performance

Analyzes:

- Monthly revenue
- Monthly profit
- Quantity sold
- Revenue trends

### Customer Intelligence

Analyzes:

- Customer spending
- Customer order activity
- Customer profitability
- Customer value

### Product Performance

Analyzes:

- Product revenue
- Product profit
- Units sold
- Category performance

### Regional Performance

Analyzes:

- Regional revenue
- Regional profit
- Order volume
- Geographic performance

---

## Python Analytics Layer

Python connects directly to the SQL Server data warehouse.

The Python layer includes:

- Database connection management
- Revenue analysis
- Customer analysis
- Product analysis
- Regional analysis
- Automated business insight generation

### Python Project Files

```text
Python/
├── database_connection.py
├── analysis.py
├── revenue_analysis.py
├── customer_analysis.py
├── product_analysis.py
├── regional_analysis.py
└── generate_insights.py