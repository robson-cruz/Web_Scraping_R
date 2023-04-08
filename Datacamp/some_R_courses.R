library(rvest)
library(dplyr, warn.conflicts = FALSE)


# set the url
url <- "https://www.datacamp.com/courses-all?number=1&technology=r"

# Read the url
web_page <- url %>%
        read_html()

# Get only h2 css tag
h2 <- web_page
        html_nodes(css = ".css-69n05k-Search") %>%
        html_nodes(css = "h2") %>%
        html_text()

# Get only p css tag
p <- web_page %>%
        html_nodes(css = ".css-69n05k-Search") %>%
        html_nodes(css = "p") %>%
        html_text()

# Get only span css tag
span <- web_page %>%
        html_nodes(css = ".css-69n05k-Search") %>%
        html_nodes("article") %>%
        html_nodes(css = "span") %>%
        html_text()

# Extract all that contains a digit followed by the "hours" word
duration <- gsub(".*(\\d+.*)", "\\1", span)
duration <- duration[grepl("\\d+", span)]

# Extract course type
type <- gsub("Tag", "", span[grep("^Tag", span)])

# Extract instructor's names
instructor <- gsub("User", "", span[grep("^User", span)])

# Set a data frame
df <- data.frame(
        course = h2,
        description = p,
        duration = duration,
        type = type,
        instructor = instructor
)

# Save data frame to disk
write.csv2(df, "./datacamp_R_courses.csv", row.names = FALSE)
