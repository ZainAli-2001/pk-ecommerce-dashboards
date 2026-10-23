-- Daraz-only. A row is "discounted" iff original_price is populated
-- (per confirmed scrape behavior: no % tag -> original_price null,
-- sale_price = final_price). No NULLIF needed: null here is a real signal,
-- not missing data.
create view category_weekly_discounts as
select
    date_trunc('week', pp.scraped_at)::date as week_start,
    p.category,
    count(*) as total_listings,
    count(*) filter (where pp.original_price is not null) as discounted_listings,
    round(
        100.0 * count(*) filter (where pp.original_price is not null)
        / count(*),
        2
    ) as discounted_listing_pct,
    percentile_cont(0.5) within group (order by
        100.0 * (pp.original_price - pp.final_price) / pp.original_price
    ) filter (where pp.original_price is not null) as median_discount_pct
from product_prices pp
join products p on p.id = pp.product_id
where pp.pipeline_version = '2.0.0'
  and p.source = 'daraz'
group by 1, 2;
