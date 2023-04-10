library(rvest)
library(dplyr, warn.conflicts = FALSE)


# set the url
w <- c("", "/page/1", "/page/2", "/page/3", "/page/4")

url <- sprintf(
        "https://www.datacamp.com/courses-all%s?technology=r", w
)

url <- "https://www.datacamp.com/courses-all?technology=r"
# Read the url
web_page <- url %>%
        map(read_html)

# Get only h2 css tag to extract course title
h2 <- web_page %>%
        map(html_nodes, css = ".css-69n05k-Search") %>%
        map(html_nodes, css = "h2") %>%
        map(html_text)

course <- tibble::tibble(course = h2) %>% tidyr::unnest(cols = c(course))

# Get only p css tag to extract course description
p <- web_page %>%
        map(html_nodes, css = ".css-69n05k-Search") %>%
        map(html_nodes, css = "p") %>%
        map(html_text)

description <- tibble::tibble(description = p) %>%
        tidyr::unnest(cols = c(description))

# Get only span css tag to extract course duration, type and instructors
span <- web_page %>%
        map(html_nodes, css = ".css-69n05k-Search") %>%
        map(html_nodes ,"article") %>%
        map(html_nodes ,css = "span") %>%
        map(html_text)

span_df <- tibble::tibble(x = span) %>% tidyr::unnest(cols = c(x))

# Extract all that contains a digit followed by the "hours" word
duration <- span_df %>%
        mutate(duration = gsub(".*(\\d+.*)", "\\1", x)) %>%
        filter(grepl("^\\d+", duration)) %>%
        select(duration)


# Extract course type
type <- span_df %>%
        filter(grepl("^Tag", x)) %>%
        mutate(type = gsub("Tag", "", x)) %>%
        select(type)

# Extract instructor's names
instructor <- span_df %>%
        mutate(x = gsub("\\[email protected\\]", "", x)) %>%
        filter(grepl("^User", x)) %>%
        mutate(instructor = gsub("User", "", x)) %>%
        select(instructor)

# Set the final data frame
df <- cbind(course, description, type, duration, instructor)

# Save data frame to disk
write.csv2(df, "./datacamp_R_courses.csv", row.names = FALSE)
