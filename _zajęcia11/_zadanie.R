######### Zadanie ##############################################################

rm(list = ls()) # wyczyść środowisko

## instalowanie pakietów
# install.packages("tidyr")
# install.packages("dyplyr")
# install.packages("wooldridge")    # dane z podręcznika Wooldrigde
# install.packages("skimr")         # statystyki opisowe
# install.packages("stargazer")     # latex tabele
# install.packages("sandwich")      # błędy standardowe
# install.packages("summarytools")  # też do statystyk opisowych
# install.packages("writexl")       # zapisywanie w excelu
# install.packages("lmtest")        # testowanie
# install.packages("whitestrap")    # test White'a
# install.packages("gap")           # test Chow'a
# install.packages("AER")           # pakiet 'AER' zawiera potrzebny zbiór danych 
# install.packages("tsoutliers")
# install.packages("tseries")
# install.packages("ggplot2")
# install.packages("gap")

## ładowanie pakietów
library(tidyr)
library(dplyr)
library(lmtest)
library(summarytools)
library(sandwich)
library(stargazer)
library(skimr)
library(wooldridge)
library(writexl)
library(whitestrap)
library(AER)     # pakiet 'AER' zawiera potrzebny zbiór danych 
library(tsoutliers)
library(lmtest)
library(tseries)
library(ggplot2)
library(gap)

# wczytanie danych - ustaw ścieżkę!!!!
firms = read.csv( "\\firms.csv", sep = ",")
firms = firms %>% select( - c("X"))

## opis danych
# id      - indeks obserwacji (firmy)
# l       - liczba zatrudnionych
# y       - produkcja - wartość dodana
# costofl - koszt pracowników
# sales   - sprzedaż
# k       - kapitał: wartość aktywów
# indcode - kod sektorowy
# sector  - zm typu factor: manufacturing, services (przemysł, usługi)
# age     - wiek firmy

# logarytmy
for (i in  c("l", "y", "k", "age")) {
  firms[ , paste("l", i, sep = "")] = log(firms[ , paste(i)]) 
}

# kwadraty
for (i in  c("ll" , "lk", "age")) {
  firms[ , paste(i, "2", sep = "")] = (firms[ , paste(i)])^2 
}

# sektor
firms$sectorf = firms$sector
firms$sector = ifelse(firms$sectorf=="manufacturing", 1, 0)

#------------------------------------------------------------------------------#
# Oszacuj model ...


