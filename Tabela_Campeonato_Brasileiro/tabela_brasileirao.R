library(rvest)
library(dplyr)

## url
html <- 'https://www.cbf.com.br/futebol-brasileiro/competicoes/campeonato-brasileiro-serie-a/2022'


## Get the Column Names
header <- html %>%
        read_html() %>%
        html_element('tr') %>%
        html_text2()

col_names <- unlist(as.vector(strsplit(header, split = '\t\r')))

## Get the table
table <- html %>%
        read_html() %>%
        html_element('.table') %>%
        html_table(dec = ',')

## Get only even and odd rows
row_table <- nrow(table)
odd_enven_rows <- seq_len(row_table) %% 2

numbers <- table[odd_enven_rows == 1, ]

strings <- table[odd_enven_rows == 0, ]

## Set a dataframe
df <- numbers %>%
        mutate(Time = strings$Posição) %>%
        select(c(1, 15, 2:13)) %>%
        mutate(Posição = stringr::str_extract(Posição, '[0-9]+')) %>%
        mutate(Time = stringr::str_extract(Time, '(\\w+)(\\s)?(\\w+)?(\\s)?(\\w+)?(\\s-\\s)(\\w{2})')) %>%
        mutate(Recentes = stringr::str_squish(Recentes))
        


## Save as csv
write.csv2(df, 'D:/tabela_brasileirao.csv', row.names = FALSE, fileEncoding = 'latin1')
