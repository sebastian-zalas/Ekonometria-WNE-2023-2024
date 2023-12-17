######### Przykład empiryczny - funkcja produkcji ##############################

rm(list = ls()) # wyczyść środowisko

## instalowanie pakietów
# install.packages("dyplyr")
# install.packages("wooldridge")    # dane z podręcznika Wooldrigde
# install.packages("skimr")         # statystyki opisowe
# install.packages("stargazer")     # latex tabele
# install.packages("sandwich")      # błędy standardowe
# install.packages("summarytools")  # też do statystyk opisowych
# install.packages("writexl")       # zapisywanie w excelu
# install.packages("lmtest")        # testowanie
# install.packages("whitestrap")    # test White'a

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

##### wprowadzenie #####
# W tym zadaniu będziemy pracować z funkcją produkcji typu Cobba-Douglasa:
#   Y = A * K^α * L^β
#
#   Jest to model potęgowy, który możemy zlinearyzować, korzystając z logarytmu:
#   log(Y) = log(A) + α log(K) + β log(L)
#
#   Dodając składnik losowy ε i stałą otrzymujemy równanie, które możemy oszacować
#   metodą najmniejszych kwadratów. Zauważ, że nie obserwujemy A, czyli produktywności.
#   log(Y) = β_0 + α log(K) + β log(L) + ε
#
#   Aby oszacować to równanie, skorzystaj z danych >>firms.csv<<

##### przygotowanie danych #####

## ścieżka - ustaw swoją!!!!!
setwd("")

##### wczytanie danych i wstępne przetworzenie #####
firms = read.csv("data\\firms.csv", header = TRUE, sep = ",", quote = "\"",
                 dec = ".", fill = TRUE)

## zmieniam nazwy aby były bardziej zrozumiałe:
colnames(firms) = c("X", "id", "year", "employment", "addedval", "laborcost", "sales", "totalassets", "nacerev1primarycode", "year_inc", "indcode")
firms = firms %>% select(-c("X")) # usuwam tą zmienną

## opis danych 
# id - id firmy
# year - rok 
# employment - zatrudnienie w w danej firmie
# addedval - wartość dodana
# laborcost - koszt pracy - suma wydatków na płace
# sales - przychód ze sprzedaży
# totalassets - suma wartości wszytskich aktywów posiadanych przez firmę
# nacerev1primarycode  - 4-cyfrowy kod sektorowy (cos jak PKD)
# year_inc - rok założenia firmy
# indcode - 2-cyfrowy kod sektorowy

# zmienne wyrażone są w tys. (z wyjątkiem l. pracowników)

##### (i) #####
#     Wczytaj dane do R. Czy występują braki danych? 
#     Jeśli tak, pozbądź się ich. 
#     Stwórz logarytmy zmiennych.

# usuwamy brakujące dane
firms = drop_na(firms, any_of( c("laborcost", "addedval", "employment", "totalassets") )  ) 

# Ponadto, ujemne wartości nie mają w tym przypadku ekonomicznego sensu, 
# dlatego można je usunąć ze zbioru danych

# czy są ujemne wartości w zmiennych?
with(firms, table( sign(addedval) ))
with(firms, table( sign(employment) ))
with(firms, table( sign(laborcost) ))
with(firms, table( sign(totalassets) ))

# zostawmy tylko dodatnie wartości
firms = subset(firms, addedval>0 & laborcost>0 & totalassets>0 )


