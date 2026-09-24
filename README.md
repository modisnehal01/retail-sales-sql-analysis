# Retail Sales & Revenue Analysis | SQL Portfolio 01

**SQL (SQLite) • Data modelling • KPI reporting • CTEs and window functions**

A reproducible portfolio project analysing **synthetic retail order data for January–May of 2024, 2025 and 2026**. The goal is to understand how completed-order revenue and profit changed, which products and customers contributed most, and how excluding cancelled orders changes financial reporting.

> **Dataset notice:** All customers, prices and transactions are invented for learning and portfolio demonstration; these are not real employer or client results. Comparisons are **January–May year-to-date periods**, not full calendar years.

## Business questions

- How did completed-order revenue, profit and profit margin change across the three periods?
- How much did revenue and profit change year over year?
- Which products, countries and customers contributed most to sales and profit?
- What do monthly sales patterns show?
- Were cancelled orders excluded, and are the relational records consistent?

## Dataset and data model

| Table | Rows | Role |
|---|---:|---|
| `customers` | 6 | Customer name, country and signup date |
| `products` | 6 | Product, category and reference cost |
| `orders` | 18 | Order date, customer and completion status |
| `order_items` | 24 | Product quantities, selling prices and unit-cost snapshots |

**Relationships:** `customers` 1→many `orders`; `orders` 1→many `order_items`; `products` 1→many `order_items`. Each year's five completed orders are dated January–May. A sixth June order per year is cancelled.

**KPI definitions:** Revenue = `SUM(quantity × unit_price)` for completed orders. Profit = `SUM(quantity × (unit_price − unit_cost))`. Profit margin = `100 × total profit / total revenue`. Use `order_items.unit_cost` as the **transaction-level cost snapshot**, not the reference `products.standard_cost`.

## Key results

| Period (Jan–May) | Completed orders | Revenue | Profit | Profit margin |
|---|---:|---:|---:|---:|
| 2024 | 5 | £2,256 | £542 | 24.02% |
| 2025 | 5 | £2,440 | £726 | 29.75% |
| 2026 | 5 | £3,050 | £1,166 | 38.23% |

![Revenue and profit chart](charts/yearly_revenue_profit.png)

**Selected observations**

- January–May 2025 revenue was **8.16%** above the same period in 2024; 2026 revenue was **25.00%** above 2025.
- Profit margin increased from **24.02%** in 2024 to **38.23%** in 2026. This small synthetic sample does not establish *why* profitability improved; pricing, costs and product mix would merit investigation.
- **Laptop** had the highest product revenue (£5,050) and profit (£1,450) across all three periods, indicating substantial product concentration in this example.
- The **UK** accounted for £6,036 of £7,746 completed-order revenue, or about **77.9%**, indicating geographic concentration in the sample.
- **15** of 18 orders were completed; **3** were cancelled and excluded from revenue and profit KPIs.

## SQL techniques demonstrated

`INNER JOIN`, primary and foreign keys, `COUNT(DISTINCT)`, `GROUP BY`, `SUM`, `ROUND`, `NULLIF`, `strftime`, CTEs, `LAG() OVER`, conditional filtering, descending rankings and orphan-record checks.

## Project files

```text
retail-sales-sql-analysis/
├── README.md
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   └── 03_business_analysis.sql
├── results/
│   ├── 01_yearly_performance.csv
│   ├── 02_yoy_growth.csv
│   ├── 03_monthly_performance.csv
│   ├── 04_product_performance.csv
│   ├── 05_country_performance.csv
│   ├── 06_customer_performance.csv
│   ├── 07_category_performance.csv
│   ├── 08_order_status.csv
│   └── 09_data_quality.csv
└── charts/
    └── yearly_revenue_profit.png
```

## How to reproduce

1. Open a **fresh SQLite database** in [SQLite Online](https://sqliteonline.com/) or in a local SQLite client. Do not run the table creation script over a populated database.
2. Run [`01_create_tables.sql`](sql/01_create_tables.sql) once.
3. Run [`02_insert_data.sql`](sql/02_insert_data.sql) once.
4. Run the nine queries in [`03_business_analysis.sql`](sql/03_business_analysis.sql) **individually**; each query is numbered and ends with `;`. Some web-based SQLite editors display only the last result if all queries are run together.
5. Compare the results with the exported CSV files in [`results/`](results/). The ninth query checks table row counts, missing foreign-key matches and invalid line items.

A local SQLite CLI alternative is: `sqlite3 retail_sales.db ".read sql/01_create_tables.sql"`, followed by the same command with `02_insert_data.sql`. Then run individual analysis queries in the SQLite client.

## Interpretation and limitations

This is a **small, deliberately constructed, synthetic dataset**, intended to demonstrate SQL methods rather than statistical forecasting. There is only one order per month per customer group in several periods, and customer/product coverage is limited. Do not extrapolate findings to a real retailer or describe the results as full-year performance.

**Potential business follow-up:** Investigate drivers of higher profit margins and product concentration using a larger set of transactions, returns, discounts, shipping costs and supplier cost changes. Those variables are not included here, so the project does not claim to establish their effects.
