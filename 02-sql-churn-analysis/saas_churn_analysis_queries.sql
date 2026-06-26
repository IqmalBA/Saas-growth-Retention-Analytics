-- =========================================================
-- SaaS Customer Churn & Revenue Impact Analysis
-- End-to-End SQL Data Analytics Project
-- Database   : PostgreSQL
-- Tables     : customers, subscriptions, payments
-- Join key   : customer_id
-- =========================================================


-- =========================================================
-- 1. Monthly Revenue Trend
-- Business Question: What is the monthly revenue trend?
-- =========================================================
select  to_char(date_trunc('month', payment_date), 'mon yyyy') as month, 
sum(amount) as Revenue from payments 
group by date_trunc('month', payment_date) 
order by  date_trunc('month', payment_date);


-- =========================================================
-- 2. Customer Churn Rate
-- Business Question: What is the customer churn rate?
-- =========================================================

-- Version A: detailed breakdown (churned count, total count, rate)
select  count(case when status = 'churned' then 1 end) as churned_customers, 
count(*) as total_customers,
round (count(case when status = 'churned' then 1 end) * 100.00 / count (*), 2 ) as Churn_crunch from subscriptions;


-- Version B: churn rate only (simplified)
select round (count(case when status = 'churned' then 1 end) * 100.0 / count (*), 2 ) as Churn_crunch from subscriptions;


-- =========================================================
-- 3. Highest Churn Customer Segment
-- Business Question: Which customer segment has the highest churn?
-- =========================================================
select c. segment, count(*) as churn_count from customers c join subscriptions s on c. customer_id = s. customer_id
where status = 'churned' group by c. segment order by churn_count desc;



-- =========================================================
-- 4. Revenue Lost Due to Churn
-- Business Question: How much revenue is lost due to customer churn?
-- =========================================================
SELECT
select sum(monthly_fee) as lost_revenue from subscriptions where status = 'churned';

-- =========================================================
-- 5. Average Revenue Per User (ARPU) by Segment
-- Business Question: What is the ARPU by customer segment?
-- =========================================================
select c. segment, round(avg(p.amount),2) as ARPU from customers c join payments p on c.customer_id = p.customer_id
group by c.segment
order by ARPU DESC;

