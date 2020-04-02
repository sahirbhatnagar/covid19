devtools::install_github("ropensci/RSelenium")
library(RSelenium)
remDr <- RSelenium::remoteDriver(port = 4445L)
remDr$open()
remDr$getStatus()

remDr$navigate("https://www.inspq.qc.ca/covid-19/donnees")
remDr$getTitle()
remDr$getStatus()
remDr$getRefClass()
webElem <- remDr$findElement(using = "id", value = "evolutionCas")
webElem$highlightElement()
remDr$screenshot(display = TRUE)
webElem$describeElement()
webElem@.xData$
rem

tblSource <- remDr$executeScript("return tbls[0].outerHTML;")[[1]]

pacman::p_load(jsonlite)
tt <- fromJSON("https://spreadsheets.google.com/feeds/cells/1RDtm_2tWgyGlxA7F3b5YSlriw5hic8dX4hopwBhQ_NQ/1/public/values?alt=json")
# tt$version
# tt$feed$entry
# tt$encoding

# as.data.frame(tt$feed$entry$`gs$cell`)
# library(XML)
# XML::htmlTreeParse("https://spreadsheets.google.com/feeds/cells/1RDtm_2tWgyGlxA7F3b5YSlriw5hic8dX4hopwBhQ_NQ/1/public/values")

# jsonlite::flatten(tt$feed$entry$`gs$cell`)

pacman::p_load(tidyverse)
ds <- tt$feed$entry$`gs$cell`
DT <- ds[-c(1:4),] %>%
  mutate(row = as.numeric(as.character(row)),
         col = as.numeric(as.character(col))) %>%
  rename(value = `$t`)


str(DT)

DT <- DT %>%
  mutate(type = rep(ds$`$t`[1:4], max(DT$row)-1),
         ID = rep(seq_len(max(DT$row)-1), each = 4))

library(lubridate)

DT %>%
  dplyr::select(-row,-col, -numericValue) %>%
  pivot_wider(names_from = type, values_from = value) %>%
  mutate(Date = lubridate::as_date(dmy(Date)),
        `Cumul des personnes avec des analyses négatives` = as.numeric(`Cumul des personnes avec des analyses négatives`),
        `Cumul de cas confirmés` = as.numeric(`Cumul de cas confirmés`),
        `Sous investigation` = as.numeric(`Sous investigation`))




