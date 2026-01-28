library(tidyverse)   # dplyr, ggplot2, readr
library(tidytext)    # text mining + sentiment
library(lubridate)   # date/time handling

spotify <- read_csv("~/Downloads/Spotify App Review.csv")

#changing to datetime
spotify <- spotify %>%
  mutate(
    Time_submitted = mdy_hm(Time_submitted),
    Date = as.Date(Time_submitted)
  )
#basic summary statistics
summary(spotify$Rating)
summary(spotify$Total_thumbsup)
head(spotify)

#Checking for any null values in Reviews column
sum(is.na(spotify$Review))

#clean plus tokenize text
tokens <- spotify %>%
  select(Rating, Review) %>%
  unnest_tokens(word, Review)

#removing stop words
tokens_clean <- tokens %>%
  anti_join(stop_words, by = "word")

#adding sentiment
sentiment_words <- tokens_clean %>%
  inner_join(get_sentiments("bing"), by = "word")

#caluculating sentiment per score
sentiment_scored <- sentiment_words %>%
  mutate(sentiment_value = ifelse(sentiment == "positive", 1, -1)) %>%
  group_by(Rating) %>%
  summarise(
    avg_sentiment = mean(sentiment_value),
    word_count = n()
  )

sentiment_scored

ggplot(sentiment_scored, aes(x = factor(Rating), y = avg_sentiment)) +
  geom_col() +
  labs(
    title = "Average Sentiment Score by Star Rating",
    x = "Star Rating",
    y = "Average Sentiment Score"
  )

#creating rating groups
spotify <- spotify %>%
  mutate(
    rating_group = case_when(
      Rating <= 2 ~ "Low (1–2)",
      Rating == 3 ~ "Medium (3)",
      Rating >= 4 ~ "High (4–5)"
    )
  )
#custom stop words
custom_stopwords <- tibble(
  word = c(
    "spotify", "app", "apps", "music", "song", "songs",
    "play", "playing", "listen", "listening",
    "premium", "ads", "ad","playlist"
  )
)


#tokenise and cleaning text
tokens <- spotify %>%
  select(rating_group, Review) %>%
  unnest_tokens(word, Review) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(custom_stopwords, by = "word")

#finding most common words
top_words <- tokens %>%
  count(rating_group, word, sort = TRUE) %>%
  group_by(rating_group) %>%
  slice_max(n, n = 10)

top_words

ggplot(top_words, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ rating_group, scales = "free") +
  labs(
    title = "Top Words by Rating Group",
    x = "Word",
    y = "Frequency"
  )
#adding unique id
spotify <- spotify %>%
  mutate(review_id = row_number())

#scoring each review
review_sentiment <- spotify %>%
  select(review_id, Review, Total_thumbsup) %>%
  unnest_tokens(word, Review) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(custom_stopwords, by = "word") %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(sentiment_value = ifelse(sentiment == "positive", 1, -1))

#sentiment score per review
review_sentiment <- review_sentiment %>%
  group_by(review_id, Total_thumbsup) %>%
  summarise(sentiment_score = sum(sentiment_value), .groups = "drop")



#tokenise, clean and join
review_tokens <- spotify %>%
  select(review_id, Review, Total_thumbsup) %>%
  unnest_tokens(word, Review) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(custom_stopwords, by = "word") %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(sentiment_value = ifelse(sentiment == "positive", 1, -1))


#categorise by sentiment
review_sentiment <- review_sentiment %>%
  mutate(
    sentiment_category = case_when(
      sentiment_score > 0 ~ "Positive",
      sentiment_score < 0 ~ "Negative",
      TRUE ~ "Neutral"
    )
  )

#Average thumbsup per sentiment category
thumbs_summary <- review_sentiment %>%
  group_by(sentiment_category) %>%
  summarise(
    avg_thumbs_up = mean(Total_thumbsup),
    review_count = n()
  )
thumbs_summary

#visualisation
ggplot(thumbs_summary, aes(x = sentiment_category, y = avg_thumbs_up)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Average Thumbs-Up by Review Sentiment",
    x = "Sentiment Category",
    y = "Average Thumbs-Up"
  )

#review level sentiment
review_sentiment <- review_sentiment %>%
  left_join(spotify %>% select(review_id, Date, Rating), by = "review_id")

#daily average sentiment
daily_sentiment <- review_sentiment %>%
  group_by(Date) %>%
  summarise(
    avg_sentiment = mean(sentiment_score),
    avg_rating = mean(Rating),
    review_count = n(),
    .groups = "drop"
  )

