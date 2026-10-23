-- source_category: valid source/category pairs from the last 90 days of pipeline 2.0.0 data, used to scope the Power BI slicers
create or replace view source_category as
select distinct
    p.source,
    p.category
from product_prices pp
join products p on p.id = pp.product_id
where pp.pipeline_version = '2.0.0'
  and pp.scraped_at >= current_date - interval '90 days';