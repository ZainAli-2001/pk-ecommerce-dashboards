-- Rejected products per run, scraper, category, reason — finest grain; feeds drop-side and reason-breakdown charts.
create or replace view rejections_by_category_reason as
select
    run_id,
    scraper,
    category,
    reason,
    min(rejected_at) as rejected_at,
    count(*) as drop_count
from scrape_rejections
group by run_id, scraper, category, reason;