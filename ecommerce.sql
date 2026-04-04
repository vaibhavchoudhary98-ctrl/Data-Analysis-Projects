--First creating the database ecommerece and then inserting the csv file

CREATE DATABASE ecommerce
use ecommerce

-- importing the csv file into the ecommerce database. I have imported using import flat file and named the file as user_events

SELECT TOP 5 * From user_events   --querying the first 5 rows

--check the data types for the columns

EXEC sp_help user_events

--check for the null values

SELECT * FROM user_events
WHERE event_id is NULL
OR USER_ID IS NULL
OR event_type IS NULL
OR event_date IS NULL
OR event_date IS NULL
OR product_id IS NULL
OR amount IS NULL
OR traffic_source IS NULL


--amount column has null values. Replacing the null values by 0.

UPDATE user_events
SET amount=0
WHERE amount IS NULL;



-- Q1. Define funnel and unserc count
/*Define the e-commerce sales funnel and determine the number of users at each stage of the funnel?
 
 Funnel stages: page_view -> add_to_cart -> checkout_start -> payment_info -> purchase */

SELECT 
	COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN USER_ID END)) as stage_1_page_view,
	COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN USER_ID END)) as stage_2_add_to_cart,
	COUNT(DISTINCT (CASE WHEN event_type = 'checkout_start' THEN USER_ID END)) as stage_3_checkout_start,
	COUNT(DISTINCT (CASE WHEN event_type = 'payment_info' THEN USER_ID END)) as stage_4_payment_info,
	COUNT(DISTINCT (CASE WHEN event_type = 'purchase' THEN USER_ID END)) as stage_5_purchase
FROM user_events

--Q2. Conversion rate analysis
--What are the conversion rate between each stage of the funnel, and what is the overall conversion rate from the page view to purchae?

WITH funnel_stages as (
	SELECT 
		COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN USER_ID END)) as stage_1_page_view,
		COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN USER_ID END)) as stage_2_add_to_cart,
		COUNT(DISTINCT (CASE WHEN event_type = 'checkout_start' THEN USER_ID END)) as stage_3_checkout_start,
		COUNT(DISTINCT (CASE WHEN event_type = 'payment_info' THEN USER_ID END)) as stage_4_payment_info,
		COUNT(DISTINCT (CASE WHEN event_type = 'purchase' THEN USER_ID END)) as stage_5_purchase
	FROM user_events
)

SELECT stage_1_page_view, 
		stage_2_add_to_cart, 
			ROUND(CAST(stage_2_add_to_cart AS FLOAT) / stage_1_page_view * 100, 2) as view_to_cart_conv,
		stage_3_checkout_start,
			 ROUND(CAST(stage_3_checkout_start AS FLOAT) / stage_2_add_to_cart * 100, 2) as addcart_to_checkout_conv,
		stage_4_payment_info,
			ROUND(CAST(stage_4_payment_info AS FLOAT) / stage_3_checkout_start * 100, 2) as checkout_to_payment_conv,
		stage_5_purchase,
			ROUND(CAST(stage_5_purchase AS FLOAT) / stage_4_payment_info * 100, 2) as payment_to_purchase_conv,
			ROUND(CAST(stage_5_purchase AS FLOAT) / stage_1_page_view * 100, 2) as pageview_to_purchase_conv
FROM funnel_stages


--Q3. Funnel performance by traffic source
--How does the funnel performance vary acorss different traffic sources, and what  are the corresponding user counts and conversion rates at each stage?

With funnel_traffic_source as(
	SELECT traffic_source,
			COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN USER_ID END)) as stage_1_page_view,
			COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN USER_ID END)) as stage_2_add_to_cart,
			COUNT(DISTINCT (CASE WHEN event_type = 'checkout_start' THEN USER_ID END)) as stage_3_checkout_start,
			COUNT(DISTINCT (CASE WHEN event_type = 'payment_info' THEN USER_ID END)) as stage_4_payment_info,
			COUNT(DISTINCT (CASE WHEN event_type = 'purchase' THEN USER_ID END)) as stage_5_purchase
	FROM user_events
	GROUP BY traffic_source
)

