library(dplyr)
library(plyr)
library(readr)
library(stringr)
library(tidyr)

macro = read_csv("~/Desktop/macro.csv")
esg = read_csv("~/Desktop/esg.csv")

glimpse(macro)
glimpse(esg)

names(macro) <- str_replace_all(tolower(names(macro)), " ","_" )
names(esg) <- str_replace_all(tolower(names(esg)), " ","_" )
esg[esg==".."] <- NA

mcols <- names(macro)[10:54]
macro[mcols] <- lapply(macro[mcols], as.numeric)

ecols <- names(esg)[5:29]
esg[ecols] <- lapply(esg[ecols], as.numeric)

esg = esg %>% gather(year, values, ecols)
macro = macro %>% gather(year, values, mcols)

names(macro)[names(macro) == "iso"] <- "country_code"
names(macro)[names(macro) == "weo_subject_code"] <- "series_code"
names(macro)[names(macro) == "subject_descriptor"] <- "series_name"
names(macro)[names(macro) == "country"] <- "country_name"

macro = macro[!is.na(macro$series_code),]
macro = macro[!is.na(macro$series_name),]
esg = esg[!is.na(esg$series_code),]
esg = esg[!is.na(esg$series_name),]


long.combined = rbind.fill(esg,macro)
long.combined$year = gsub("_.*", "", long.combined$year)

#long.combined$id = seq(1,524515, 1)
# long.combined = as.data.frame(long.combined)
#long.combined = long.combined %>% group_by(country_code, year) %>% mutate(id=seq(1,524515, 1))

long.combined$indicator <- paste(long.combined$series_code, "_", long.combined$series_name)
y=c("1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006",
    "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018",
    "2019")
long.combined = long.combined %>%  select(-series_name, -series_code) %>% 
  filter(year%in%y)

long.selected = long.combined %>% select(country_name,country_code, year,values,indicator)

wide.combined = spread(long.selected, indicator, values)

write.csv(wide.combined, file ='leighton.csv')
