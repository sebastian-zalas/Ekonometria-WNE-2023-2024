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

# logarytmy
# można zrobić to ręcznie, logarytmując każdą ze zmiennych oddzielnie,
# można też skorzystać z pętli:
for (i in c("addedval", "employment", "totalassets")) {
  firms[ , paste("l", i, sep = "")] = log(firms[ , paste(i)]) 
}


##### (ii) #####
# rzućmy okiem na statystyki opisowe

firmsshort = firms[,c("laborcost", "addedval", "employment", "totalassets", "sales", "year_inc")]

## raportowanie i zapisywanie w .csv, .txt, .html lub .tex
stargazer(
  firmsshort,
  summary.stat = c("n", "mean", "sd", "min", "p25", "median", "p75", "max"), 
  type = "text",
  title = "Statystyki opisowe",
  label = "tab:summary",
  style = "apsr",
  out = "output\\statystyki_opisowe_firms.csv"
)
# Co widać w statystykach opisowych?
# -> średnie zatrudnienie wynosi 453 a 25ty percentyl 64 - mamy do czynienia z 
#    dużymi przedsiębiorstwami
# -> jest duża różnica między 75 percentylem a maksimum - pewnie jest dużo outlierów
# -> duże odchylenie standardowe
# -> skośny rozkład - ogromna różnica między średnią a medianą
# -> dzinwe obserwacje roku założenia (year inc)

# zobaczmy rozkład roku założenia firmy
hist(firms$year_inc,
     xlab   = "Wiek",
     ylab   = "",
     main   = "Rozkład wieku firm", # tytuł
     breaks = 1000,   # ile przedziałów?
     col    = "yellow",
     border = "blue")

# są nierealsityczne obserwacje jak 1400 
# warto je wyrzucić - zostawny te założone po 1945
firms = firms %>% filter(year_inc>1945) 

# spójrzmy na rozkłady zmiennych któe wykorzystamy do estymacji równania f. produkcji:
hist(firms$employment,
     xlab   = "Zatrudnienie",
     ylab   = "",
     main   = "Rozkład zatrudnienia", # tytuł
     breaks = 1000,   # ile przedziałów?
     col    = "yellow",
     border = "blue")

hist(firms$addedval,
     xlab   = "Wartości dodanej",
     ylab   = "",
     main   = "Rozkład wartości dodanej", # tytuł
     breaks = 1000,   # ile przedziałów?
     col    = "yellow",
     border = "blue")
# -> oba rozkłady są silnie skośne, ogromne outliery

hist(firms$lemployment,
     xlab   = "Zatrudnienie (log)",
     ylab   = "",
     main   = "Rozkład logarytmu zatrudnienia", # tytuł
     breaks = 100,   # ile przedziałów?
     col    = "yellow",
     border = "blue")

hist(firms$laddedval,
     xlab   = "Wartości dodanej",
     ylab   = "",
     main   = "Rozkład logarytmu wartości dodanej", # tytuł
     breaks = 100,   # ile przedziałów?
     col    = "yellow",
     border = "blue")

# -> po zastosowaniu logarytmu rozkłady znacznie się poprawiły, 
#    outliery zostały znacznie ograniczone
# -> w przypadku zatrudnienia po prawej stronie jest ciągle długi "ogon"

plot(addedval ~ employment, 
     data = firms,
     xlab = "Zatrudnienie",
     ylab = "Wartość dodana",
     main = "Y vs L",
     pch  = 20,
     cex  = 1.5,
     cex.lab = 1.5,
     cex.main = 2,
     cex.axis = 1.2, 
     col  = "navy")  

plot(addedval ~ totalassets, 
     data = firms,
     xlab = "Aktywa",
     ylab = "Wartość dodana",
     main = "Y vs K",
     pch  = 20,
     cex  = 1.5,
     cex.lab = 1.5,
     cex.main = 2,
     cex.axis = 1.2, 
     col  = "navy")  

plot(laddedval ~ lemployment, 
     data = firms,
     xlab = "Zatrudnienie (log)",
     ylab = "Wartość dodana (log)",
     main = "log(Y) vs log(L)",
     pch  = 20,
     cex  = 1.5,
     cex.lab = 1.5,
     cex.main = 2,
     cex.axis = 1.2, 
     col  = "navy")  

png(filename="output//wykres_y_vs_k.png", width = 800, height = 600)
plot(laddedval ~ ltotalassets, 
     data = firms,
     xlab = "Aktywa (log)",
     ylab = "Wartość dodana (log)",
     main = "log(Y) vs log(K)",
     pch  = 20,
     cex  = 1.5,
     cex.lab = 1.5,
     cex.main = 2,
     cex.axis = 1.2, 
     col  = "navy")
