# Przykład regresji: równanie płacy

# Rozważmy następujący przykład dotyczący danych o płacach zebranych w badaniu 
# Current Population Survey w USA z 1976 r. 
# Chcemy zbadać związek pomiędzy średnimi zarobkami godzinowymi a latami nauki. 
# Zacznijmy od wykresu:

rm(list = ls()) # wyczyść środowisko

# 
install.packages("wooldridge")
data("wage1", package = "wooldridge")   # załaduj dane data

# funkcja rysująca wykres
plotfun <- function(wage1,log=FALSE,rug = TRUE){
  y = wage1$wage
  if (log){
    y = log(wage1$wage)
  }
  plot(y = y,
       x = wage1$educ, 
       col = "red", pch = 21, bg = "grey",     
       cex=1.25, xaxt="n", frame = FALSE,
       main = ifelse(log,"log(Wages) vs. Education, 1976","Wages vs. Education, 1976"),
       xlab = "years of education", 
       ylab = ifelse(log,"Log Hourly wages","Hourly wages"))
  axis(side = 1, at = c(0,6,12,18))         # podziałki na osi x 
  if (rug) rug(wage1$wage, side=2, col="red")        #dodaj znaczniki na osi y
}

par(mfcol = c(2,1))  # wykres z dwoma panelami
# wykres rozrzutu
plotfun(wage1)

# plot 2: dodaj panel z histogramem i rozkładem
hist(wage1$wage,prob = TRUE, col = "grey", border = "red", 
     main = "Histogram of wages and Density",xlab = "hourly wage")
lines(density(wage1$wage), col = "black", lw = 2)

# Czerwone znaczniki na osi y pokazują, że płace są bardzo skoncentrowane 
# i wynoszą około 5 USD za godzinę, z coraz mniejszą liczbą obserwacji w przypadku 
# wyższych stawek; po drugie, wydaje się, że stawka godzinowa wydaje się rosnąć 
# wraz ze wzrostem poziomu wykształcenia. Dolny panel wzmacnia pierwszy punkt, 
# pokazując, że oszacowany pdf (funkcja gęstości prawdopodobieństwa) zaznaczona 
# czarną linią ma bardzo długi prawy ogon: w danych jest coraz mniej, 
# ale zawsze coraz większe wartości stawki godzinowej.


# Oszacujmy pierwszą regresję na tych danych:
# Używamy w tym celu funkcji `lm()` w następujący sposób:
  
hourly_wage <- lm(formula = wage ~ educ, data = wage1)

# i możemy dodać linię regresji do naszego powyższego wykresu:
  
plotfun(wage1)
abline(hourly_wage, col = 'black', lw = 2) # dodaje linię regresji

# Obiekt hourly_wage zawiera wyniki tego oszacowania. 
summary(hourly_wage)

# Główną interpretację tej tabeli można odczytać z kolumny zatytułowanej Oszacowanie, 
# zawierającej szacunkowe współczynniki beta_0, beta_1:

#  Przy zerowym roku nauki stawka godzinowa wynosi około -0,9 dolara za godzinę 
#  (wiersz o nazwie (Intercept))

# Każdy dodatkowy rok nauki zwiększa stawkę godzinową o 54 centy. (wiersz o nazwie educ)
# Na przykład za 15 lat edukacji przewidujemy około -0,9 + 0,541 * 15 = 7,215 dolarów/h.

### Zadanie:
# Załóżmy, że chcemy wykorzystać powyższe szacunki do przedstawienia wpływu lat 
# nauki na roczne płace, a nie na stawki godzinowe. Załóżmy, że mamy pracowników 
# na pełny etat, 7 godzin dziennie, 5 dni w tygodniu, 45 tygodni w roku. 
# czyli płaca roczna = 1575*płaca godzinowa.
# Przeskaluj zmienną zależną i zobacz co sie stanie.
# Jak zmieniły się współczynniki?

### Logarytmy
# Logarytm naturalny jest szczególnie ważną transformacją, z którą często spotykamy 
# się w ekonomii. Dlaczego mielibyśmy przekształcać zmienne logarymami?

# Kilka ważnych zmiennych ekonomicznych (takich jak płace, wielkość miasta, wielkość firmy itp.) 
# ma w przybliżeniu rozkład logarytmiczno-normalny. Przekształcając je za pomocą log(), 
# otrzymujemy zmienną o rozkładzie w przybliżeniu normalnym, która ma właściwości 
# pożądane dla naszej regresji.

# Stosowanie log() zmniejsza wpływ wartości odstających. 

# Transformacja pozwala na wygodną interpretację w kategoriach procentowych zmian 
# zmiennej wynikowej. Zbadajmy ten problem w naszym bieżącym przykładzie, 
# przekształcając powyższe dane dotyczące wynagrodzeń. 

log_hourly_wage = update(hourly_wage, log(wage) ~ ., data = wage1)

par(mfrow = c(1,2))

plotfun(wage1,rug = FALSE)
abline(hourly_wage, col = 'black', lw = 2)

plotfun(wage1,log = TRUE, rug = FALSE)
abline(log_hourly_wage, col = 'black', lw = 2)

# Jaka jest interpretacja tych wyników?

# Elastyczność
# Być może pamiętasz ze swojego mikro, jaka jest definicja elastyczności y względem X?
# to: Ta liczba mówi nam, o ile procent y zmieni się, jeśli się zmienimy X
# o jeden procent. Spójrzmy na inny przykład z pakietu zbiorów danych Wooldridge, 
# tym razem dotyczący wynagrodzeń CEO i ich związku ze sprzedażą firmy.

data("ceosal1", package = "wooldridge")  
par(mfrow = c(1,2))
plot(salary ~ sales, data = ceosal1, main = "Sales vs Salaries",xaxt = "n",frame = FALSE)
axis(1, at = c(0,40000, 80000))
rug(ceosal1$salary,side = 2)
rug(ceosal1$sales,side = 1)
plot(log(salary) ~ log(sales), data = ceosal1, main = "Log(Sales) vs Log(Salaries)")

# W lewym panelu wykresu wyraźnie widać, że zarówno sprzedaż, jak i wynagrodzenie 
# mają bardzo długie prawe końce, jak wskazują wykresy dywaników na obu osiach. 
# W konsekwencji punkty są skupione w lewym dolnym rogu wykresu. 
# Podejrzewamy pozytywną relację, ale trudno ją dostrzec. 

# Porównaj to z prawym panelem, gdzie obie osie zostały przekształcone logarytmicznie: 
# punkty są ładnie rozłożone, co wyraźnie wskazuje na dodatnią korelację. 

# Zobaczmy, co to daje w modelu regresji - oszacuj model salary i sales w logarytmach.
# zinterpretuj.

 