install.packages(c(
  "DBI",
  "RMySQL",
  "tidyverse",
  "cluster",
  "factoextra",
  "corrplot"
))

library(DBI)
library(RMySQL)

# Connect to MySQL
con <- dbConnect(
  RMySQL::MySQL(),
  dbname = "adidas_db",
  host = "localhost",
  port = 3306,
  user = "root",
  password = ""
)

# Check tables
dbListTables(con)

#view dataset

query1 <- "
SELECT *
FROM adidas_sales_2
LIMIT 10;
"
data_preview <- dbGetQuery(con, query1)
head(data_preview)

#check missing values
query2 <- "
SELECT
COUNT(*) AS total_rows,
COUNT(`Retailer`) AS retailer_count,
COUNT(`Total Sales`) AS sales_count
FROM adidas_sales_2;
"
dbGetQuery(con, query2)

#Query for clustering dataset

query3 <- "
SELECT
Retailer,
Region,

AVG(
CAST(REPLACE(REPLACE(`Price per Unit`, '$', ''), ',', '')
AS DECIMAL(10,2))
) AS avg_price,

AVG(
CAST(REPLACE(REPLACE(`Units Sold`, ',', ''), '$', '')
AS DECIMAL(10,2))
) AS avg_units_sold,

SUM(
CAST(REPLACE(REPLACE(`Total Sales`, '$', ''), ',', '')
AS DECIMAL(15,2))
) AS total_sales,

SUM(
CAST(REPLACE(REPLACE(`Operating Profit`, '$', ''), ',', '')
AS DECIMAL(15,2))
) AS operating_profit,

AVG(
CAST(REPLACE(`Operating Margin`, '%', '')
AS DECIMAL(10,2))
) AS operating_margin

FROM adidas_sales_2
GROUP BY Retailer, Region;
"

df <- dbGetQuery(con, query3)

head(df)
str(df)
summary(df)

#Select variables for clustering
library(tidyverse)
cluster_data <- df %>%
  select(
    avg_price,
    avg_units_sold,
    total_sales,
    operating_profit,
    operating_margin
  )

#standardize data
scaled_data <- scale(cluster_data)

#optimal number of clusters (Elbow Method)
library(factoextra)

fviz_nbclust(
  scaled_data,
  kmeans,
  method = "wss"
)

#K-Means clustering , K=4
set.seed(123)

kmeans_result <- kmeans(
  scaled_data,
  centers = 4,
  nstart = 25
)

kmeans_result

#silhouette analysis
library(cluster)
library(factoextra)
sil <- silhouette(
  kmeans_result$cluster,
  dist(scaled_data)
)

fviz_silhouette(sil)

#adding cluster labels
df$Cluster <- as.factor(kmeans_result$cluster)
head(df)

#cluster plot
fviz_cluster(
  kmeans_result,
  data = scaled_data
)

ggplot(df,
       aes(total_sales,
           operating_profit,
           color = Cluster)) +
  geom_point(size = 3)

#analysing clusters
cluster_summary <- df %>%
  group_by(Cluster) %>%
  summarise(across(where(is.numeric), mean))

cluster_summary

#EDA for cluster data
summary(df)

cor(cluster_data)

library(corrplot)
corrplot(cor(cluster_data))


