create database ecommerce;
use ecommerce;

select * from details;
select * from orders;





-- KPIs 
-- Total Revenue
select sum(amount) from details;
-- Average  monthly Revenue
select avg(monthly_revenue) from(
			select Month(str_to_date(o.order_date,"%c/%e/%y")) as month_num, sum(d.amount) as monthly_revenue
            from orders o
			join details d
            on o.order_id = d.order_id
             group by month_num)t;
             
-- Total Profit
select sum(profit) from details;

-- Total customers
select count(distinct customer_name) from orders;

-- Profit Margin %
select (sum(profit) / sum(amount)) * 100 as profit_margin
from details;

-- Loss Contribution %

select category,
	sum(case when profit< 0 then profit else 0 end) as category_loss,
    sum(case when profit< 0 then profit else 0 end) / (select sum(profit) from details where profit<0)*100 as loss_contribution_percent
    from details
    group by category
    order by loss_contribution_percent desc;

-- Monthly Revenue
select monthname(order_dt) as month_name, sum(monthly_amount) as monthly_revenue
from(
	select 
    str_to_date(order_date,"%c/%e/%Y") as order_dt,
    d.amount as monthly_amount
    from orders o
    join details d
    on o.order_id = d.order_id
    )t
    group by month(order_dt), monthname(order_dt)
    order by month(order_dt);
    
-- Trend

-- Revenue by category
select category, 
sum(amount) as revenue,
sum(profit) as profit,
sum(quantity) as total_quantity
from details
group by category;

-- Sub-Category analysis
select sub_category, 
sum(amount) as revenue,
sum(profit) as profit,
sum(quantity) as total_quantity
from details
group by sub_category
order by profit desc;
        
-- Where is the business performing well
select o.state, o.city,
sum(d.amount) as revenue,
sum(d.profit) as profit
from orders o
join details d
on o.order_id= d.order_id
group by o.state, o.city
order by profit desc;
    
-- Total loss
select * from details 
where profit<0;
    
    
-- Loss by Category
SELECT 
category,
SUM(profit) AS total_loss
FROM details
WHERE profit < 0
GROUP BY category
ORDER BY total_loss ASC;
    
-- Customer analysis
select o.customer_name, sum(d.amount) as revenue, sum(d.profit) as profit
from orders o 
join details d
on o.order_id = d.order_id
group by o.customer_name 
order by profit desc;
        
-- Payment mode analysis
select payment_mode , sum(amount) as revenue, sum(profit) as profit 
from details
group by payment_mode
order by profit desc;
    
-- Top 10 customers
select o.customer_name , sum(d.amount) as revenue, sum(d.profit) as profit
from orders o
join details d
on o.order_id = d.order_id
group by customer_name
order by profit desc limit 10;
    
-- Bottom 10 customers
select o.customer_name , sum(d.amount) as revenue, sum(d.profit) as profit
from orders o
join details d
on o.order_id = d.order_id
group by customer_name
order by profit asc limit 10;
    
-- Top Sub Categories
select sub_category,
sum(amount) as revenue, sum(profit) as profit  
from details 
group by sub_category
order by profit desc limit 10;
    
-- Bottom sub categories
select sub_category,
sum(amount) as revenue, sum(profit) as profit  
from details 
group by sub_category
order by profit asc limit 10;
  
-- Profit per Order 
SELECT 
order_id,
SUM(profit) AS profit_per_order
FROM details
GROUP BY order_id;
    
-- Revenue per order
SELECT 
order_id,
SUM(amount) AS revenue_per_order
FROM details
GROUP BY order_id;
	
-- Loss per order
SELECT 
order_id,
SUM(profit) AS total_profit
FROM details
GROUP BY order_id
having sum(profit)<0
order by Total_profit asc;
    
-- Profit margin by Category
select category, sum(profit)/ sum(amount) *100 as profit_margin 
from details 
group by category;
    
-- Revenue contribution %
SELECT 
category,
SUM(amount) * 100.0 / (SELECT SUM(amount) FROM details) AS revenue_contribution
FROM details
GROUP BY category;
 
-- Profit Contribution %
SELECT 
category,
SUM(profit) * 100.0 / (SELECT SUM(profit) FROM details) AS revenue_contribution
FROM details
GROUP BY category;
    
-- High revenue but low profit
SELECT 
sub_category,
SUM(amount) AS revenue,
SUM(profit) AS profit
FROM details	
GROUP BY sub_category
HAVING SUM(amount) > 10000 AND SUM(profit) < 1000;