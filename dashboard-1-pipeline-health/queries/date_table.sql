-- Standalone date dimension, range derived from live data — relates to scraper table independently, avoiding relationship ambiguity.
select
    generate_series(
        (select min(scraped_at)::date from scrape_runs),
        (select max(scraped_at)::date from scrape_runs),
        interval '1 day'
    )::date as date;