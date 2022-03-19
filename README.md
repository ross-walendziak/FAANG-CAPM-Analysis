# FAANG-CAPM-Analysis
Capital Asset Pricing Model (CAPM) as applied to stocks Facebook, Apple, Amazon, Netflix and Google (FAANG)

# Project Overview:
* Soured historical pricing data on FAANG stocks as well as data on market returns and the risk-free-rate for the Sept 2015 through Sept 2021 period.
* Visualized return characteristics of each FAANG stock.
* Estimated beta coefficients to the market for the historical period under consideration.

# Code and Resources Used:
* R Version: 4.1.2
* Packages: tidyverse, lubridate, quantmod, tidyr, dplyr, broom, ggplot2, tibbletime, fpp2, stargazer
* http://www.reproduciblefinance.com/start-here/

# Data Source:
* Historical stock prices were sourced from the quantmod package using the 'yahoo' data source.
* Market returns and risk-free-rate sourced from: http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html

# Data Cleaning:
* Stock prics were converted to monthly return sequences by taking the first observation from each month and calculating the percentage change from T to T-1.
* Return sequence is adjusted from wide to long and back to wide formates to accomodate return calculations.
* Date converted from row names to date object.
* Individual stock return data is merged with market return data on date.

# Exploratory Data Analysis:
* Netflix has the widest distribution of returns whereas Apple as the narrowest distribution of returns.
* All mean returns are positive, centered around a +2.5% monthly return outcome.

![](https://github.com/ross-walendziak/FAANG-CAPM-Analysis/blob/main/Graphics/Stock%20Return%20Distribution.jpeg)
![](https://github.com/ross-walendziak/FAANG-CAPM-Analysis/blob/main/Graphics/Stock%20Return%20Distribution%20(individual).jpeg)
![](https://github.com/ross-walendziak/FAANG-CAPM-Analysis/blob/main/Graphics/Stock%20Return%20Scatter.jpeg)
![](https://github.com/ross-walendziak/FAANG-CAPM-Analysis/blob/main/Graphics/Stock%20Return%20Density%20Curves.jpeg)

# Model Building:
* All beta estimates were completed using simple linear regression.
  * The the dependent variable is the monthly return sequence of the individual stock returns.
  * The explanatory variable is the montly return sequence of market returns minus the applicable risk-free-rate.

# Model Results:
* All alpha estimates are very close to zero and are statistically insignificant.
* Therefore, much of the return attributable to FAANG is attributable to systematic risk exposure as exhibited by Beta estimates.
* Beta estimates were found to be statistically significant at the 1% level, except for Netfix where the Beta estimate was significant at the 5% level.
* Given the estimates - Facebook, Apple, and Amazon common stocks can be characterized as cyclical stocks whereas Netflix can be characterized as a defensive stock.
* Risk in Google is approximatly equal to the market portfolio (Beta nearly 1.0).

![](https://github.com/ross-walendziak/FAANG-CAPM-Analysis/blob/main/Graphics/Model%20Results.png)