dev.off()
# spójrz na składnię: png(), potem kod generujący wykres, dev.off()
# pozwala ona na zapisywanie wykresu - sprawdź folder output

# -> po zastosowaniu logarytmów, widać że relacja między aktywami i zatrudnieniem a
#    watością dodaną jest raczej liniowa 
# -> jednak ciąge widać odstające obserwacje


##### (iii) #####
# Oszacuj model (1). 
model1 = lm(laddedval ~ ltotalassets + lemployment , firms)

## Czy oszacowania parametrów są istotne statystycznie? 
summary(model1)
# Spójrz na p-value przy każdym z oszacowań, są bardzo niskie, 
# więc tak, oszacowania są istotne statystycznie

## Czy oszacowania są łącznie istotne statystycznie? 
# Spójrz na Statystykę F oraz  związane z nią p-value.
# Statystyka F jest bardzo wysoka a p-valye jest bardzo niskie, 
# Zatem, oszacowania są łącznie istotne statystycznie

## Skomentuj dopasowanie modelu do danych.
# R2 wynosi 0.68 - 68 proc. zmienności logarytmu wartości dodanej jest wyjaśniane 
# przez model


##### (iv) #####
## Sprawdź czy w modelu (1) występuje heteroskedastyczność. 

## Narysuj odpowiednie wykresy. 
# chodzi o wykres kwadratów reszt
firms$resid2 = (resid(model1))^2
plot(firms$lemployment , firms$resid2)
plot(firms$ltotalassets, firms$resid2)
# 

## Przeprowadź testy Breuscha-Pagana oraz White’a. 
# test White'a
white_test(model1) 

# test Breuscha Pagana
bptest(model1, data=cps09, studentize=FALSE)

# w obu testach p-value jest bardzo niskie - możemy odrzucić hipotezę zerową 
# o homoskedastyczności składnika losowego. Przyjmujemy więc hipotezę alternatywną,
# heteroskedastyczności składnika losowego

## Jaki typ błędów standardowych należy wykorzystać? 
# w takim przypadku trzeba zastosować odporne błędy standardowe

## Porównaj oszacowania zwykłych i odpornych błędów standardowych. Zaraportuj wyniki.
# najpierw oszacujemy odporne błędy standardowe - korzystamy z pakietu sandwich
cov1 = vcovHC(model1, type = "HC0")
robust.se1 <- sqrt(diag(cov1))

# raportowanie
stargazer(model1, model1,
          type = "text",
          se=list(NULL, robust.se1),
          column.labels=c("zwykle","odporne"), 
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Oszacowanie funkcji produkcji.",
          out = "output\\model_firmy_hc.txt" )

# odporne błędy standardowe (kolumna (2)) są nieco wyższe niż zwykłe, ale niewiele.

##### (v) #####
# Stwórz zmienną binarną, opisującą przynależność firmy do sektora przemysłowego. 
# Odrzućmy jeszcze obserwacje z rolnictwa i wydobycia
firms = firms %>% filter(., indcode>=10)
firms$manufacturing = ifelse( firms$indcode >=10 & firms$indcode <= 43 , 1, 0)

# Oszacuj model z tą zmienną.
model2 = lm(laddedval ~ ltotalassets + lemployment + manufacturing, firms)

# Czy firmy przemysłowe są bardziej produktywne niż pozostałe?
summary(model2)
# oszacowanie wskazuje ze firmy przemysłowe są średnio 9 proc mniej produktywne 
# niż pozostałe przy innych czynnikach niezmienionych.

##### (vi) #####
# Stwórz zmienną opisującą wiek. Czy wraz z wiekiem produkcja rośnie?
firms$age = firms$year - firms$year_inc + 1

# Oszacuj model z tą zmienną.
model3 = lm(laddedval ~ ltotalassets + lemployment + manufacturing + manufacturing + age, firms)
summary(model3)
# oszacowanie przy zmiennej age wskazuje, że wraz z wiekiem produkcja rośnie o 0.06 proc.


##### *dodatek*: jak zaraportować wyniki z trzech modeli razem? #####
# tylko odporne błędy std.
robust.se2 <- sqrt(diag(vcovHC(model2, type = "HC0")))
robust.se3 <- sqrt(diag(vcovHC(model3, type = "HC0")))

stargazer(model1, model2, model3,
          type = "text",
          se=list(robust.se1, robust.se2, robust.se3),
          align=TRUE,
          dep.var.labels=c("log(wartość dodana)"),
          covariate.labels=c("log(aktywa)","log(zatrudnienie)",
                             "przemysł","wiek"),
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Oszacowanie funkcji produkcji.",
          out = "output\\model_firmy_3modele.txt" )


