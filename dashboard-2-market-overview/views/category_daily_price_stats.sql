-- Replaces category_daily_median and category_price_distribution.
-- One row per scrape_date x category x source. Powers both the trend
-- line (median) and the IQR chart (p75 - p25) from a single source.
create or replace view category_daily_price_stats as
select
    date_trunc('day', pp.scraped_at)::date as scrape_date,
    p.category,
    p.source,
    percentile_cont(0.25) within group (order by pp.unit_price) as p25,
    percentile_cont(0.5)  within group (order by pp.unit_price) as median_unit_price,
    percentile_cont(0.75) within group (order by pp.unit_price) as p75,
    percentile_cont(0.75) within group (order by pp.unit_price)
        - percentile_cont(0.25) within group (order by pp.unit_price) as iqr,
    count(pp.unit_price) as n_observations
from product_prices pp
join products p on p.id = pp.product_id
where pp.pipeline_version = '2.0.0'
  and pp.unit_price is not null
group by 1, 2, 3;