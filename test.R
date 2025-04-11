# Load libraries and dataset
df <- read.csv("34_years_world_export_import_dataset.csv")

# Clean data
data_clean <- subset(df, Partner.Name != "World" &
                       !is.na(AHS.Weighted.Average....) &
                       !is.na(MFN.Weighted.Average....) &
                       !is.na(Export..US..Thousand.) &
                       !is.na(Import..US..Thousand.))

data_clean$Trade_Balance <- data_clean$Export..US..Thousand. - data_clean$Import..US..Thousand.

# ============================
# 1. Tariff & Trade Visuals
# ============================

# 1. Top 15 Countries by Avg MFN Tariff on U.S.
avg_tariff <- aggregate(MFN.Weighted.Average.... ~ Partner.Name, data_clean, mean)
top15 <- head(avg_tariff[order(-avg_tariff$MFN.Weighted.Average....), ], 15)
barplot(top15$MFN.Weighted.Average....,
        names.arg = top15$Partner.Name,
        las = 2, col = "steelblue", cex.names = 0.8,
        main = "Top 15 Countries by Avg MFN Tariffs on U.S.",
        ylab = "MFN Tariff (%)")

# 2. Top 10 Countries with Negative U.S. Trade Balance
balance <- aggregate(Trade_Balance ~ Partner.Name, data_clean, mean)
worst10 <- head(balance[order(balance$Trade_Balance), ], 10)
barplot(worst10$Trade_Balance,
        names.arg = worst10$Partner.Name,
        las = 2, col = "tomato", cex.names = 0.8,
        main = "Top 10 Countries with Negative U.S. Trade Balance",
        ylab = "Avg Trade Balance (US$ Thousand)")

# 3. U.S. Trade with China
china <- subset(data_clean, Partner.Name == "China")
plot(china$Year, china$Export..US..Thousand., type = "l", col = "blue", lwd = 2,
     main = "U.S. Trade with China Over Time",
     ylab = "US$ Thousand", xlab = "Year", ylim = range(c(china$Export..US..Thousand., china$Import..US..Thousand.)))
lines(china$Year, china$Import..US..Thousand., col = "red", lwd = 2)
legend("topleft", legend = c("Exports", "Imports"), col = c("blue", "red"), lty = 1, bty = "n")

# 4. U.S. Tariffs on China
plot(china$Year, china$AHS.Weighted.Average...., type = "l", col = "darkgreen", lwd = 2, lty = 2,
     main = "Tariffs Imposed by U.S. on China",
     ylab = "Tariff (%)", xlab = "Year", ylim = range(c(china$AHS.Weighted.Average...., china$MFN.Weighted.Average....)))
lines(china$Year, china$MFN.Weighted.Average...., col = "purple", lwd = 2, lty = 3)
legend("topleft", legend = c("AHS", "MFN"), col = c("darkgreen", "purple"), lty = c(2, 3), bty = "n")

# 5. China's Tariffs on U.S.
china_on_us <- subset(data_clean, Partner.Name == "United States")
plot(china_on_us$Year, china_on_us$AHS.Weighted.Average...., type = "l", col = "darkgreen", lwd = 2, lty = 2,
     main = "Tariffs Imposed by China on U.S. Products",
     ylab = "Tariff (%)", xlab = "Year", ylim = range(c(china_on_us$AHS.Weighted.Average...., china_on_us$MFN.Weighted.Average....)))
lines(china_on_us$Year, china_on_us$MFN.Weighted.Average...., col = "purple", lwd = 2, lty = 3)
legend("topleft", legend = c("AHS", "MFN"), col = c("darkgreen", "purple"), lty = c(2, 3), bty = "n")

# 9. U.S. Trade with Canada
canada <- subset(data_clean, Partner.Name == "Canada")
plot(canada$Year, canada$Export..US..Thousand., type = "l", col = "blue", lwd = 2,
     main = "U.S. Trade with Canada",
     ylab = "US$ Thousand", xlab = "Year", ylim = range(c(canada$Export..US..Thousand., canada$Import..US..Thousand.)))
lines(canada$Year, canada$Import..US..Thousand., col = "red", lwd = 2)
legend("topleft", legend = c("Exports", "Imports"), col = c("blue", "red"), lty = 1, bty = "n")

