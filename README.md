📈 Vendor Performance & Inventory Analysis
An end-to-end data analytics project identifying Vendor Performance and Brand & Product Analysis.


📝 Executive Summary
This project analyzes a 1.5 GB dataset of liquor sales and inventory to optimize supply chain efficiency. By integrating MySQL, Python, and Power BI, I identified critical bottlenecks where capital is tied up in slow-moving products and underperforming vendors.


💡 Key Business Insights
Unsold Capital: Identified $2.71M in capital currently trapped in stagnant inventory.

Vendor Turnover: Isolated 5 high-risk vendors (including Altamar Brands and Caledonia Spirits) with turnover rates as low as 0.035, indicating significant overstocking.

Profit Leaders: Verified that while Diageo North America leads in total sales volume ($68M), smaller "Hidden Gem" brands offer higher profit margins but require better marketing visibility.

Target Brands: Developed logic to flag brands with high profit margins (>85th percentile) but low sales volume (<15th percentile) as primary growth opportunities.


🛠️ Technical Workflow
1. Data Engineering (MySQL)
   Configured a local MySQL server and managed user privileges (GRANT) for secure access.

   Utilized LOAD DATA INFILE for high-performance ingestion of millions of rows, handling complex data types and date formatting.

   Performed schema optimization to ensure the database could handle 1.5GB of raw sales and purchase data.

2. Exploratory Data Analysis (Python)
   Connected to the MySQL database via mysql-connector to perform deep-dive analysis in Jupyter Notebooks.

   Analyzed vendor-to-sales ratios and stock turnover to identify "dead weight" inventory.

3. Business Intelligence (Power BI)
   Developed a comprehensive dashboard featuring KPI cards, Purchase Contribution donuts, and Top/Bottom 10 performance charts.

   Wrote custom DAX measures (using PERCENTILEX.INC) to automate the identification of "Target Brands" based on statistical performance.


📁 Repository Structure

Database_Setup.sql: SQL scripts for database creation, permissions, and data loading.

Exploratory Data Analysis.ipynb: Python notebook for initial data cleaning and trend discovery.

Vendor Performance Analysis.ipynb: Python notebook focusing on vendor-specific metrics.

Vendor Performance Analysis.pbix: The interactive Power BI dashboard file.
