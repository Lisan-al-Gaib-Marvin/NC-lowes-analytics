USE lowes_db;

-- Drop and recreate so this script is re-runnable
DROP TABLE IF EXISTS clean_financials;

CREATE TABLE clean_financials AS
SELECT
    id,
    fiscal_year,
    fiscal_quarter,
    filing_type,
    period_end_date,

    -- ── Core income statement ─────────────────────────────
    net_sales_mm,
    cost_of_goods_mm,
    gross_margin_mm,
    operating_income_mm,
    net_income_mm,
    diluted_earn_per_share,
    compare_sales_pct,

    -- ── Operations ────────────────────────────────────────
    store_count,
    selling_sqft_mm,
    capex_mm,
    inventory_mm,
    employee_count,

    -- ── Derived KPIs (the real analytical value) ──────────

    -- Gross margin %: how much of every sales dollar is left after COGS
    -- Typical for Lowe's: ~33%. A drop signals pricing pressure or mix shift.
    ROUND(gross_margin_mm / NULLIF(net_sales_mm, 0) * 100, 2)
        AS gross_margin_pct,

    -- Operating margin %: how much profit the core business generates
    -- Typical: ~12%. This is the metric Wall Street watches closest.
    ROUND(operating_income_mm / NULLIF(net_sales_mm, 0) * 100, 2)
        AS operating_margin_pct,

    -- Net profit margin: bottom-line profitability
    ROUND(net_income_mm / NULLIF(net_sales_mm, 0) * 100, 2)
        AS net_margin_pct,

    -- Revenue per store ($MM): measures how productive each location is
    ROUND(net_sales_mm / NULLIF(store_count, 0), 2)
        AS revenue_per_store_mm,

    -- Revenue per square foot ($): the #1 retail productivity metric
    -- Lowe's reports sqft in millions, so multiply to get actual sqft
    ROUND(net_sales_mm * 1000000 / NULLIF(selling_sqft_mm * 1000000, 0), 2)
        AS revenue_per_sqft,

    -- Inventory turnover: how fast inventory converts to sales
    -- Higher = more efficient supply chain. Lowe's is typically ~3-4x
    ROUND(cost_of_goods_mm / NULLIF(inventory_mm, 0), 2)
        AS inventory_turnover,

    -- Capex intensity: what % of revenue is reinvested in the business
    ROUND(capex_mm / NULLIF(net_sales_mm, 0) * 100, 2)
        AS capex_intensity_pct,

    -- Revenue per employee ($K): labor productivity measure
    ROUND(net_sales_mm * 1000 / NULLIF(employee_count, 0), 1)
        AS revenue_per_employee_k,

    source_url

FROM financials
WHERE net_sales_mm IS NOT NULL;  -- Skip rows with no revenue


-- Check if works
SELECT fiscal_year, fiscal_quarter,
       net_sales_mm, gross_margin_pct, operating_margin_pct,
       revenue_per_store_mm, inventory_turnover
FROM clean_financials
ORDER BY fiscal_year DESC, fiscal_quarter;


-- cleaning the reviews
DROP TABLE IF EXISTS clean_reviews;

CREATE TABLE clean_reviews AS
SELECT
    id,
    store_number,
    store_name,
    store_address,
    city,
    state_code,
    zip_code,
    latitude,
    longitude,
    overall_rating,
    review_count,

    -- ── Derived fields ────────────────────────────────────

    -- Rating tier: bucket stores into performance groups
    -- This is useful for color-coding maps and bar charts
    CASE
        WHEN overall_rating >= 4.3 THEN 'Above Average'
        WHEN overall_rating >= 4.0 THEN 'Average'
        ELSE 'Below Average'
    END AS rating_tier,

    -- Review volume tier: high-traffic vs. low-traffic stores
    CASE
        WHEN review_count >= 2500 THEN 'High Volume'
        WHEN review_count >= 1500 THEN 'Medium Volume'
        ELSE 'Low Volume'
    END AS volume_tier,

    -- NC region: group cities into geographic regions for analysis
    CASE
        WHEN city IN ('Charlotte','Huntersville','Mooresville','Concord',
                      'Kannapolis','Gastonia','Belmont','Indian Trail',
                      'Matthews','Monroe','Waxhaw','Denver','Lincolnton',
                      'Statesville','Troutman','Albemarle','Shelby') THEN 'Charlotte Metro'
        WHEN city IN ('Raleigh','Durham','Chapel Hill','Cary','Apex',
                      'Garner','Wake Forest','Knightdale','Holly Springs',
                      'Pittsboro','Mebane','Burlington','Sanford','Smithfield') THEN 'Triangle'
        WHEN city IN ('Greensboro','Winston-Salem','High Point','Kernersville',
                      'Lexington','Asheboro','Reidsville','Mayodan',
                      'Mocksville','Salisbury') THEN 'Triad'
        WHEN city IN ('Fayetteville','Hope Mills','Erwin','Clinton',
                      'Lumberton','Laurinburg','Southern Pines',
                      'Rockingham') THEN 'Sandhills / Fayetteville'
        WHEN city IN ('Wilmington','Leland','Hampstead','Shallotte',
                      'Southport','Jacksonville','Cape Carteret',
                      'Morehead City','New Bern') THEN 'Coastal'
        WHEN city IN ('Asheville','Arden','Hendersonville','Brevard',
                      'Waynesville','Weaverville','Sylva','Franklin',
                      'Marion','Morganton','Forest City') THEN 'Mountains / Asheville'
        WHEN city IN ('Hickory','Lenoir','Boone','Banner Elk',
                      'Elkin','North Wilkesboro','Wilkesboro',
                      'W. Jefferson','Mount Airy') THEN 'Foothills / High Country'
        WHEN city IN ('Greenville','Winterville','Rocky Mount','Wilson',
                      'Goldsboro','Kinston','Tarboro','New Bern',
                      'Washington','Elizabeth City','Kill Devil Hills',
                      'Roanoke Rapids','Henderson','Roxboro',
                      'Murphy','Whiteville') THEN 'Eastern NC'
        ELSE 'Other NC'
    END AS nc_region

FROM reviews;

-- Add indexes for common queries
ALTER TABLE clean_reviews ADD INDEX idx_region (nc_region);
ALTER TABLE clean_reviews ADD INDEX idx_tier (rating_tier);


SELECT 'financials' AS table_name, COUNT(*) AS row_count FROM financials
UNION ALL
SELECT 'clean_financials', COUNT(*) FROM clean_financials
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'clean_reviews', COUNT(*) FROM clean_reviews;