# Lowe's Companies (NYSE: LOW) — Full-Stack Data Science Project

**An end-to-end analytics project analyzing Lowe's Companies across financial performance, customer sentiment, supply chain operations, and sustainability — built with MySQL, Python, Claude API, Tableau, and Power BI.**

> Capstone-style project for MS in Data Science & Business Analytics at UNC Charlotte (2026)

---

## The Problem

Lowe's is a Fortune 50 home improvement retailer headquartered in Mooresville, NC, with $86.3 billion in annual revenue and 1,759 stores nationwide. Despite its scale, the company faces declining operating margins (from 13.4% to 11.8% over three years) and uneven customer satisfaction across its home state of North Carolina.

**This project asks:** What drives customer engagement at Lowe's NC stores, how do financial and operational metrics interact, and where are the opportunities for improvement?

---

## What I Built

This is not a single notebook — it is a complete data pipeline from raw SEC filings to an interactive executive dashboard, covering four business domains:

| Domain | Data Source | What I Analyzed |
|--------|-----------|-----------------|
| **Financial Performance** | SEC EDGAR (10-K, 8-K filings) | Revenue, margins, EPS, inventory turnover across 3 fiscal years |
| **Customer Sentiment** | Google Maps (118 NC stores) | Store ratings, review volume, geographic patterns |
| **Supply Chain / Operations** | SEC filings + derived KPIs | Revenue per store, revenue per sqft, inventory turnover, capex intensity |
| **Sustainability** | Lowe's Corporate Responsibility Reports | Scope 1/2/3 emissions, renewable energy adoption, waste diversion |

---

## Architecture

```
DATA SOURCES              MYSQL                    PYTHON / JUPYTER           REPORTING
─────────────             ──────                   ────────────────           ─────────
SEC EDGAR          ──▶   financials          ──▶   EDA & Visualization  ──▶  Tableau Dashboard
Google Maps        ──▶   reviews             ──▶   Linear Regression    ──▶  Power BI Report
CSR Reports        ──▶   sustainability      ──▶   K-Means Clustering        
                                              ──▶   Claude API (Sonnet 4.6)
                                                    ├─ Feature Selection
                                                    └─ Executive Narrative
```

---

## Key Findings

### Financial Trends (FY2023–FY2025)
- Revenue held steady at ~$84–86B, but **operating margin declined from 13.4% to 11.8%** — a compression of 160 basis points driven by acquisition costs and SGA growth
- Diluted EPS fell from $13.20 to $11.85 despite stable top-line revenue
- Inventory turnover recovered to 3.3x after dipping to 3.2x, suggesting improving supply chain discipline

### Customer Sentiment (118 NC Stores)
- Average Google Maps rating across NC: **4.13 / 5.0** with a tight distribution (3.8–4.6)
- Charlotte Metro leads in both rating (4.20) and review volume, consistent with higher urban foot traffic
- Mountains/Asheville region underperforms at 3.98 average rating — the only region below 4.0

### Modeling Results
- **Linear Regression (R² = -0.38):** Geographic features alone do not predict review volume well. This is an honest finding — it tells us that store-level engagement depends on factors not captured in public data (store size, staffing, local competition). The negative R² is itself informative and guided recommendations for future data collection.
- **K-Means Clustering (K=3, Silhouette=0.38):** Segmented stores into High-Traffic Urban, Mid-Market Suburban, and Low-Traffic Rural groups. Cluster separation was driven primarily by geographic position and review volume.

### AI Integration
- Claude API (Sonnet 4.6) reviewed the dataset schema and flagged a **longitude data quality issue** and **target leakage in the volume_tier feature** — catches I incorporated before finalizing the models
- Claude generated the executive summary used in the Tableau dashboard narrative

---

## Dashboard Preview

### Tableau Executive Dashboard
*KPI cards with YoY trends, NC store map by rating tier, quarterly revenue trend, and ratings by region*

![dashboard_screenshot](https://github.com/user-attachments/assets/62d1fdaa-0434-477f-bcdb-46509367d02b)


### Key Visuals from Analysis

| Financial Trends | Inventory Turnover | Store Ratings by Region |
|:---:|:---:|:---:|
| ![financial_trends_4panel](https://github.com/user-attachments/assets/003ce131-dce8-47ed-927e-e6b50390d599)
| ![inventory_turnover](https://github.com/user-attachments/assets/17657696-138e-4bd1-9fb8-b32c6a54e893)
| ![rating_by_region](https://github.com/user-attachments/assets/bbfbc07f-8e85-4c14-bb7f-3b6ade66351f)

| K-Means Clustering | Rating Distribution | Revenue & Margin |
|:---:|:---:|:---:|
| ![kmeans_clusters](https://github.com/user-attachments/assets/076901aa-ea0d-4959-838e-38ee4ea7ce04)
| ![rating_distribution](https://github.com/user-attachments/assets/9bfb77c4-441e-45e0-bf6b-dbadaaf1137b)
| ![revenue_margin_trend](https://github.com/user-attachments/assets/ca351ed1-955e-4e46-88f4-59aa34cc0f9d)

---


## Tools & Technologies

| Layer | Tools |
|-------|-------|
| **Database** | MySQL 
| **ETL** | Python (mysql.connector, csv) 
| **Analysis** | Pandas, NumPy, Matplotlib, Seaborn — EDA, correlation analysis 
| **Modeling** | scikit-learn — Linear Regression, K-Means, PCA, StandardScaler, silhouette scoring |
| **AI Integration** | Anthropic Claude API (Sonnet 4.6) 
| **Dashboards** | Tableau Desktop (LaDataViz KPI extension)
| **Data Sources** | SEC EDGAR, Google Maps, Lowe's Corporate Responsibility Reports |

---


## What I Learned

This project pushed me to work across the entire data science stack not just modeling, but database design, ETL pipelines, data quality checks, and communicating results through multiple dashboard tools. A few things that stood out:

- **Data collection is the hardest part.** Building the financial dataset meant reading SEC filings line by line and manually extracting numbers from press releases. Building the review dataset meant systematically querying Google Maps for 118 stores across 93 NC cities. Neither was glamorous, but both taught me more about real-world data work than any classroom assignment.

- **A negative R² is a valid finding.** My linear regression returned R² = -0.38, which means the model performs worse than simply predicting the mean. Rather than hiding this, I used it as evidence that store-level engagement depends on factors beyond public geographic data — and that finding directly informed my recommendation to collect store square footage and transaction volume for future work.

- **AI tools are collaborators, not replacements.** Claude API caught a longitude sign error and target leakage issue in my features that I had missed. It also generated an executive summary that I used as a starting point (not a final draft) for the Tableau dashboard narrative. The value was in the back-and-forth — sending data summaries and getting specific, actionable feedback.

---

## Contact

**Marvin Pearson** — MS Data Science & Business Analytics, UNC Charlotte (Class of 2027)
- LinkedIn: [linkedin.com/in/marvin-pearson](https://linkedin.com/in/marvin-pearson)
- GitHub: [github.com/Lisan-al-Gaib-Marvin](https://github.com/Lisan-al-Gaib-Marvin)
- Email: mpears30@charlotte.edu
