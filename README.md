# User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews
It is a text mining and sentiment analysis project whose goal is to extract sentiment and key themes from unstructured user review text and examine how expressed sentiment relates to user ratings and engagement behaviors on the Spotify mobile application.


Main goal is to improve user satisfaction and engagement on the Spotify mobile application by better understanding how user sentiment expressed in app store
reviews relates to observable user behavior.

## Dependent Variable :
App Rating, representing overall user satisfaction with the Spotify application. App ratings are a publicly visible performance metric that influence
app downloads, user trust, and long-term user growth.
 
## Explanatory Variables:
Sentiment scores derived from user review text, Review engagement, measured by the number of thumbs-up per review

## Model Results and Explanations
![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/Daily%20Average%20Sentiment%20over%20time.png)

Over the course of the data, the average sentiment of Spotify reviews increased by 121.6%, and the average star
rating increased by 31.0%, indicating a substantial improvement in user satisfaction. The larger change in
sentiment compared to ratings suggests that review text captures more nuanced shifts in user experience than
numerical ratings alone.​

### Top words by Rating groups
![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/Top%20words%20by%20rating.png)

High ratings (4–5 stars) are dominated by strongly positive terms such as love, easy, amazing, nice, and quality, indicating satisfaction with usability, content quality, and overall experience.​ Low ratings (1–2 stars) are characterized by problem-oriented and action-driven terms such as update, fix, pay, account, skip, and annoying, suggesting frustration related to app updates, billing, account access, and feature control.​ Medium ratings (3 stars) reflect mixed experiences, combining positive language (love) with operational complaints (update, fix, annoying, shuffle), indicating partial satisfaction alongside unresolved issues.​
The presence of words such as update and fix in both low and medium rating groups suggests that software changes and bug-related issues are a primary driver of dissatisfaction, even among users who do not leave extremely low ratings.

### Do reviews with more negative or positive sentiment receive more community agreement (thumbs-up)?​
![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/Avg%20thumbsup%20review%20by%20sentiment.png)

### Daily Average Sentiment by Star Rating ​
![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/Daily%20Average%20Sentiment%20by%20star%20rating.png)

## Spotify Financial Analysis
To better understand the analysis, I have decided to cross check our findings with Spotify’s Financial Data available for the year 2022

![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/Quarterly%20Review%20Trend.png)

![](https://github.com/Bavana-Pasupuleti/User-Sentiment-and-Engagement-Analysis-of-Spotify-App-Reviews/blob/main/images/User%20metrics%20across%20quarters.png)

In this analysis, revenue growth and monthly active users (premium and ad-supported) are examined as
key business indicators to assess drivers of positive growth.​
Average sentiment increases steadily from –0.49 for 1-star reviews to +0.66 for 5-star reviews, confirming
that sentiment analysis effectively captures differences in user experience.​

Reviews with negative sentiment receive approximately 56% more engagement (thumbs-up) than positive
reviews, indicating that user dissatisfaction drives higher interaction and visibility.​

Time-based analysis shows that periods of declining sentiment coincide with spikes in review volume,
suggesting sentiment can serve as an early warning indicator for emerging user experience issues.​​​
