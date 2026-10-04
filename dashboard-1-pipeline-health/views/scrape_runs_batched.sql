-- scrape_runs grouped into real-world batches (>1hr gap = new batch), with raw additive counts for DAX ratios.
drop view if exists scrape_runs_batched;
create view scrape_runs_batched as
with flagged as (
    select
        scraper,
        scraped_at,
        total_received,
        parsed,
        inserted,
        missing_unit,
        outliers,
        filtered_products,
        case
            when scraped_at - lag(scraped_at) over (order by scraped_at) > interval '1 hour'
                then 1
            else 0
        end as is_new_batch
    from scrape_runs
),
batched as (
    select
        *,
        sum(is_new_batch) over (order by scraped_at) as batch_id
    from flagged
)
select
    batch_id,
    scraper,
    min(scraped_at) as batch_started_at,
    date(min(scraped_at)) as date_only,
    sum(total_received) as total_received,
    sum(parsed) as total_parsed,
    sum(inserted) as total_inserted,
    sum(missing_unit) as total_missing_unit,
    sum(outliers) as total_outliers,
    sum(filtered_products) as total_filtered_products
from batched
group by batch_id, scraper;