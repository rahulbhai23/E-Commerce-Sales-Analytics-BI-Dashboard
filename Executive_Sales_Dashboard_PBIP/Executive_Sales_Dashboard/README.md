# Executive Sales Dashboard - Power BI Project (PBIP)

Built from your 5 CSV files and your dashboard_preview.html.

## 1. Open it (5 steps)
1. Unzip this folder anywhere.
2. Put your 5 CSV files (dim_customer, dim_date, dim_product, fact_orders, fact_sales) together in ONE folder, e.g. `C:\PowerBI\Data`.
3. In Power BI Desktop: File > Options > Preview features, turn on
   "Power BI Project (.pbip) save option" and "Store semantic model using TMDL format" (if they appear), then restart.
4. Open `Executive_Sales_Dashboard.pbip`.
5. Home > Transform data > Edit parameters. Set **DataFolder** to your folder (no trailing slash), click OK, then Close & Apply.
   The model loads about 400K sales rows, so the first refresh takes a minute or two.

Optional: File > Save as to get a normal .pbix.

## 2. What is inside
Tables
- dim_date (marked as date table, `date` is a real Date column; extra columns year_month and day_of_week_number)
- dim_customer, dim_product
- fact_sales (line items), fact_orders (one row per order)
- _Measures (67 measures, in display folders 1 Core ... 6 Formatting Helpers)

Relationships (all many-to-one, single direction)
- fact_sales[order_date]  -> dim_date[date]
- fact_orders[order_date] -> dim_date[date]
- fact_sales[customer_id] -> dim_customer[customer_id]
- fact_orders[customer_id]-> dim_customer[customer_id]
- fact_sales[product_id]  -> dim_product[product_id]
fact_sales and fact_orders are deliberately NOT linked to each other, so dates and customers filter both without ambiguity.

## 3. Fixes made to the original DAX
- `order_status`, `delivery_status`, `payment_status` live in **fact_sales** in your CSVs, so Returned, Cancelled, Delivered, On-Time and Paid measures now use fact_sales (this was the "column cannot be found" error).
- Text dates are converted to real dates in Power Query.
- The stray `*` at the end of the old query is gone (measures are saved in the model, no query needed).
- Prior-year measures return blank unless exactly one year is selected (same as your preview, which shows a dash for "All years").
- Prior-year labels show a dash (not "up 0.0%") when there is no prior-year data.
- Rank measures use ISINSCOPE so total rows do not show rank 1.
- Added: Top 8 Subcategory, Top 8 Marketing, Top 6 Country, Customers/AOV/Margin prior-year and label measures.

## 4. Checked against your data
Using your CSVs, the same logic reproduces the preview numbers: sales 192,357,753.80, profit 82,679,957.72, 138,116 orders,
24,911 customers, 842,179 units, margin 43.0%, return rate 6.85%, cancel rate 6.08%, on-time 85.13%, rating 3.68.

## 5. Notes
- This project was generated without Power BI Desktop, so it has not been opened in Desktop. If a visual shows an error or
  looks different, the model and measures are still correct: click the visual and re-pick its fields from `_Measures`.
- `docs/layout_wireframe.png` shows the page layout; `docs/Measures_reference.dax` lists all measures for reference.
