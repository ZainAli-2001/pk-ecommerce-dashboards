# Pakistan E-commerce Price Dashboards

Power BI dashboards over a Supabase (Postgres) database of scraped grocery prices from Daraz and Naheed. Aggregation is done in SQL views; Power BI only reads the results.

| # | Dashboard | Question it answers |
|---|---|---|
| 1 | [Pipeline Health](dashboard-1-pipeline-health) | Is the scraper keeping, rejecting or silently losing products? |
| 2 | [Market Overview](dashboard-2-market-overview) | How are prices, price spread and discounting changing per category? |

Previews (both pages, one file per source): [`daraz-preview.pdf`](daraz-preview.pdf), [`naheed-preview.pdf`](naheed-preview.pdf).

## Repository layout

```
pk-ecommerce-dashboards/
├── dashboard-1-pipeline-health/
│   ├── views/          Supabase view definitions
│   ├── queries/        SQL pasted into Power BI, one file per imported table
│   ├── dax/measures.dax
│   └── color-legend.md
├── dashboard-2-market-overview/
│   └── (same layout)
├── daraz-preview.pdf
├── naheed-preview.pdf
└── readme.md
```

`.pbix` files are git-ignored. Run `git status --ignored` before each commit to confirm.


- **Pre-aggregate in SQL.** Percentiles come from `percentile_cont` in the views, not from DAX or Power Query.
- **Pipeline filter.** Every query touching `product_prices` filters `pipeline_version = '2.0.0'`, because earlier history is not comparable.
- **Source is single-select.** Daraz and Naheed differ in catalog size and price scale, so they are never plotted together.
- **No averaged percentiles.** Daily P25, median and P75 are computed per day and shown as a time series, never averaged into a period figure.
- **Null is not zero.** In the discount matrix a 0% cell (listings scraped, none discounted) is coloured differently from a blank cell (nothing scraped).
- **Slicer scoping.** `source_category` plus a bidirectional `CategoryDim` relationship makes the source and category slicers filter each other. A composite `category|source` key joins them; its case and field order must match on both tables.