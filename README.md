# 📊 Red Snapper Catch Forecasting

## 🔍 Overview
This project aims to forecast Red Snapper catch volumes in the Gulf of Mexico to assist fisheries management in making informed decisions. Accurate forecasts help in maintaining sustainable fishing practices and ensuring the long-term viability of Red Snapper populations.

## 📂 Project Structure
/forecasting_redsnapper ├── data/ # Raw and processed datasets ├── notebooks/ # Jupyter notebooks for EDA & modeling ├── src/ # Python scripts for data processing & modeling ├── models/ # Saved models ├── reports/ # Visualizations, results, and summary ├── README.md # Project documentation ├── requirements.txt # Dependencies ├── .gitignore # Files to ignore

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

## Future Improvements
- Utilize another data transformations method, such as fourier transformation to model dynamic harmonic regression​
- Employ ensemble methods that combine multiple forecasting approaches can improve model performance​
- Use more advanced models, such as Prophet or GARCH
