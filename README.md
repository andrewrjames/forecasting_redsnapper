
## 📊 Data
- **Source**: [Gulf of Mexico Red Snapper 2023 Annual Report](https://noaa-sero.s3.amazonaws.com/drop-files/cs/2023_RS_AnnualReport_FINAL.pdf)
- **Features**: Month, Year, number of red snapper landings, allocation price, vessel price
- **Preprocessing**: Combined red snapper landings, allocation price, and vessel price into one dataframe

## 🔬 Methodology
- **Exploratory Data Analysis (EDA)**:
  - Presence of increasing trend, seasonality, and increasing variance
  - Seasonality peaked in March and December
  - Non-stationary time-series as indicated by significant lags of ACF
  - Moderate correlation between allocation price / vessel price and # of red snapper landings
- **Modeling Approaches**:
  - **Time-Series Models**: Exponential Smoothing (Holtz-Winter Additive, Multiplicative), SARIMA, Time-Series Regression, Regression with ARMA Errors, and VAR
- **Evaluation Metrics**: Mean Absolute Percentage Error (MAPE), Root Mean Squared Error (RMSE)

## 📈 Results
- The SARIMA model achieved the lowest RMSE of **86.8k** and MAPE of **12.93%** on the test set

## 🚀 How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/andrewrjames/forecasting_redsnapper.git
   cd forecasting_redsnapper
