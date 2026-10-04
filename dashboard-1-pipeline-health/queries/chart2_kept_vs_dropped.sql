-- Source for Chart 2 (Kept vs. Dropped by Category, 100% stacked bar).
with drop_totals as (
    select
        run_id,
        scraper,
        category,
        min(rejected_at) as rejected_at,
        sum(drop_count) as drop_count
    from rejections_by_category_reason
    group by run_id, scraper, category
)
select
    coalesce(k.run_id, d.run_id) as run_id,
    coalesce(k.scraper, d.scraper) as scraper,
    coalesce(k.category, d.category) as category,
    coalesce(k.scraped_at, d.rejected_at) as batch_started_at,
    date(coalesce(k.scraped_at, d.rejected_at)) as date_only,
    coalesce(k.kept_count, 0) as kept_count,
    coalesce(d.drop_count, 0) as drop_count,
    k.kept_count::numeric / nullif(d.drop_count, 0) as kept_to_drop_ratio
from product_kept_by_category k
full join drop_totals d
    on k.run_id = d.run_id
   and k.scraper = d.scraper
   and k.category = d.category;