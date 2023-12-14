######### Przykład empiryczny- płace  ##########################################

##### przygotowanie środowiska i danych #####

rm(list = ls()) # wyczyść środowisko

## ścieżka
setwd("C:\\Users\\szalas\\OneDrive\\_ekonometria2023\\_9")

## instalowanie pakietów
install.packages("dyplyr")
install.packages("wooldridge")    # dane z podręcznika Wooldrigde
install.packages("skimr")         # statystyki opisowe
install.packages("stargazer")     # latex tabele
install.packages("sandwich")      # błędy standardowe
install.packages("summarytools")  # też do statystyk opisowych
install.packages("writexl")       # zapisywanie w excelu
install.packages("lmtest")        # testowanie
install.packages("whitestrap")    # test White'a

## ładowanie pakietów
library(dplyr)
library(lmtest)
library(summarytools)
library(sandwich)
library(stargazer)
library(skimr)
library(wooldridge)
library(writexl)
library(whitestrap)

## załaduj dane data
cps09 = read.csv("data\\cps09mar.txt", header = TRUE, sep = "", quote = "\"",
                dec = ".", fill = TRUE)
head(cps09)

# nowa zmienna - płaca na godzinę
cps09$hwage = cps09$earnings / (cps09$hours * cps09$week)

# logarytm
cps09$lhwage = log(cps09$hwage)

# rasa
cps09$nonwhite = ifelse(cps09$race != 1, 1, 0)
table(cps09$nonwhite)

# status matrymonialny
table(cps09$marital)
cps09$marital = ifelse(cps09$marital >=1 & cps09$marital<=3, 1, 0)
table(cps09$marital)

##### statystyki opisowe #####
  ## 1 - na szybko
  skim(cps09)
  
  ## 2 - statystyki opisowe do excela
  stats_tab =  cps09 %>% 
                select(hwage, education, female, marital, age, nonwhite, union) %>% 
                  descr( ,stats = c("mean", "sd", "min", "q1", "med", "q3", "max", "n.valid"))
  
  stats_tab = as.data.frame(stats_tab)
  stats_tab
  
  # zaokrąglanie cyfr w całym data frame
  round_df <- function(df, digits) {
    nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
    
    df[,nums] <- round(df[,nums], digits = digits)
    
    (df)
  }
  
  stats_tab = round_df(stats_tab, 3)
  
  # zapisywanie
  write_xlsx(stats_tab,"output\\statystyki_opisowe.xlsx")
  
  ## 3 - dla uzytkowników latex'a (i nie tylko)
  cps09short = cps09[ , c("hwage", "education", "female", "marital", "age", "race", "union")]
  
  ## raportowanie i zapisywanie w .csv, .txt, .html lub .tex
  stargazer(
    cps09short,
    summary.stat = c("n", "mean", "sd", "min", "p25", "median", "p75", "max"), 
    type = "text",
    title = "Statystyki opisowe",
    label = "tab:summary",
    style = "apsr",
    out = "output\\statystyki_opisowe2.csv"
  )
  
  # z dokumentacji stargazer:
  # To include stargazer tables in Microsoft Word documents (e.g., .doc or .docx), 
  # please follow the following procedure: 
  #   Use the out argument to save output into an .htm or .html file. 
  #   Open the resulting file in your web browser. 
  #   Copy and paste the table from the web browser to your Microsoft Word document.

##### eksplorowanie danych #####
  
  # zapisywanie wykresu
  png(filename="output//wykres_place_edukacja.png", width = 800, height = 600)
  plot(hwage ~ education, data = cps09,
       xlab = "Edukacja",
       ylab = "Płaca na godzinę",
       main = "Płaca vs poziom edukacji",
       pch  = 20,
       cex  = 1,
       col  = "navy")  
  dev.off() 
  
  plot(lhwage ~ education, data = cps09,
       xlab = "Edukacja",
       ylab = "Płaca na godzinę",
       main = "Płaca vs poziom edukacji",
       pch  = 20,
       cex  = 1,
       col  = "navy")  
  
  hist(cps09$hwage,
       xlab   = "Płace na godzinę",
       main   = "Rozkład płac", # tytuł
       breaks = 20,   # ile przedziałów?
       col    = "red",
       border = "blue")
  
  hist(cps09$lhwage,
       xlab   = "Logarytm płac na godzinę",
       main   = "Rozkład płac", # tytuł
       breaks = 20,   # ile przedziałów?
       col    = "red",
       border = "blue")
  
  hist(cps09$education,
       xlab   = "Poziomy edukacji",
       main   = "Rozkład edukacji", # tytuł
       breaks = 12,   # ile przedziałów?
       col    = "red",
       border = "blue")
  
  boxplot(hwage ~ union, data = cps09,
          xlab   = "Przynależność do związku zawodowego (=1; 0 wpp.)",
          ylab   = "Płace na godzinę",
          main   = "Płace vs przynależność do związku zawodowego",
          pch    = 20,
          cex    = 2,
          col    = "darkorange",
          border = "dodgerblue")
  
