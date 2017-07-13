##load JSON files with jsonlite, line by line
zips <- stream_in(file("sample.json"))

##finds rows with any attribute as NA
row.has.na <- apply(x, 1, function(x){any(is.na(x))})
##removes the NA values and stores
x_clean <- x[!row.has.na]
##Go through each row and determine if a value is zero
x_cleaner = apply(x_clean, 1, function(row) all(row !=0 ))
##saves as final with no NA or zero values
x_final <- x_clean[x_cleaner,]

DT <- data.table(x_final)

x_summed_words <- (DT[, sum(word_count), by = element_id])
colnames(x_summed_words)[2] <- "total_word_count"
x_avg_sentiment <- (DT[, mean(sentiment), by = element_id])
colnames(x_avg_sentiment)[2] <- "average_sentiment"

##combine summed word_count and averaged sentiments
x_final_avg_sum$average_sentiment <- x_avg_sentiment$average_sentiment

##combine initial data with sentiment and wordcount calculations into new table
result_with_sentiments <- result
result_with_sentiments <- cbind(result_with_sentiments, x_final_avg_sum)

##remove the outlier with sentiment > 3
results_with_sentiments <- result_with_sentiments[-3287,]

##plot sentiment with respect to word count showing review score with color
plot_ly(results_with_sentiments, x = ~average_sentiment, y = ~total_word_count, mode = "markers", color = ~overall)

plot_ly(results_with_sentiments, x = ~average_sentiment, y = ~total_word_count, name = "Sentiment vs Words", color = ~overall, size = ~overall)
##3d plot
plot_ly(results_with_sentiments, x = ~average_sentiment, y = ~total_word_count, z = ~overall, name = "Sentiment vs Words", color = ~overall, size = ~overall)

##create a new data frame that contains review helpfulness ratio (helpful/not_helpful)
helpfulness_ratio <- (results_with_sentiments$`helpful/1` / results_with_sentiments$`helpful/0`)
##replace NaN values with zeroes
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
helpfulness_ratio[is.nan(helpfulness_ratio)] <- 0


##setting up RHadoop
##Set environment variables
Sys.setenv("HADOOP_CMD"="/$HADOOP_HOME/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="/$HADOOP_HOME/libexec/share/hadoop/tools/lib/hadoop-streaming-2.8.0.jar")
##Solution for errors installing rhbase
# I think I figured it out. My config starts out the same as yours, and I get the same errors:

# % pkg-config --cflags thrift
# -I/usr/local/Cellar/thrift/0.9.2/include
# I made two changes to /usr/local/lib/pkgconfig/thrift.pc:

# % cd /usr/local/lib/pkgconfig
# % perl -pi -e 's{(^includedir=.*/include$)}{$1/thrift}' thrift.pc
# % perl -pi -e 's{(^Cflags:.*)}{$1 -std=c++11}' thrift.pc
# The first one just adds /thrift to the end of the includedir= line. The second adds the -std=c++11 argument to Cflags, to solve the next problem you'll hit, a namespace issue.

# Then your config should look like the below, and installing rhbase should succeed, though still with a lot of warnings.

# % pkg-config --cflags thrift
# -std=c++11 -I/usr/local/Cellar/thrift/0.9.2/include/thrift