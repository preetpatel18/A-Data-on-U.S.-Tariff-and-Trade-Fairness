# 📊 U.S. Tariff Exposure and Trade Fairness

**Author:** Preet Patel  
**Course:** Data 101  
**Professor:** Dr. Tomasz Imielinski

---

## 🔍 Overview

This project investigates whether the United States is at a disadvantage in global trade due to asymmetric tariff applications. It uses 34 years (1989–2023) of bilateral trade data to analyze the relationship between trade balances and tariff rates, focusing on key partners like **China** and **Canada**.

We define **Fair Trade** as:  
> A trade relationship where **tariffs are reciprocal**, i.e., both countries impose similar average tariff rates.

All data visualization and analysis were done in **base R**, ensuring transparency and reproducibility.

---

## 📁 Datasets Used

- `34_years_world_export_import_dataset.csv` from [Kaggle](https://www.kaggle.com/datasets/muhammadtalhaawan/world-export-and-import-dataset)
- `DataWeb-Query-Export.xlsx` from [USITC DataWeb](https://dataweb.usitc.gov/trade/search/Export/HTS)

---

## 📈 Key Visualizations

- Top 15 countries by average **MFN tariff** on U.S.
- Top 10 U.S. **trade deficit** partners
- Yearly **U.S.–China** and **U.S.–Canada** trade trends
- AHS and MFN **tariff timelines**
- Top 15 **export products** to China (2023)

---

## 🔬 Statistical Tests Performed

### 1. **Bayesian Inference**
> P(High Tariff | Negative Trade Balance)  
Countries with U.S. trade deficits are **more likely** to impose above-average tariffs.

### 2. **Permutation Test**
> H₀: U.S. applies the same MFN tariff to China and Canada  
p-value = **0.2698** → Fail to reject H₀ (no significant difference)

### 3. **Chi-Square Test**
> H₀: Trade balance is independent of tariff level  
p-value < **2.2e-16** → Reject H₀ (significant association)

---

## 🔎 Product-Level Insights

The top U.S. exports to China (2023) include:
- Mineral fuels and oils (e.g., crude oil, petroleum)
- Soybeans
- Aircraft engines & mechanical parts

These products are highly valuable but **vulnerable to retaliatory tariffs**, impacting the U.S. trade position.

---

## 📂 Repository Structure

```plaintext
├── README.md
├── 34_years_world_export_import_dataset.csv
├── DataWeb-Query-Export.xlsx
├── Tarifs on USA - Data 101.pdf
└── test.R                 # Full analysis script with plots + statistical tests
```

---

## 🧠 Conclusion

This analysis confirms that the U.S. often faces non-reciprocal tariff rates, especially with countries like China. These imbalances contribute to persistent trade deficits and suggest a need for tariff reform and revised trade agreements.
