library(dplyr)
library(fpp)
library(forecast)
library(tidyverse)

# Load red_snapper data
load("red_snapper.rda")

red_snapper

# Transform red_snapper into time-series object
rs_ts = ts(red_snapper, frequency = 12, start = c(2007, 1))

# Plot Monthly Number of Red Snapper Harvested in Gulf of Mexico
# Data shows increasing trend with seasonality. Variance also looks increasing overtime
autoplot(rs_ts[, 'landings']) + labs(title = 'Monthly Number of Red Snapper Harvested in Gulf of Mexico between 2007-2023',
                                     y = '# of Landings')

test = ts(red_snapper, frequency = 12, start = c(2007, 1), end = c(2009, 12))
test
autoplot(test[, 'landings']) + labs(title = 'Monthly Number of Red Snapper Harvested in Gulf of Mexico between 2007-2023',
                                     y = '# of Landings')

# Decompose TS into trend, seasonality
# Since variance looks increasing overtime, Holt-Winter Multiplicative Method should be considered
plot(decompose(landing_ts, type = 'multiplicative'))

plot(decompose(landing_ts, type = 'additive'))


# Plot Monthly Allocation and Vessel Price in Gulf of Mexico
autoplot(rs_ts[, c('allocation_price', 'vessel_price')]) + labs(title = 'Monthly Allocation and Vessel Price in Gulf of Mexico between 2007-2023',
                                                                y = 'Price')

# Filter landing column only
landing_ts = rs_ts[, 'landings']

# Show time-series data along with ACF and PACF
# ACF shows significant lags decaying slowly, indicating non stationarity
tsdisplay(landing_ts)

# Split data into train test split

train_df = window(landing_ts, frequency = 12, start = c(2007, 1), end = c(2022, 12))
test_df = window(landing_ts, frequency = 12, start = c(2023, 1))

# EXPONENTIAL SMOOTHING METHOD

# lambda = BoxCox.lambda(train_df)
lambda = BoxCox.lambda(train_df)
lambda
# train_df_boxcox = BoxCox(train_df, lambda = lambda)

# Holts-Winter Additive
hw_additive = hw(train_df, h = 12, seasonal = "additive", level = c(80, 95))
forecast_hw_additive = hw_additive$mean
summary(hw_additive)

# Holts-Winter Multiplicative
hw_multiplicative = hw(train_df, h = 12, seasonal = 'multiplicative', level = c(80, 95))
forecast_hw_multiplicative = hw_multiplicative$mean
summary(hw_multiplicative)

# Holts-Winter Additive with Damping
hw_additive_damping = hw(train_df, h = 12, seasonal = "additive", damped = TRUE, lambda = lambda, level = c(80, 95))
forecast_hw_additive_damping = hw_additive_damping$mean
summary(hw_additive_damping)


# Holts-Winter Multiplicative with Damping
hw_multiplicative_damping = hw(train_df, h = 12, seasonal = "multiplicative", lambda = lambda, damped = TRUE, level = c(80, 95))
forecast_hw_multiplicative_damping = hw_multiplicative_damping$mean
summary(hw_multiplicative_damping)


# Exponential Trend Holts-Winter Multiplicative with Damping
hw_exp_multiplicative_damping = hw(train_df, h = 12, seasonal = "multiplicative", lambda = lambda, damped = TRUE, exponential = TRUE, level = c(80, 95))
forecast_hw_exp_multiplicative_damping = hw_exp_multiplicative_damping$mean
summary(hw_exp_multiplicative_damping)


# Seasonal Naive Method
snaive = snaive(train_df, h = 12)
forecast_snaive = snaive$mean

# Check accuracy agains test set
accuracy_hw_additive = accuracy(forecast_hw_additive, test_df)
accuracy_hw_multiplicative = accuracy(forecast_hw_multiplicative, test_df)
accuracy_hw_additive_damping = accuracy(forecast_hw_additive_damping, test_df)
accuracy_hw_multiplicative_damping = accuracy(forecast_hw_multiplicative_damping, test_df)
accuracy_hw_exp_multiplicative_damping = accuracy(forecast_hw_exp_multiplicative_damping, test_df)
accuracy_snaive = accuracy(forecast_snaive, test_df)

result = as.data.frame(rbind(accuracy_hw_additive, 
                    accuracy_hw_multiplicative, 
                    accuracy_hw_additive_damping, 
                    accuracy_hw_multiplicative_damping,
                    accuracy_hw_exp_multiplicative_damping, 
                    accuracy_snaive))

