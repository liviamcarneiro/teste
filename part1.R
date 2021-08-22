#############################################################

rm(list = ls())

options(scipen=999, digits = 2)

###### Download Libraries ######

Sys.setenv(LANGUAGE='en', LC_CTYPE = "pt_BR.UTF-8")

libs =  c("plyr","lfe",
          "dplyr",
          "data.table",
          "stringr", 
          "openxlsx", 
          "reshape2","foreign","tidyverse", "lubridate", "zoo","xts","chron", "ggplot2","plm", "stargazer","lmtest","apsrtable","multiwayvcov", "sandwich","Hmisc","pastecs","psych","doBy","modeest","purrr") 

install.packages(libs) 

lapply(libs, require, character.only = TRUE) 

###### Set WD ######

setwd("C:/Users/Livia Carneiro/Desktop/Control/Paper/Data/Funds/Panel_R")

###### Excel Files ######

file.list = list.files(pattern='*.xlsx',full.names = F)

###### Create Empty df ######

df_main = NA 

###### Loop Files Excel ######

for(i in file.list){
  
  print(paste("Running loop for",i, sep = " "))
  
  # Nav
  
  nav_tab = read.xlsx(i, sheet = 1, detectDates = T)
  
  funds.position = colnames(nav_tab)[-1]
  
  colnames(nav_tab)[1] = "Date"
  
  nav_tab = melt(nav_tab, id.vars = c("Date"))
  
  colnames(nav_tab) = c("Date","ID","Nav")
  
  # Tna
  
  tna_tab = read.xlsx(i, sheet = 2, detectDates = T)
  
  colnames(tna_tab)[1] = "Date"
  
  tna_tab = melt(tna_tab, id.vars = c("Date"))
  
  colnames(tna_tab) = c("Date","ID","Tna")
  
  # Join all
  
  # e = .GlobalEnv
  
  # nms = ls(pattern = "_tab$", envir = e)
  
  # L  = sapply(nms, get, envir = e, simplify = FALSE)
  
  df = join_all(list(nav_tab,tna_tab), by=c("Date","ID"), type = "full")
  
  df$Year = as.numeric(substring(df$Date,1,4))
  
  # Append
  
  df_main = rbind(df, df_main)
  
  rm(df, nav_tab, tna_tab)
  
}

###### Cleaning & Generate Code & Save ###### 

df_main = subset(df_main, !is.na(ID)) # id not NA

df_main <- transform(df_main, code=as.numeric(factor(ID)))

setwd("C:/Users/Livia Carneiro/Desktop/Control/Paper/Data/Funds/Results_R")

save(df_main, file = "nav_tna_ter_all.RData")

write.csv(df_main, file = "nav_tna_ter_all.csv")

###### End ###### 

