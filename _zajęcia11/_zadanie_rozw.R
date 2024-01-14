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

# wczytanie danych
firms = read.csv( "C:\\Users\\alter-ego\\OneDrive\\_ekonometria2023\\_11\\firms.csv", sep = ",")
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
# Oszacuj model
model = lm(ly ~ lk + ll + lk2 + ll2 + age + age2 + sectorf , firms)
summary(model)

# Sprawdź czy model cechuje się współliniowością. Jeśli tak, to co jest jej źródłem?
vif(model)
# prawodpodobnie zmienne podniesione do kwadratu

# Przetestuj czy zmienne podniesione do kwadratu są łącznie istotne statystycznie. 
# Zdecyduj czy zatrzymasz je w modelu.
# Sprawdź czy w modelu bez tych zmiennych występuje współliniowość
linearHypothesis(model = model, c("lk2=0", 
                                   "ll2=0",
                                   "age2=0"), vcov.=vcovHC(model, type="HC0"))
# są istotne

vif(model)
# wolę oszacować model bez zmiennych podniesionych do kwadratu;
# współliniowość może uczynić model niestabilnym 
model = lm(ly ~ lk + ll + age + sectorf , firms)

# Sprawdź poprawność formy funkcyjnej modelu
resettest(model, power = 2:3, type = "fitted", data = firms)

# Dodaj interakcję i przeprowadź test formy funkcyjnej jeszcze raz
model = lm(ly ~ lk + ll + lk:ll + age + sectorf, firms)
resettest(model, power = 2:3, type = "fitted", data = firms)

# Sprawdź czy składnik losowy ma rozkład normalny. Sprawdź wykres qq
jarque.bera.test(model$residuals)

# wykres qq
qqnorm(model$residuals, pch = 1, frame = FALSE)
qqline(model$residuals, col = "steelblue", lwd = 2)
hist(model$residuals)

# sprawdź czy parametry są wrażliwe na odstające obserwacje
# dźwignia
firms$lkxll = firms$lk * firms$ll # musimy stworzyć interakcję
X = firms[, c("lk", "ll", "lkxll", "sector")]
X = as.matrix(X)
X = cbind(rep(1, nrow(X)), X)
lever = c( diag(X%*%( solve((t(X))%*%X) )%*%t(X)) )
firms = cbind(firms, lever)

plot(firms$lever)
abline(a=8/nrow(firms), b=0, col = "red")

# standaryzowane reszty
firms$residsq = resid(model)^2
firms$resid_std = sqrt(firms$residsq / ((sum(firms$residsq) /(nrow(firms)-4))*(1- firms$lever)))
plot(firms$resid_std)
abline(a=2, b=0, col = "red")

# dystans cooka
firms$cookd = cooks.distance(model)
plot(cooks.distance(model))
abline(a=8/nrow(firms), b=0, col = "red")

# dżwignia vs standaryzowane reszty
plot(firms$lever, firms$resid_std)
abline(h=16/nrow(firms), col = "red")
abline(v=8/nrow(firms), col = "red")

# Oszacuj model na próbie obserwacji z dystansem cooka poniżej lub dźwignią poniżej 0.003
# Porównaj z modelem szacowanym na całej próbie
firms$sample2 = ifelse((firms$lever<0.003 | firms$cookd<0.003), 1, 0)

model2 = lm(ly ~ lk + ll + lk:ll + age + sectorf, data=subset(firms, firms$sample2==1))

stargazer(model, model2,
          type = "text",
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Wpływ ograniczenia próby" )

# Czy parametry modelu są stabilne w grupach labor share? Zastosuj test Chowa
# dzielimy próbę na dwie części:
firms$ls = firms$costofl / firms$y
subs1 = subset(firms, ls<=0.5)
subs2 = subset(firms, ls>0.5)

# przeprowadzamy test:
chow.test(subs1["ly"], subs1[c("lk", "ll", "lkxll", "age", "sector")],
          subs2["ly"], subs2[c("lk", "ll", "lkxll", "age", "sector")])

# oszacuj dwa oddzielne modele i zaprezentuj wyniki. Czy widać różnice?
model3lowls = lm(ly ~ lk + ll + lk:ll + sectorf , data=subset(firms, ls<=0.5))
model3highls = lm(ly ~ lk + ll + lk:ll + sectorf , data=subset(firms, ls>0.5))

stargazer(model3lowls, model3highls,
          type = "text",
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Niski i wysoki LS" )

