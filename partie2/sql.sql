--sortie de toutes les commandes par oi.order_id, oi.created_at, c.city, oi.channel;
CREATE OR REPLACE VIEW di01.orders_clean
AS 
  select oi.order_id,
         oi.created_at date,
         c.city,
         oi.channel,
         COUNT(1) orders_count,
         STRING_AGG(distinct oi.customer_id, ', ') unique_customers,
         STRING_AGG(CONCAT(oi.sku, ' : ', oi.qty, ' x ', oi.unit_price, '€'), ', ') items_sold,
         SUM(oi.qty * oi.unit_price) gross_revenue_eur,
         SUM(r.amount) refunds_eur,
         SUM(oi.qty * oi.unit_price) + SUM(r.amount) net_revenue_eur
    from order_items oi
    join customers c on c.customer_id = oi.customer_id
    join refunds r on r.order_id = oi.order_id
   where 1=1
     and oi.payment_status = 'paid'
     and oi.unit_price >= 0
group by oi.order_id, oi.created_at, c.city, oi.channel;


--sortie journalière par DATE(oi.created_at), c.city, oi.channel;
CREATE OR REPLACE VIEW di01.daily_city_sales
AS 
  select TO_CHAR(oi.created_at, 'YYYY-MM-DD') AS date,
         c.city,
         oi.channel,
         COUNT(1) orders_count,
         STRING_AGG(distinct oi.customer_id, ', ') unique_customers,
         STRING_AGG(CONCAT(oi.sku, ' : ', oi.qty, ' x ', oi.unit_price, '€'), ', ') items_sold,
         SUM(oi.qty * oi.unit_price) gross_revenue_eur,
         SUM(r.amount) refunds_eur,
         SUM(oi.qty * oi.unit_price) + SUM(r.amount) net_revenue_eur
    from order_items oi
    join customers c on c.customer_id = oi.customer_id
    join refunds r on r.order_id = oi.order_id
   where 1=1
     and oi.payment_status = 'paid'
     and oi.unit_price >= 0
group by TO_CHAR(oi.created_at, 'YYYY-MM-DD'), c.city, oi.channel;


--sortie journalière par DATE(oi.created_at), c.city, oi.channel;
CREATE OR REPLACE VIEW di01.orders_rejected
AS 
  select *
    from order_items oi
   where 1=1
     and oi.payment_status <> 'paid'
     or  oi.unit_price < 0;