# Przykład regresji: równanie płacy

library(ggplot2)
library(wooldridge)
library(wesanderson) # paleta kolorów

# Rozważmy następujący przykład dotyczący danych o płacach zebranych w badaniu 
# Current Population Survey w USA z 1976 r. 
# Chcemy zbadać związek pomiędzy średnimi zarobkami godzinowymi a latami nauki. 
# Zacznijmy od wykresu:

rm(list = ls()) # wyczyść środowisko

# 
#install.packages("wooldridge")
data("wage1", package = "wooldridge")   # załaduj dane data


# kolory
kolor = wes_palette("Moonrise2", 4, type = "discrete")

# ustaw folder roboczy - ustaw własną 
setwd("C:\\Users\\szalas\\OneDrive\\_ekonometria2023\\_6")

plotwages = ggplot(wage1, aes(x=educ, y=wage)) +
  geom_point(size=2, colour=kolor[1]) +
  geom_smooth(se= F , method=lm, color = kolor[2], size=1.5)
plotwages = plotwages + theme_bw() + ylab("Płaca godzinowa") + 
  xlab("Lata edukacji") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plotwages

wage1$lwage = log(wage1$wage)
plotlwages = ggplot(wage1, aes(x=educ, y=lwage)) +
  geom_point(size=2, colour=kolor[1]) +
  geom_smooth(se= F , method=lm, color = kolor[2], size=1.5)
plotlwages = plotlwages + theme_bw() + ylab("Log(płaca godzinowa)") + 
  xlab("Lata edukacji") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plotlwages

# zapisz
png(filename="class6_wage.png", width = 800, height = 600)
plotwages
dev.off()

png(filename="class6_lwage.png", width = 800, height = 600)
plotlwages
dev.off()

### rozkłady

histwages = ggplot(wage1, aes(wage)) +
  geom_histogram(aes(y=..density..),binwidth = 1, colour=kolor[1], fill = kolor[3]) +
  geom_density(colour=kolor[2], , size=1)
histwages = histwages + theme_bw() + ylab("") + 
  xlab("płaca godzinowa") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
histwages

histlwages = ggplot(wage1, aes(lwage)) +
  geom_histogram(aes(y=..density..),binwidth = 0.05, colour=kolor[1], fill = kolor[3]) +
  geom_density(colour=kolor[2], , size=1)
histlwages = histlwages + theme_bw() + ylab("") + 
  xlab("log(płaca godzinowa)") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
histlwages

###### Wynagrodzenie vs. Sprzedaż
data("ceosal1", package = "wooldridge")


plotceo = ggplot(ceosal1, aes(x=salary, y=sales)) +
  geom_point(size=2, colour=kolor[1])
  #geom_smooth(se= F , method=lm, color = kolor[2], size=1.5)
plotceo = plotceo + theme_bw() + ylab("wynagordzenie") + 
  xlab("sprzedaż") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plotceo

plotlceo = ggplot(ceosal1, aes(x=lsalary, y=lsales)) +
  geom_point(size=2, colour=kolor[1])
#geom_smooth(se= F , method=lm, color = kolor[2], size=1.5)
plotlceo = plotlceo + theme_bw() + ylab("log(wynagordzenie)") + 
  xlab("log(sprzedaż)") + 
  theme(legend.position = 'bottom', 
        legend.direction = "horizontal", 
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plotlceo

# zapisz
png(filename="class6_histwage.png", width = 800, height = 600)
histwages
dev.off()

png(filename="class6_histlwage.png", width = 800, height = 600)
histlwages
dev.off()

# zapisz
png(filename="class6_ceo.png", width = 800, height = 600)
plotceo
dev.off()

png(filename="class6_lceo.png", width = 800, height = 600)
plotlceo
dev.off()







