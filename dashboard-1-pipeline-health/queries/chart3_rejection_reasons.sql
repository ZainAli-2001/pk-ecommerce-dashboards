-- Source for Chart 3 (Rejection Reasons by Category, 100% stacked bar).
select
    run_id,
    scraper,
    category,
    reason,
    rejected_at as batch_started_at,
    date(rejected_at) as date_only,
    drop_count
from rejections_by_category_reason;