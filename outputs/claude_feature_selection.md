# Claude API — Feature Selection Recommendations

**Model:** claude-sonnet-4-6
**Date:** 2026-03-26

## Prompt Summary
Sent dataset schema, summary stats, and business goal.

## Response

# Regression Model Advice: Lowe's NC Review Count Prediction

## 1. Features to Include

| Feature | Reason |
|---|---|
| `overall_rating` | Direct signal — rating visibility likely drives review behavior |
| `nc_region` | Captures population density differences (Charlotte Metro vs. Eastern NC) |
| `latitude` | Geographic proxy for urban/rural split within NC |
| `rating_tier` | Encoded version of rating with business meaning |

> **Note:** Use `nc_region` OR `latitude`/`longitude` — not both, to avoid redundancy.

---

## 2. Features to Drop

| Feature | Reason |
|---|---|
| `id`, `store_number` | Arbitrary identifiers — no predictive signal |
| `store_name`, `store_address` | Too specific, causes overfitting with 118 rows |
| `state_code` | Zero variance — all rows are NC |
| `zip_code`, `city` | Too granular for 118 rows; use `nc_region` instead |
| `longitude` | **Data quality issue** — max is +80.1 (positive = wrong hemisphere), std of 25 is suspicious. Flag and investigate before using |
| `volume_tier` | **Target leakage** — it's derived directly from `review_count` |

---

## 3. Feature Engineering Ideas

**1. `is_urban_region`** (Binary flag)
```python
urban_regions = ['Charlotte Metro', 'Triangle', 'Triad']
df['is_urban'] = df['nc_region'].isin(urban_regions).astype(int)
```
*Why:* Urban stores likely see more foot traffic and reviews.

---

**2. `rating_x_region_avg`** (Interaction feature)
```python
df['rating_x_urban'] = df['overall_rating'] * df['is_urban']
```
*Why:* A high rating in a high-traffic area may have a compounded effect on engagement.

---

**3. `rating_deviation`** (How far a store deviates from the mean)
```python
df['rating_deviation'] = df['overall_rating'] - df['overall_rating'].mean()
```
*Why:* Extreme ratings (positive or negative) may drive more review motivation than middling ones.

---

## 4. Recommended Model: Linear Regression → Random Forest

### Start Here: Linear Regression
```python
from sklearn.linear_model import LinearRegression
```
✅ Interpretable, easy to debug, good baseline
✅ Works fine with small datasets (118 rows)
✅ Helps you understand feature coefficients

### Then Try: Random Forest Regressor
```python
from sklearn.ensemble import RandomForestRegressor
model = RandomForestRegressor(n_estimators=100, max_depth=4, random_state=42)
```
✅ Handles non-linearity and categorical interactions automatically
✅ Built-in feature importance ranking
⚠️ With only 118 rows, **keep `max_depth` low (3-5)** to avoid overfitting

---

## Key Warnings for Your Dataset

```
⚠️ Small dataset (118 rows) → Use cross-validation, not a single train/test split
⚠️ Longitude outlier (+80.1) → Likely a data entry error, investigate immediately  
⚠️ volume_tier = target leakage → Never use as a feature
⚠️ review_count range is wide (52–3016) → Check if log-transforming helps normality
```

```python
# Quick check: should you log-transform the target?
import numpy as np
df['log_review_count'] = np.log(df['review_count'])
df['log_review_count'].hist()  # Compare to df['review_count'].hist()
```