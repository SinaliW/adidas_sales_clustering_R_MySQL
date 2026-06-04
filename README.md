# Adidas Retail Sales Clustering Analysis using R and MySQL

## Project Overview

This project analyzes Adidas retail sales data using **SQL (MySQL)** and **R programming** to identify retailer segments through **K-Means clustering**. The project integrates **database management, data preprocessing, exploratory data analysis (EDA), clustering techniques, and cluster validation** to uncover patterns in retailer sales behavior.

The objective is to group retailers based on sales performance metrics such as pricing, units sold, total sales, profitability, and operating margin.

---

## Objectives

- Connect R with a MySQL database for data extraction.
- Clean and preprocess Adidas sales data using SQL queries.
- Aggregate retailer-level sales metrics.
- Perform **K-Means clustering** to identify retailer segments.
- Determine the optimal number of clusters using the **Elbow Method**.
- Validate clustering quality using **Silhouette Analysis**.
- Visualize retailer clusters and interpret business insights.

---

## Dataset Description

The dataset contains Adidas retail sales information, including:

- Retailer name
- Region
- Price per unit
- Units sold
- Total sales
- Operating profit
- Operating margin

The data was stored and queried from a **MySQL database (`adidas_db`)**.

---

## Tools and Technologies Used

### Programming Language
- R

### Database
- MySQL
- phpMyAdmin

### R Packages Used
- `DBI`
- `RMySQL`
- `tidyverse`
- `cluster`
- `factoextra`
- `corrplot`

---

## Project Workflow

### 1. Database Connection
Connected **R** to **MySQL** using `DBI` and `RMySQL`.

```r
con <- dbConnect(
  RMySQL::MySQL(),
  dbname = "adidas_db",
  host = "localhost",
  port = 3306,
  user = "root",
  password = ""
)
```

---

### 2. Data Extraction and Cleaning

SQL queries were written directly inside the **R script** and executed through the MySQL connection using `dbGetQuery()`.

The queries were used to:

- Retrieve Adidas sales data
- Check missing values
- Convert currency and percentage values into numeric format
- Aggregate retailer-level sales metrics

Key preprocessing included:

- Removing `$`, `%`, and commas from variables
- Converting text values into numeric format using SQL `CAST()`
- Aggregating data by **Retailer** and **Region**

---

### 3. Feature Selection

Selected variables for clustering:

- Average Price per Unit (`avg_price`)
- Average Units Sold (`avg_units_sold`)
- Total Sales (`total_sales`)
- Operating Profit (`operating_profit`)
- Operating Margin (`operating_margin`)

---

### 4. Data Standardization

Feature scaling was applied using:

```r
scaled_data <- scale(cluster_data)
```

This ensures all variables contribute equally to clustering.

---

### 5. Optimal Number of Clusters

The **Elbow Method (WSS)** was used to determine the optimal number of clusters.

**Selected number of clusters: K = 4**

### Result

<img width="1105" height="744" alt="image" src="https://github.com/user-attachments/assets/309aae5d-7ecb-4aad-8ccc-61ef3c317a08" />


---

### 6. K-Means Clustering

K-Means clustering was performed with:

```r
kmeans(
  scaled_data,
  centers = 4,
  nstart = 25
)
```

Using:

- **K = 4**
- **25 random starts** for better cluster stability.

---

### 7. Cluster Validation

**Silhouette Analysis** was performed to evaluate cluster quality.

#### Average Silhouette Width by Cluster

| Cluster | Size | Average Silhouette Width |
|----------|------|---------------------------|
| 1 | 17 | 0.46 |
| 2 | 2 | 0.64 |
| 3 | 6 | 0.24 |
| 4 | 3 | 0.60 |

### Overall Interpretation

- **Cluster 2 (0.64)** and **Cluster 4 (0.60)** show strong separation and clear retailer grouping.
- **Cluster 1 (0.46)** indicates moderate clustering quality.
- **Cluster 3 (0.24)** suggests some overlap between retailer behaviors, which is expected in real-world retail sales data.

The clustering achieved **moderate but meaningful segmentation** of Adidas retailers.

### Result
<img width="1105" height="744" alt="image" src="https://github.com/user-attachments/assets/2ee67065-1d59-4cd5-abbb-f5b4528dac86" />


---

### 8. Cluster Visualization

Retailers were visualized based on:

- **Total Sales**
- **Operating Profit**

colored by cluster membership.

### Result
<img width="1105" height="744" alt="image" src="https://github.com/user-attachments/assets/46612cf3-9d64-41a2-ae09-550fa5ec08f9" />



---

### 9. Correlation Analysis

Correlation analysis was performed to understand relationships among numerical sales variables.

Techniques used:

- Correlation Matrix
- Correlation Heatmap (`corrplot`)

### Result
<img width="1105" height="744" alt="image" src="https://github.com/user-attachments/assets/232eb01e-82ae-4553-be1f-ea4df19e70fa" />


---

## Cluster Insights

Cluster summaries were generated using mean values of numerical variables.

Possible retailer segmentation:

- **High-performing retailers** with high sales and profit
- **Moderate performers** with balanced metrics
- **Low-volume retailers**
- **Retailers with distinct pricing/profitability strategies**



## Key Findings

- Successfully integrated **MySQL with R** for database-driven analytics.
- Applied **SQL preprocessing** to clean and aggregate retail sales data.
- Identified **4 retailer segments** using K-Means clustering.
- Silhouette analysis showed **moderate cluster separation (overall meaningful segmentation)**.
- Sales and profitability metrics played an important role in retailer differentiation.

---

## Repository Structure

```text
├── data/
│   └── adidas_sales.csv
│
├── scripts/
│   └── clustering_analysis.R
│
├── results/
│   ├── elbow_plot.png
│   ├── silhouette_plot.png
│   ├── cluster_plot.png
│   └── correlation_plot.png
│
└── README.md
```

---



