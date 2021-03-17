# Online_Advertising_Cost_and_Performance_Analysis
This project was from 2019.

I extracted two datasets (37K observations and 22 features in total) about advertising spending and performance for companies from all industries (e.g., retail, Multi-Category advertisers, insurance, Computers & Technology) in 2018 and 2019 from a licensed source (Comscore).

The codes include cleaning, validating and exploratory analysis about advertising spending and performance.

_Section 1:_

 - Get the descriptive statistics of the top 10 categories with highest average display ad impressions(the number of times the advertisement are exposed to consumers).
 - Explore more about the insurance category and get the statistics about the top 5 insurance companies with the highest impressions.

_Section 2:_

 - Use unique visitors as the criteria to see which insurance companies perform best in getting volumn to their websites.
 - Create a new variable 'value', reflecting the number of unique visitors a company can attract for 1 unit of money spent. 
  > Fomular:
  > value = unique_visitor/(display_spend + social_display_spend)
 - Use this variable to analyze which companies have the lowest cost of getting new potential customers.

_Section 3:_

 - Generate and compare the statistics about display_spend and impressions for Amazon in 2018 and 2019.

_Section 4:_

 - Figure out under all the department and business category of Google, which department (such as Google Inc., Google Worldwide, Google Chrome, Google Play) get the most exposure of its ads by using the ad impression variable. 
 - Compare the statistics in 2018 and 2019