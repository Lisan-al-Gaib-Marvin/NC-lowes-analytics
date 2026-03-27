USE lowes_db;

-- Financial data
CREATE TABLE financials (
	id INT AUTO_INCREMENT PRIMARY KEY,
    fiscal_year INT NOT NULL,
    fiscal_quarter VARCHAR(5) NOT NULL,
    filing_type VARCHAR(10) NOT NULL, -- 10-K or 10-Q
    period_end_date DATE NULL,
    net_sales DECIMAL(12,2) NULL, -- in usd
    cost_of_goods DECIMAL(12,2) NULL, -- in usd
    gross_margin DECIMAL(12,2)  NULL, -- in usd
    operating_income DECIMAL(12,2)  NULL, -- in usd (loss)
    net_income DECIMAL(12,2)  NULL, -- in usd (loss)
    diluted_earn_per_share DECIMAL(8,2) NULL,
    compare_sales_pct DECIMAL(5,2) NULL, -- in %
    store_count INT NULL, -- at the period end
    selling_sqft DECIMAL(8,1) NULL, -- in usd
    capital_expend DECIMAL(10,2) NULL, -- in usd
    inventory DECIMAL(12,2) NULL, -- in usd, inventory turnover
    employee_count INT NULL,
    source_url VARCHAR(500) NULL, -- for proof of information
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_fin (fiscal_year, fiscal_quarter) -- not the same quarter more than once
    )
    ;
    
    
    -- Store Reviews
    CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source VARCHAR(20) NOT NULL, -- what review platform
    store_id_external VARCHAR(100) NULL, -- id for review platform
    store_name VARCHAR(200) NOT NULL,
    store_address VARCHAR(300) NULL,
    city VARCHAR(100) NULL,
    state_code CHAR(2) NULL,
    zip_code VARCHAR(10) NULL,
    latitude DECIMAL(9,6) NULL, -- map visuals
    longitude DECIMAL(9,6) NULL, -- map visuals
    overall_rating DECIMAL(3,1) NULL, -- avg store rating
    review_count INT NULL, -- total of reviews
    review_date DATE NULL, -- date of review
    review_rating TINYINT NULL, -- the star rating scale
    review_text TEXT NULL, -- what the review says
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_state (state_code), -- filtering to NC stores fast
    INDEX idx_city (city) -- filtering to NC city stores fast
)
;

-- Sustainability Metrics table
CREATE TABLE sustainability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_year INT NOT NULL, -- year the data covers
    scope1_emissions DECIMAL(12,2) NULL, -- GHG emissions, metrics C02
    scope2_emissions DECIMAL(12,2) NULL, -- GHG emissions, location-based, metrics C02
    scope2_market DECIMAL(12,2) NULL, -- GHG emissions, market-based, metrics C02
    scope3_emissions DECIMAL(14,2) NULL, -- GHG emissions, metrics C02
    total_energy_mwh DECIMAL(14,2) NULL, -- total energy consumption in MWh
    renewable_energy_pct DECIMAL(5,2) NULL, -- % of energy from renewable sources
    water_consumption_kgal DECIMAL(14,2) NULL, -- water consumption in kgal
    waste_diverted_pct DECIMAL(5,2) NULL, -- % of waste diverted from landfill
    recycling_rate_pct DECIMAL(5,2) NULL,
    solar_locations INT NULL, -- locations with on-site solar
    ev_charger_locations INT NULL, -- stores with ev chargers
    smartway_award TINYINT(1) NULL, -- 1 = smartway award that year
    source_report VARCHAR(300) NULL, -- proof of source
    loaded_at TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_sustain (report_year)
)
;

-- Employment table
CREATE TABLE employment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_year INT NOT NULL,
    data_quarter VARCHAR(5) NOT NULL,
    state_fips CHAR(2) NOT NULL, -- 37 for North Carolina
    county_fips CHAR(3) NULL, -- 3-digit county FIPS code
    county_name VARCHAR(100) NULL,
    naics_code VARCHAR(10) NOT NULL, -- Building Material and Garden Equipment Dealers
    naics_title VARCHAR(200) NULL,
    establishments INT NULL, -- number of establishments
    avg_monthly_employment INT NULL,
    total_quarterly_wages DECIMAL(14,2) NULL,
    avg_weekly_wage DECIMAL(10,2) NULL,
    source_file VARCHAR(200) NULL,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_emp (data_year, data_quarter, state_fips, county_fips, naics_code) -- no duplicates
)
;

-- Stock table
CREATE TABLE stock (
	id INT AUTO_INCREMENT PRIMARY KEY,
    trade_date DATE NOT NULL,
    ticker VARCHAR(10) NOT NULL DEFAULT 'LOW',
    open_price DECIMAL(10,2) NULL,
    high_price DECIMAL(10,2) NULL,
    low_price DECIMAL(10,2) NULL,
    close_price DECIMAL(10,2) NULL,
    adj_close DECIMAL(10,2) NULL, -- accounts for splits and dividends
    volume BIGINT NULL,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_stock (trade_date, ticker)
)
;