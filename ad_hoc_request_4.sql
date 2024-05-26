with cte1 as(
SELECT *,(if(promo_type = "BOGOF",`quantity_sold(after_promo)` * 2 ,`quantity_sold(after_promo)`)) as quantities_sold_AP 
FROM retail_events_db.fact_events 
join dim_campaigns using(campaign_id)
join dim_products using (product_code)
where campaign_name = "Diwali" ),

cte2 as(
select 
campaign_name, category,
((sum(quantities_sold_AP) - sum(`quantity_sold(before_promo)`))/sum(`quantity_sold(before_promo)`)) * 100 as `ISU%`
 from cte1 group by category 
 )
 
 select campaign_name, category, `ISU%`, rank() over(order by `ISU%`DESC) as `ISU%_Rank` from cte2