#daily sentiment trend
ggplot(daily_sentiment, aes(x = Date, y = avg_sentiment)) +
  geom_line(color = "steelblue") +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  labs(
    title = "Daily Average Sentiment Over Time",
    x = "Date",
    y = "Average Sentiment Score"
  )

#daily average rating
ggplot(daily_sentiment, aes(x = Date, y = avg_rating)) +
  geom_line(color = "darkgreen") +
  geom_smooth(method = "loess", color = "orange", se = FALSE) +
  labs(
    title = "Daily Average Star Rating Over Time",
    x = "Date",
    y = "Average Rating"
  )

#reviews per day volume trend
ggplot(daily_sentiment, aes(x = Date, y = review_count)) +
  geom_col(fill = "skyblue") +
  labs(
    title = "Number of Reviews Submitted Per Day",
    x = "Date",
    y = "Number of Reviews"
  )

#quantifying negative spikes
neg_spikes <- daily_sentiment %>%
  filter(avg_sentiment < quantile(avg_sentiment, 0.05)) %>%
  arrange(avg_sentiment)
neg_spikes

#Sentiment rating over time
daily_rating_sentiment <- review_sentiment %>%
  group_by(Date, Rating) %>%
  summarise(avg_sentiment = mean(sentiment_score), .groups = "drop")

ggplot(daily_rating_sentiment, aes(x = Date, y = avg_sentiment, color = factor(Rating))) +
  geom_line() +
  labs(
    title = "Daily Average Sentiment by Star Rating",
    x = "Date",
    y = "Average Sentiment Score",
    color = "Rating"
  )

#quantifying the answers
#starting and ending values
start_rating <- daily_sentiment %>% arrange(Date) %>% slice(1) %>% pull(avg_rating)
end_rating   <- daily_sentiment %>% arrange(Date) %>% slice(n()) %>% pull(avg_rating)

start_sentiment <- daily_sentiment %>% arrange(Date) %>% slice(1) %>% pull(avg_sentiment)
end_sentiment   <- daily_sentiment %>% arrange(Date) %>% slice(n()) %>% pull(avg_sentiment)


#compute percentage
rating_pct_change <- ((end_rating - start_rating)/start_rating) * 100
sentiment_pct_change <- ((end_sentiment - start_sentiment)/abs(start_sentiment)) * 100

rating_pct_change


#engagement trends
neg_days <- daily_sentiment %>% filter(avg_sentiment <= quantile(avg_sentiment, 0.05))
pos_days <- daily_sentiment %>% filter(avg_sentiment >= quantile(avg_sentiment, 0.95))

avg_reviews_neg <- mean(neg_days$review_count)
avg_reviews_pos <- mean(pos_days$review_count)

#REGRESSION

quarterly_data <- read_csv("~/Documents/Spotify_monthly_data.csv")
head(quarterly_data)

#aggregate reviews by quarter
# Make sure Date is in Date format

review_sentiment <- review_sentiment %>%
  left_join(spotify %>% select(review_id, Date, Rating), by = "review_id") %>%
  mutate(Quarter = quarter(Date, with_year = TRUE))  # e.g., 2022.3

#aggregate reviews by quarter
quarterly_reviews <- review_sentiment %>%
  group_by(Quarter) %>%
  summarise(
    avg_sentiment = mean(sentiment_score),
    avg_rating = mean(Rating),
    review_count = n(),
    .groups = "drop"
  )

quarterly_reviews
quarterly_data


quarterly_reviews <- review_sentiment %>%
  mutate(
    year = year(Date),
    qtr = quarter(Date),
    Quarter = paste0("Q", qtr, " ", year)
  ) %>%
  group_by(Quarter) %>%
  summarise(
    avg_sentiment = mean(sentiment_score, na.rm = TRUE),
    avg_rating = mean(Rating, na.rm = TRUE),
    review_count = n(),
    .groups = "drop"
  )

#merging both the datasets
regression_data <- quarterly_data %>%
  left_join(quarterly_reviews, by = "Quarter")

head(regression_data)

regression_data_clean <- regression_data %>%
  filter(!is.na(avg_rating), !is.na(avg_sentiment))

mau_model <- lm(
  MAU_millions ~ Premium_subscribers +
    Ad_MAU +
    Total_Revenue +
    MAU_growthrate +
    avg_sentiment,
  data = regression_data
)

summary(mau_model)










