-- Source for Chart 1 (trend line) and the 5 KPI cards (Received/Kept/Rejected/Silent Loss/Outlier).
select
    batch_id,
    scraper,
    batch_started_at,
    date_only,
    total_received,
    total_parsed,
    total_inserted,
    total_missing_unit,
    total_outliers,
    total_filtered_products
from scrape_runs_batched
order by batch_id;