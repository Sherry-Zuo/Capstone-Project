setwd("~/Downloads")
library(dplyr)
library(readr)
library(tidyverse)
library(plyr)
library(skimr)

`2014` = read.csv("2014.csv")
`2016` = read.csv("2016.csv")
`2017` = read.csv("2017.csv")
`2018` = read.csv("2018.csv")
`2019` = read.csv("2019.csv")

skim(`2014`)
