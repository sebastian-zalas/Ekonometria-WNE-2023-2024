######### Testy diagnostyczne ##################################################

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

## dane o szkołach z Kalifornii
data("CASchools", package = "AER")

## opis danych
# district      - character. District code.
# school        - character. School name.
# county factor - indicating county.
# grades factor - indicating grade span of district.
# students      - Total enrollment.
# teachers      - Number of teachers.
# calworks      - Percent qualifying for CalWorks (income assistance).
# lunch         - Percent qualifying for reduced-price lunch.
# computer      - Number of computers.
# expenditure   - Expenditure per student.
# income        - District average income (in USD 1,000).
# english       - Percent of English learners.
# read          - Average reading score.
# math          - Average math score.

# trasformacje
CASchools$stratio = with(CASchools, students/teachers)
CASchools$stratio2 = (with(CASchools, students/teachers))^2
CASchools$score = with(CASchools, (math + read)/2)
CASchools$lincome = log(CASchools$income)

## oszacowanie modelu
model1 = lm(score ~ stratio + lunch + income + english, CASchools)
summary(model1)
CASchools$resid1 = resid(model1)
CASchools$scorehat = fitted(model1)
CASchools$scorehat2 = (fitted(model1))^2
CASchools$scorehat3 = (fitted(model1))^3

# macierz wariancji-lowariancji White'a
odporna1 = coeftest(model1, vcov.=vcovHC(model1, type="HC0"))

#### heteroskedastyczność ------------------------------------------------------

# Test BP - statystyka LM 
bptest(model1, studentize = FALSE)

# Test BP - statystyka F
CASchools$resid1sq = resid(model1)^2
summary(lm(resid1sq ~ stratio + lunch + income + english, CASchools))

# Czy mamy heteroskedastyczność?
odporna1 = vcovHC(model1, type="HC0") # macierz wariancji kowariancji White'a

#### test istotności i łącznej istotności --------------------------------------

# testowanie hipotez z odporną macierzą war-kow White'a - jeden parametr
linearHypothesis(model = model1, c("stratio=0"), vcov.=vcovHC(model1, type="HC0"))
linearHypothesis(model = model1, c("stratio=1"), vcov.=vcovHC(model1, type="HC0"))

# testowanie hipotezy o łącznej nieistotności kilku zmiennych z odporną macierzą war-kow White'a
linearHypothesis(model = model1, c("stratio=0", "lunch=0"), vcov.=vcovHC(model1, type="HC0"))
linearHypothesis(model = model1, c("stratio=0", 
                                   "lunch=0",
                                   "income=0",
                                   "english=0"), vcov.=vcovHC(model1, type="HC0"))

# oszacujmy model ze zmiennymi podniesionymi do kwadratu i przetestujmy ich łączną istotność
CASchools$stratiosq = (CASchools$stratio)^2
CASchools$lunchsq = (CASchools$lunch)^2
CASchools$incomesq = (CASchools$income)^2
CASchools$englishsq = (CASchools$english)^2

modelkwadrat = lm(resid1sq ~ stratio + lunch + income + english + stratiosq + lunchsq + incomesq + englishsq, CASchools)
linearHypothesis(model = modelkwadrat, c("stratiosq=0", 
                                         "lunchsq=0",
                                         "incomesq=0",
                                         "englishsq=0"), vcov.=vcovHC(modelkwadrat, type="HC0"))

#### test formy funkcyjnej - test RESET ----------------------------------------
# komenda resettest wykonuje test formy funkcyjnej
resettest(model1, power = 2:3, type = "fitted", data = CASchools)

# możemy też przeprowadzić test samodzielnie
modelreset = lm(score ~ stratio + lunch + income + english + scorehat2 +scorehat3, data=CASchools)

# ze zwykła macierzą war-kow
linearHypothesis(model = modelreset, c("scorehat2=0", "scorehat3=0"))

# lub odporną macierzą war-kow
linearHypothesis(model = modelreset, c("scorehat2=0", "scorehat3=0"), vcov.= vcovHC(modelreset, type="HC0"))

# jeżeli nie możemy odrzucić hipotezy zerowej, to możemy wypróbować specyfikacje
# nieliniowym komponentem
model2 = lm(score ~ stratio + stratio2 + lunch + income + english, CASchools)
resettest(model2, power = 2:3, type = "fitted", data = CASchools)

