       ----- SQL Retail Sales Analysis   Project 1 ---

use SQL_Project_DB

/*** Understanding the Data ***/

select * from  Retail_Sales_tb


---to check the data type of the columns

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'Retail_Sales_tb';

-- first 10 records

SELECT TOP 10 * 
FROM Retail_Sales_tb;

--- total records in a table

select count(*) from Retail_Sales_tb


/*** Data Cleaning ***/

select*from Retail_Sales_tb
where transactions_id is null 
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null


delete from Retail_Sales_tb
where transactions_id is null 
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

/*****Data Exploration*******/

----How many sales we have?

select count(*) as total_sale from Retail_Sales_tb

----How many unique customers we have?

select count(DISTINCT customer_id) as total_customer from Retail_Sales_tb

--- How Many Categories we have?

select category, count(category) as category_count
from Retail_Sales_tb
group by category


/**Data Analysis & business key problems**/

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM Retail_Sales_tb
WHERE sale_date = '2022-11-05'



--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from Retail_Sales_tb
where category = 'Clothing' 
and quantiy>=4 
and format(sale_date, 'YYYY-MM') = '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as total_sales
from Retail_Sales_tb
group by category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT * from Retail_Sales_tb

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM Retail_Sales_tb
WHERE category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * from Retail_Sales_tb
where total_sale>1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender, count(transactions_id)
from Retail_Sales_tb
group by category,gender

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from Retail_Sales_tb

SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_sale
FROM 
    Retail_Sales_tb
GROUP BY 
    YEAR(sale_date), 
    MONTH(sale_date);


WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_sale
    FROM 
        Retail_Sales_tb
    GROUP BY 
        YEAR(sale_date), 
        MONTH(sale_date)
)
SELECT 
    sale_year,
    sale_month,
    avg_sale
FROM 
    MonthlySales ms1
WHERE 
    avg_sale = (SELECT MAX(avg_sale) 
                FROM MonthlySales ms2 
                WHERE ms1.sale_year = ms2.sale_year)
ORDER BY 
    sale_year;





--Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
    TOP 5 customer_id,
    SUM(total_sale) AS total_sales
FROM 
    Retail_Sales_tb
GROUP BY 
    customer_id
ORDER BY 
    total_sales DESC;


--Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM Retail_Sales_tb
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM Retail_Sales_tb
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;


/******end of the project***********/