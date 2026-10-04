-- Standalone scraper dimension — relates to each fact table independently, same pattern as date_table.sql.
select distinct scraper from scrape_runs_batched;