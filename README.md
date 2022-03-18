# FAANG-CAPM-Analysis
Capital Asset Pricing Model (CAPM) as applied to stocks Facebook, Apple, Amazon, Netflix and Google (FAANG)

# Project Overview:
* Soured historical pricing data on FAANG stocks as well as data on market returns and the risk-free-rate for the Sept 2015 through Sept 2021 period.
* Visualized return charactericts of each FANG stock.
* Estimated beta coefficients to the market for the historical period under consideration.

# Code and Resources Used:
* R Version: 4.1.2
* Packages: tidyverse, lubridate, quantmod, tidyr, dplyr, broom, ggplot2, tibbletime, fpp2, stargazer
* http://www.reproduciblefinance.com/start-here/

# Data Source:
* Historical stock prices sourced from the quantmod package using the 'yahoo' data source
* Market returns and risk-free-rate sourced from: http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html

# Data Cleaning:
* Stock prics were converted to monthly return sequences by taking the first observation from each month and calculating the percentage change from T to T-1.
* Return sequence is adjusted from wide to long and back to wide formates to accomodate return calculations.
* Date converted from row names to date object.
* Stock return data merged with market return data on date.

# Exploratory Data Analysis:

# Model Building:


# Model Results:
