library(rvest)

#' @details 
#' Web scraping do Anexo da Portaria MMA 561/2021
#' Institui a lista de espécies nativas ameaçadas de extinção, como incentivo 
#' ao uso em métodos de recomposição de vegetação nativa em áreas degradadas ou alteradas.
#' 

# Link da Tabela Portaria MMA 561
html_tab <- 'https://www.in.gov.br/en/web/dou/-/portaria-mma-n-561-de-15-de-dezembro-de-2021-367747322'

tab <- html_tab %>%
        read_html() %>%
        html_nodes(xpath = '//table') %>%
        html_table()

#save as csv
write.csv2(
        tab[[1]], './port_mma443_versao_dou_20211216.csv', 
        row.names = FALSE, 
        fileEncoding = 'latin1'
)
