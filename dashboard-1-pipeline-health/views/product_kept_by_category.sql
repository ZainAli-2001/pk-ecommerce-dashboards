-- Kept products per run, scraper, category (pipeline 2 only) — feeds "kept" side of yield charts.
create or replace view product_kept_by_category as
select
    pp.run_id,
    p.source as scraper,
    p.category,
    min(pp.scraped_at) as scraped_at,
    count(*) as kept_count
from product_prices pp
join products p on pp.product_id = p.id
where pp.pipeline_version = '2.0.0'
group by pp.run_id, p.source, p.category;