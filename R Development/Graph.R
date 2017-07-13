plot_ly(results_with_sentiments, x = ~average_sentiment, y = ~total_word_count, name = "Sentiment vs Words", color = ~overall, size = ~overall)
plot_ly(results_with_sentiments, x = ~average_sentiment, y = ~total_word_count, z = ~overall, name = "Sentiment vs Words", color = ~overall, size = ~overall)

helpfulness_ratio <- (results_with_sentiments$`helpful/1` / results_with_sentiments$`helpful/0`)
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
helpfulness_ratio[is.nan(helpfulness_ratio)] <- 0

plot_ly(results_with_sentiments, x = ~helpfulness_ratio, y = ~total_word_count, name = "Sentiment vs Words", color = ~overall, size = ~overall)

plot_ly(results_with_sentiments, x = ~total_word_count, y = ~results_with_sentiments$`helpful/1`)

plot_ly(results_with_sentiments, x = ~overall, colors=c("green","blue", "red"))