SELECT traffic_source, 
	stage_1_page_view, 
		ROUND(CAST(stage_1_page_view AS FLOAT) / (SELECT COUNT(DISTINCT USER_ID) FROM user_events) * 100, 2) as totalusers_to_pageview,
	stage_2_add_to_cart,
		ROUND(CAST(stage_2_add_to_cart AS FLOAT) / stage_1_page_view * 100, 2) as pageview_to_addtocart_conv,
	stage_3_checkout_start,
		ROUND(CAST(stage_3_checkout_start AS FLOAT) / stage_2_add_to_cart * 100, 2) as addtocart_to_checkout_conv,
	stage_4_payment_info,
		ROUND(CAST(stage_4_payment_info AS FLOAT) / stage_3_checkout_start * 100, 2) as checkout_to_payment_conv,
	stage_5_purchase,
		ROUND(CAST(stage_5_purchase AS FLOAT) / stage_4_payment_info * 100, 2) as purc_to_purchase_conv,
		ROUND(CAST(stage_5_purchase AS FLOAT) / stage_1_page_view * 100, 2) as payment_to_purchase_conv,

FROM funnel_traffic_source



--Q4. Time-based funnel analysis
--What is the average time taken by users to move through each stage of the funnel, and what is the overall average journey time for converetd users?

WITH funnel_time AS (
SELECT
	user_id,
	MIN(CASE WHEN event_type='page_view' THEN event_date END) as page_view_time,
	MIN(CASE WHEN event_type='add_to_cart' THEN event_date END) as addtocart_time,
	MIN(CASE WHEN event_type='checkout_start' THEN event_date END) as checkout_start_time,
	MIN(CASE WHEN event_type='payment_info' THEN event_date END) as payment_info_time,
	MIN(CASE WHEN event_type='purchase' THEN event_date END) as purchase_time
FROM user_events
GROUP BY user_id
HAVING MIN(CASE WHEN event_type='purchase' THEN event_date END) IS NOT NULL
)

SELECT 
	COUNT(*) AS total_converted_users,
	CAST(AVG(DATEDIFF(SECOND, page_view_time, addtocart_time)) /60.0 AS decimal(10,2)) as avg_timetaken_pageview_addtocart,
	CAST(AVG(DATEDIFF(SECOND, addtocart_time, checkout_start_time)) / 60.0 AS decimal(10,2)) as avg_timetaken_addtocart_checkout,
	CAST(AVG(DATEDIFF(SECOND, checkout_start_time, payment_info_time)) / 60.0 AS decimal(10,2)) as avg_timetaken_checkout_paymentinfo,
	CAST(AVG(DATEDIFF(SECOND, payment_info_time, purchase_time)) / 60.0 as decimal(10,2)) as avg_timetaken_paymentinfo_purchase,
	CAST(AVG(DATEDIFF(SECOND, page_view_time, purchase_time)) / 60.0 as decimal(10,2)) as avg_journey_time
FROM funnel_time

--Q5. Revenue analaysis
--Find the key reveneue metrics of the funnel, including total revenue, average order value (AOV), revenue per buyer, and revenue per visitor. 

WITH funnel_revenue AS (
SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) as total_unique_visitors,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) as total_buyers,
	COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) as total_orders,
	ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount END), 2) as total_revenue
FROM user_events
)
SELECT total_unique_visitors,
		total_buyers,
		total_orders,
		total_revenue,
		ROUND(total_revenue / total_orders, 2) as avg_order_value,
		ROUND(total_revenue / total_buyers, 2) as revenue_per_buyer,
		ROUND(total_revenue / total_unique_visitors, 2) as revenue_per_visitor
FROM funnel_revenue