rownames(result) = c('Holts-Winter Additive', 'Holts-Winter Multiplicative', 'Holts-Winter Additive with Damping',
                     'Holts-Winter Multiplicative with Damping', 'Exponential Trend Holts-Winter Multiplicative with Damping',
                     'Seasonal Naive')


result

# Model Diagnostic
checkresiduals(hw_multiplicative_damping)


# ARIMA METHOD
tsdisplay(train_df)
lambda = BoxCox.lambda(train_df)
train_df_boxcox = BoxCox(train_df, lambda = lambda)

train_df_boxcox
autoplot(train_df_boxcox) + labs(title = 'Monthly Number of Red Snapper Harvested in Gulf of Mexico between 2007-2023',
                                     y = '# of Landings')

train_df_boxcox_diff = diff(train_df_boxcox, lag = 6)
tsdisplay(train_df_boxcox_diff)

kpss.test(train_df_boxcox_diff)

auto_arima_model = auto.arima(train_df, lambda = lambda, d = 1, D = 1, seasonal = TRUE)
auto_arima_model_2 = auto.arima(train_df, lambda = lambda, seasonal = TRUE)

auto_arima_model
auto_arima_model_2

checkresiduals(auto_arima_model)

auto_arima_model_forecast = forecast(auto_arima_model, h = 12)
forecast_sarima = auto_arima_model_forecast$mean

accuracy(forecast_sarima, test_df)

# TIME-SERIES REGRESSION

log_rs_ts = log(rs_ts)
log_rs_ts
cor(rs_ts)
cor(log_rs_ts)

train_df_all = window(rs_ts, frequency = 12, start = c(2007, 1), end = c(2022, 12))
test_df_all = window(rs_ts, frequency = 12, start = c(2023, 1))

autoplot(train_df_all[, c('landings', 'allocation_price', 'vessel_price')]) + labs(title = 'Monthly Number of Red Snapper Harvested in Gulf of Mexico between 2007-2023',
                                     y = '# of Landings')


autoplot(train_df_all[, 'allocation_price']) + labs(title = 'Monthly Allocation Price in Gulf of Mexico between 2007-2023', 
                                                    y = 'Allocation Price')

autoplot(train_df_all[, 'vessel_price']) + labs(title = 'Monthly Vessel Price in Gulf of Mexico between 2007-2023', 
                                                    y = 'Vessel Price')

linear_model = tslm(train_df_all[, 'landings'] ~ train_df_all[, 'allocation_price'] + train_df_all[, 'vessel_price'])
linear_model

summary(linear_model)
checkresiduals(linear_model)

# REGRESSION WITH ARMA ERROR

armax_all = auto.arima(train_df_all[, 'landings'], xreg = train_df_all[, 'allocation_price'], D = 1, lambda = lambda)
armax_all

armax_ves = auto.arima(train_df_all[, 'landings'], xreg = train_df_all[, 'vessel_price'], D = 1, lambda = lambda)
armax_ves

armax_all_ves = auto.arima(train_df_all[, 'landings'], xreg = train_df_all[, c('allocation_price','vessel_price')], D = 1, lambda = lambda)
armax_all_ves

checkresiduals(armax_all)

checkresiduals(armax_ves)
checkresiduals(armax_all_ves)

naive_vessel_forecast = naive(train_df_all[, 'vessel_price'], h = 12)

armax_ves_forecast = forecast(armax_ves, xreg = naive_vessel_forecast$mean, h = 12)
accuracy(armax_ves_forecast, test_df)

# VAR
library(vars)

train_df_all

var_model = VAR(train_df_all[, c('landings', 'allocation_price', 'vessel_price')], type = 'both', season = 12, p = 3 )
summary(var_model)

acf(residuals(var_model))

var_forecast = predict(var_model, n.ahead = 12)
var_forecast$fcst$landings[, 1]

accuracy(var_forecast$fcst$landings[, 1], test_df)

# SPECTRAL
library(TSA)
periodogram = periodogram(train_df)

periodogram$freq

Tperiod = (1 / periodogram$freq) / 12

Tperiod
192/12

96/12

64/12

# TBATS
library(fpp2)
tbats_model = tbats(train_df)
print(tbats_model)

forecast_tbats = forecast(tbats_model, h = 12)
accuracy(forecast_tbats$mean, test_df)