##### szacowanie modelu ####
  
  # funkcja lm(y ~ x_1 + x_2 , dane)
  
  model1 = lm(hwage ~ education + female + marital + age + union + nonwhite, cps09)
  
  summary(model1)
  
  model2 = lm(hwage ~ education + female + marital + age + union + nonwhite + union:female, cps09)
  
  model3 = lm(lhwage ~ education + female + marital + age + union + nonwhite, cps09)
  
  model4 = lm(lhwage ~ education + female + marital + age + union + nonwhite + union:female, cps09)
  
  models <- list(model1, model2, model3, model4)
  
  # obliczanie wartości teoretycznych
  cps09$hwage_hat = predict(model1)
  cps09$lhwage_hat = predict(model2)
  
  # obliczanie reszt
  cps09$resid1 = resid(model1)
  cps09$resid2 = resid(model2)
  
  # raportowanie wyników
  stargazer(
    models,
    type = "text",
    keep.stat = c("n", "rsq", "adj.rsq", "f"),
    omit = c("Constant"),
    title = "Płace - regresja",
    out = "output\\model_oszacowanie.html"
  )
  
##### heteroskedastyczność ####

  ## reszty^2 vs zmienne w modelu
  cps09$resid1sq = (cps09$resid1)^2
  cps09$resid2sq = (cps09$resid2)^2

  plot(cps09$education, cps09$resid1sq)
  plot(cps09$education, cps09$resid2sq)
  
  plot(cps09$age, cps09$resid1sq)
  plot(cps09$age, cps09$resid2sq)
  
  plot(cps09$female, cps09$resid1sq)
  plot(cps09$female, cps09$resid2sq)  
  
  ### Testowanie
  
  # test BP
  modelaux = lm(resid1sq ~ education + female + marital + age + union + nonwhite, cps09)
  (stat_bp = ( summary(modelaux)$r.squared / 6)) /( (1-summary(modelaux)$r.squared)*(1/(50742 - 6 -1)))
  (f_kryt = qf(0.05, 7, (526 - 7 -1)))
  (pval_bp = pf(stat_bp, 7, (526 - 7 -1) ) )
  
  # komenda bptest używa statystyki chi kwadrat
  bptest(model1, data=cps09, studentize=FALSE)
  
  # test z użyciem statystyki F -  wystarczy sprawdzić statystykę F
  summary(lm(formula = resid1sq ~ educ + exper + expersq + female, data = wage1)) 

  # test White'a
  white_test(model1) # wersja testu oparta o statystykę mnożników Lagrange (LM)
  
  # macierz odporna White’a
  vcovHC(model1, type="HC0") # sama macierz wariancji kowariancji White'a
  
  # odporne błędy standardowe - korzystamy z pakietu sandwich
  cov1 = vcovHC(model1, type = "HC")
  robust.se1 <- sqrt(diag(cov1))
  
  cov2 = vcovHC(model2, type = "HC")
  robust.se2 <- sqrt(diag(cov2))
  
  # raportowanie wyników z odpornymi błędami std.
  stargazer(model1, model1, model2, model2,
            type = "text",
            se=list(NULL, robust.se1, NULL, robust.se2),
            column.labels=c("default","robust","default","robust"), 
            align=TRUE,
            keep.stat = c("n", "rsq", "adj.rsq", "f"),
            omit = c("Constant"),
            title = "Płace - regresja",
            out = "output\\model_oszacowanie_hc.html" )