#### współliniowość ------------------------------------------------------------
# funkcja vif() oblicza Variance Inflation Index dla każdej zmiennej

# vif dla pierwszej specyfikacji
vif(model1)

# vif dla drugiej specyfikacji
vif(model2)

# porównajmy błędy std - co się zmieniło?
stargazer(model1, model2,
          type = "text",
          se=list(NULL, NULL),
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Model 1 vs 2" )

# tabela korelacji 
cor(CASchools[, c("stratio", "stratio2", "lunch", "income", "english")], method = c("pearson"))

# dokładna współliniowość - przykład
CASchools$twicelunch = 2 * CASchools$lunch
lm(score ~ stratio + stratio2 + lunch + twicelunch+ income + english, CASchools)


#### test normalności składnika losowego ---------------------------------------
jarque.bera.test(model1$resid)

# wykres qq
qqnorm(CASchools$resid1, pch = 1, frame = FALSE)
qqline(CASchools$resid1, col = "steelblue", lwd = 2)
hist(CASchools$resid1)


#### obserwacje nietypowe i błędne ---------------------------------------------

# dźwignia
X = CASchools[, c("stratio", "lunch", "income", "english")]
X = as.matrix(X)
X = cbind(rep(1, nrow(X)), X)
lever = c( diag(X%*%( solve((t(X))%*%X) )%*%t(X)) )
CASchools = cbind(CASchools, lever)
plot(CASchools$lever)
abline(a=10/nrow(CASchools), b=0, col = "red")

# standaryzowane reszty
CASchools$resid_std = sqrt(CASchools$resid1sq / ((sum(CASchools$resid1sq) /(nrow(CASchools)-4))*(1- CASchools$lever)))
plot(CASchools$resid_std)

# dystans cooka
cooks.distance(lm(score ~ stratio + lunch + income + english, data=CASchools))
plot(cooks.distance(lm(score ~ stratio + lunch + income + english, data=CASchools)))
abline(a=4/420, b=0, col = "red")

plot(CASchools$lever, CASchools$resid_std)
abline(h=10/nrow(CASchools), col = "red")
abline(v=4/nrow(CASchools), col = "red")

# ok, spróbujmy coś wyrzucić
m1 = lm(score ~ stratio + lunch + income + english, CASchools)
m2 = lm(score ~ stratio + lunch + income + english, CASchools[lever<0.03,])
m3 = lm(score ~ stratio + lunch + income + english, CASchools[lever<0.02,])

# porównajmy błędy std - co się zmieniło?
stargazer(m1, m2, m3,
          type = "text",
          se=list(NULL, NULL, NULL),
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Model 1 vs 2" )  


#### test chowa ----------------------------------------------------------------
# test strukturalnej zmiany
hist(CASchools$income, breaks = 50, probability = T)
CASchools$tag = ifelse(CASchools$income>16, 2, 1)

# dzielimy próbę na dwie części:
subs1 = subset(CASchools, tag==1)
subs2 = subset(CASchools, tag==2)

# przeprowadzamy test:
chow.test(subs1["score"], subs1[c("stratio", "lunch", "income", "english")],
          subs2["score"], subs2[c("stratio", "lunch", "income", "english")])

# alternatywnie
m  = lm(score ~ stratio + lunch + income + english, data=CASchools)
rss = sum((resid(m))^2)
m1 = lm(score ~ stratio + lunch + income + english, data=subset(CASchools, CASchools$tag==1))
rss1 = sum((resid(m1))^2)
m2 = lm(score ~ stratio + lunch + income + english, data=subset(CASchools, CASchools$tag==2))
rss2 = sum((resid(m2))^2)

# statystyka testowa
Fchow= ((rss - rss1 - rss2)/(5)) / ((rss1+rss2)/(nrow(CASchools) - 2*5 ))
Fkryt = qf(0.95, 5, (nrow(CASchools) - 2*5 ))
pchow = pf(Fchow, 5, (nrow(CASchools) - 2*5 ),lower.tail=FALSE)
  
# porównajmy modele
stargazer(m, m1, m2,
          type = "text",
          se=list(NULL, NULL, NULL),
          align=TRUE,
          keep.stat = c("n", "rsq", "adj.rsq", "f"),
          omit = c("Constant"),
          title = "Modele: test Chowa" )  