# 10. U.S. Tariffs on Canada
plot(canada$Year, canada$AHS.Weighted.Average...., type = "l", col = "darkgreen", lwd = 2, lty = 2,
     main = "U.S. Tariffs on Canada",
     ylab = "Tariff (%)", xlab = "Year", ylim = range(c(canada$AHS.Weighted.Average...., canada$MFN.Weighted.Average....)))
lines(canada$Year, canada$MFN.Weighted.Average...., col = "purple", lwd = 2, lty = 3)
legend("topleft", legend = c("AHS", "MFN"), col = c("darkgreen", "purple"), lty = c(2, 3), bty = "n")

# ============================
# Hypothesis Testing
# ============================

# 1. P(High Tariff | Negative Balance)
global_mfn_avg <- mean(data_clean$MFN.Weighted.Average...., na.rm = TRUE)
data_clean$Partner_Tariff_Level <- ifelse(data_clean$MFN.Weighted.Average.... > global_mfn_avg, "High", "Low")
data_clean$Balance_Type <- ifelse(data_clean$Trade_Balance < 0, "Negative", "Positive")
tariff_given_neg <- table(data_clean$Balance_Type, data_clean$Partner_Tariff_Level)
prop.table(tariff_given_neg, 1)

# 2. Chi-square test: Tariff level vs. Trade balance
data_clean$Tariff_Category <- ifelse(data_clean$MFN.Weighted.Average.... <= 5, "Low", "High")
data_clean$Trade_Sign <- ifelse(data_clean$Trade_Balance > 0, "Positive", "Negative")
tbl <- table(data_clean$Tariff_Category, data_clean$Trade_Sign)
chisq.test(tbl)

# 3. Permutation test: U.S. tariffs on China vs Canada
china_tariffs <- subset(data_clean, Partner.Name == "China")$MFN.Weighted.Average....
canada_tariffs <- subset(data_clean, Partner.Name == "Canada")$MFN.Weighted.Average....
actual_diff <- mean(china_tariffs) - mean(canada_tariffs)
combined_tariffs <- c(china_tariffs, canada_tariffs)

n_china <- length(china_tariffs)
set.seed(123)
results <- c()
for (i in 1:5000) {
  shuffled <- sample(combined_tariffs)
  group1 <- shuffled[1:n_china]
  group2 <- shuffled[(n_china + 1):length(shuffled)]
  diff <- mean(group1) - mean(group2)
  results <- c(results, diff)
}
p_value <- mean(abs(results) >= abs(actual_diff))
cat("Actual difference in average MFN tariffs (China - Canada):", actual_diff, "\n")
cat("Permutation test p-value:", p_value, "\n")


# 4. Avg U.S. tariff imposed by group (Deficit vs Surplus countries)
data_clean$US_Policy_Level <- ifelse(data_clean$Trade_Balance < 0, "Trade Deficit (They export more)", 
                                     "Trade Surplus or Balanced")
us_tariff_on_group <- aggregate(MFN.Weighted.Average.... ~ US_Policy_Level, data = data_clean, FUN = mean)
barplot(us_tariff_on_group$MFN.Weighted.Average....,
        names.arg = us_tariff_on_group$US_Policy_Level,
        col = c("firebrick", "darkgreen"), las = 1,
        main = "Avg U.S. Tariff Imposed by Trade Balance Group",
        ylab = "MFN Tariff (%)")

# ============================
# 🔎 Product-Level Trade
# ============================

# 📄 Load the Excel file (update the path if needed)
df <- read_excel("DataWeb-Query-Export.xlsx", sheet = "FAS Value", skip = 4)

# 🧼 Clean the data
colnames(df) <- c("Metric", "HS_Code", "Product", "Export_Value_USD")
df <- df %>%
  filter(!is.na(Export_Value_USD)) %>%
  mutate(Export_Value_USD = as.numeric(Export_Value_USD))

# 🔝 Top 15 export products by value
top_exports <- df %>%
  arrange(desc(Export_Value_USD)) %>%
  slice(1:15)

# 📊 Plot (base R version)
barplot(top_exports$Export_Value_USD,
        names.arg = top_exports$Product,
        las = 2, col = "steelblue", cex.names = 0.7,
        main = "Top 15 U.S. Export Products to China (2023)",
        ylab = "Export Value (USD)")