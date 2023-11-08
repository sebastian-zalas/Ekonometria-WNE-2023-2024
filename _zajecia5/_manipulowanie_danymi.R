# Manipulowanie danymi

# Poznamy kilka podstawowych pojęć, które pomogą 
# podsumować dane.Następnie zajmiemy się rzeczywistym zadaniem, polegającym 
# na wczytaniu, oczyszczaniu i podsumowywaniu danych z Internetu.

## Statystyki
# `R` ma wbudowane funkcje dla dużej liczby statystyk. W przypadku zmiennych 
# numerycznych możemy podsumowywać dane, na przykład patrząc na ich środek i rozkład.

# załadujmy pakiet, daje nam dostęp do zbiorU danych mpg
library(ggplot2)
?mpg # dokumentacja danych

### Miary tendencji centralnej - średnia, mediana
mean(mpg$cty)     # średnia
median(mpg$cty)   # mediana
  
### Miary rozrzutu
var(mpg$cty)    # wariancja
sd(mpg$cty)     # odchylenie standardowe
IQR(mpg$cty)    # rozstęp międzykwartylowy
min(mpg$cty)
max(mpg$cty)
range(mpg$cty)

### dla zmiennych kategorycznych
table(mpg$drv)
table(mpg$drv) / nrow(mpg)  # w procentach

## Wykresy
# Teraz, gdy mamy już pewne dane do pracy i poznaliśmy je na najbardziej 
# podstawowym poziomie, naszymi następnymi zadaniami będzie ich wizualizacja. 
# Często odpowiednia wizualizacja może ujawnić cechy danych, 
# które mogą pomóc w dalszej analizie.

# Przyjrzymy się czterem metodom wizualizacji danych przy użyciu podstawowych funkcji 
# wykresów wbudowanych w „R”:  
# - Histogram (Histograms)
# - Wykres słupkowy (Barplots)
# - Wykres pudełkowy (Boxplot)
# - Wykres rozrzutu (Scatterplot)

### Histogram
hist(mpg$cty)

# Funkcja histogramu posiada szereg parametrów, które można zmieniać, 
# aby nasz wykres wyglądał znacznie ładniej. 
# Sprawdź dokumentację funkcji `hist()` by zobaczyć pełną listę tych parametrów.

hist(mpg$cty,
     xlab   = "Miles Per Gallon (City)",
     main   = "Histogram of MPG (City)", # tytuł
     breaks = 12,   # ile przedziałów?
     col    = "red",
     border = "blue")

# Co ważne, zawsze pamiętaj o oznaczeniu osi i nadaniu tytułu. 
# Argument „breaks” jest specyficzny dla „hist()”. Wprowadzenie liczby całkowitej 
# spowoduje, że „R” zasugeruje liczbę słupków użytych w histogramie. 
# Domyślnie „R” będzie próbował inteligentnie odgadnąć dużą liczbę „przerw”, 
# ale czasami warto to zmienić samodzielnie.

### Wykres słupkowy
# Wykres słupkowy, przypominający nieco histogram, może stanowić wizualne 
# podsumowanie zmiennej kategorycznej lub zmiennej numerycznej o skończonej 
# liczbie wartości, na przykład rankingu od 1 do 10.

barplot(table(mpg$drv))

barplot(table(mpg$drv),
        xlab   = "Drivetrain (f = FWD, r = RWD, 4 = 4WD)",
        ylab   = "Frequency",
        main   = "Drivetrains",
        col    = "dodgerblue",
        border = "darkorange")

### Wykres pudełkowy - boxplot
# Aby zwizualizować związek między zmienną liczbową a kategoryczną, 
# można kiedyś użyć **wykresu pudełkowego**. W zbiorze danych `mpg` zmienna 
# `drv` przyjmuje małą, skończoną liczbę wartości. Samochód może mieć tylko
# napęd na przednie koła, napęd na 4 koła lub napęd na tylne koła.
unique(mpg$drv)

# Najpierw zauważ, że możemy użyć pojedynczego wykresu pudełkowego jako 
# alternatywy dla histogramu do wizualizacji pojedynczej zmiennej numerycznej. 
# Aby to zrobić w `R`, używamy funkcji `boxplot()`. Ramka pokazuje 
# *rozstęp międzykwartylowy*, linia ciągła pośrodku to wartość mediany, 
# wiskery pokazują 1,5-krotność rozstępu międzykwartylowego, 
# a kropki to wartości odstające.

boxplot(mpg$hwy)

# Częściej jednak będziemy używać wykresów pudełkowych do porównywania 
# zmiennej numerycznej dla różnych wartości zmiennej kategorycznej.

boxplot(hwy ~ drv, data = mpg)

# Tutaj użyto polecenia `boxplot()` do tworzenia wykresów pudełkowych obok siebie.
# Ponieważ jednak mamy teraz do czynienia z dwiema zmiennymi, składnia uległa 
# zmianie. Składnia `R` `hwy ~ drv, dane = mpg` brzmi: „Wykreśl zmienną `hwy` 
# względem zmiennej `drv`, korzystając ze zbioru danych `mpg`.” 
# Widzimy użycie `~` (określającego formułę), a także argumentu `data = `. 
# Będzie to składnia wspólna dla wielu funkcji, których będziemy używać w tym kursie.

boxplot(hwy ~ drv, data = mpg,
        xlab   = "Drivetrain (f = FWD, r = RWD, 4 = 4WD)",
        ylab   = "Miles Per Gallon (Highway)",
        main   = "MPG (Highway) vs Drivetrain",
        pch    = 20,
        cex    = 2,
        col    = "darkorange",
        border = "dodgerblue")

# Ponownie, `boxplot()` ma wiele dodatkowych argumentów, które mogą uczynić 
# nasz wykres bardziej atrakcyjny wizualnie.

### Scatterplot - wykres rozrzutu
# Na koniec, aby zwizualizować związek między dwiema zmiennymi numerycznymi, 
# użyjemy **wykresu rozrzutu**. Można to zrobić za pomocą funkcji `plot()` i 
# składni `~`, której właśnie użyliśmy w przypadku wykresu skrzynkowego. 
# (Funkcji `plot()` można również użyć bardziej ogólnie; szczegóły znajdziesz w dokumentacji.)

plot(hwy ~ displ, data = mpg)

plot(hwy ~ displ, data = mpg,
     xlab = "Engine Displacement (in Liters)",
     ylab = "Miles Per Gallon (Highway)",
     main = "MPG (Highway) vs Engine Displacement",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")

### ggplot
# Wszystkie powyższe wykresy można było również wygenerować przy użyciu funkcji 
# `ggplot` z już załadowanego pakietu `ggplot2`. To, której funkcji użyjesz, 
# zależy od ciebie, ale czasami łatwiej jest zbudować wykres korzystając z podstawowych 
# funkcji R (być może jak w przykładzie „boxplot”), czasami na odwrót.

ggplot(data = mpg,mapping = aes(x=displ,y=hwy)) + geom_point()

# `ggplot` nie da się opisać w skrócie, więc proszę zajrzeć na 
# [stronę internetową pakietu] (http://ggplot2.tidyverse.org), 
# która zawiera doskonałe wskazówki. Od czasu do czasu będziemy używać w 
# tej książce narzędzia ggplot, abyś mógł się z nim zapoznać. 
# Zademonstrujmy szybko, jak można dodatkowo dostosować pierwszy wykres:

ggplot(data = mpg, mapping = aes(x=displ,y=hwy)) +   # ggplot() tworzy podstawowy wykres
geom_point(color="blue",size=2) +   
scale_y_continuous(name="Miles Per Gallon (Highway)") +  # nazwa osi y
scale_x_continuous(name="Engine Displacement (in Liters)") + # nazwa osi x 
theme_bw() +    # zmień tło
ggtitle("MPG (Highway) vs Engine Displacement")   # dodaj tytuł


## Pakiet tidyverse
# Hadley Wickham (http://hadley.nz) jest autorem pakietów R `ggplot2`, 
# a także `dplyr` (a także niezliczonej liczby innych). W `ggplot2` wprowadził 
# do `R` tak zwaną *gramatykę grafiki* (stąd `gg`). 
# Gramatyka w tym sensie, że istnieją **rzeczowniki** i **czasowniki** 
# oraz **składnia**, czyli zasady łączenia rzeczowników i czasowników 
# w celu zbudowania zrozumiałego zdania. Rozszerzył ideę *gramatyki* 
# na różne inne pakiety. Pakiet `tidyverse` jest kolekcją tych pakietów.
 
# Dane w formacie „tidy” to dane, w których:
#   
# * Każda zmienna jest kolumną
# * Każda obserwacja jest wierszem
# * Każda wartość jest komórką

# Można powiedzieć, że jest to zwykły arkusz kalkulacyjny. I masz rację! 
# Jednak dane docierają do nas w większości przypadków NIEuporządkowane i 
# najpierw musimy je wyczyścić. 
# Gdy dane zostaną już zapisane w formacie „tidy”, możemy z dużą wydajnością 
# korzystać z narzędzi zawartych w „tidyverse”, aby analizować dane 
# i nie martwić się, którego narzędzia użyć.

### wczytywanie pliku `.csv` w formacie *tidy*
# Mogliśmy użyć funkcji „read_csv()” z pakietu „readr”, aby przeczytać nasz 
# przykładowy zbiór danych z poprzedniego rozdziału. Funkcja `readr` `read_csv()` 
# ma wiele zalet w porównaniu z wbudowaną funkcją `read.csv`. 
# Na przykład znacznie szybciej czyta się większe dane. 
# [Używa również pakietu `tibble` do odczytu danych jako tibble.]
# (https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html) 
# ** `tibble` to po prostu ramka danych, która jest drukowana w rozsądny sposób.** 
# W wynikach poniżej podano dodatkowe informacje, takie jak wymiar i typ zmiennej.

# być może potrzebyjesz
#install.packages("readr")
library(readr)  

### Tidy `data.frames` to `tibbles`
# Pobierzmy dane z pakietu `ggplot2`:

data(mpg,package = "ggplot2")  # load dataset `mpg` from `ggplot2` package
head(mpg, n = 10)

# Jak widzieliśmy, funkcja „head()” wyświetli pierwsze „n” obserwacji ramki danych. 
# Funkcja `head()` była bardziej użyteczna przed tibbles. Zauważ, że `mpg` jest 
# już tibble, zatem wynik funkcji `head()` wskazuje, że jest tylko `10` obserwacji. 
# Zauważ, że dotyczy to `head(mpg, n = 10)`, a nie samego `mpg`. 
# Należy również pamiętać, że tibbles domyślnie drukują ograniczoną liczbę 
# wierszy i kolumn. Ostatni wiersz wydruku wskazuje, że wiersze i kolumny zostały pominięte.

mpg

# Przyjrzyjmy się także `str`, aby zapoznać się z zawartością danych:

str(mpg)

# W tym zbiorze danych obserwacja dotyczy konkretnego roku modelowego samochodu, 
# a zmienne opisują cechy samochodu, na przykład jego zużycie paliwa na autostradzie.
# 
# Aby lepiej zrozumieć zbiór danych, używamy operatora „?”, 
# aby wyświetlić dokumentację danych.
?mpg

# Praca z tibble'ami jest w większości taka sama, jak praca ze zwykłymi ramkami danych:
names(mpg)
mpg$year
mpg$hwy

# Odwoływanie jest również podobne do ramki danych. Tutaj znajdziemy pojazdy 
# oszczędne, które zarabiają ponad 35 mil na galonie i wyświetlamy 
# tylko „producenta”, „model” i „rok”.

# mpg[row condition, col condition]
mpg[mpg$hwy > 35, c("manufacturer", "model", "year")]

# Alternatywą byłoby użycie funkcji „subset()”, która ma znacznie bardziej czytelną składnię.
subset(mpg, subset = hwy > 35, select = c("manufacturer", "model", "year"))

# Na koniec, *porządnie*, moglibyśmy użyć funkcji `filter` i `select` z pakietu 
# `dplyr`, który wprowadza *operator potoku* `f(x) %>% g(z)` z pakietu `magrittr`. 
# Operator ten pobiera wynik pierwszego polecenia, na przykład `y = f(x)` 
# i przekazuje go *jako pierwszy argument* do następnej funkcji, 
# tj. otrzymalibyśmy tutaj `g(y,z)`. ^[A *potok* to koncepcja ze świata Uniksa, 
# która oznacza pobranie wyniku jakiegoś polecenia i przekazanie go do innego polecenia. 
# W ten sposób można zbudować *potok* poleceń. Dodatkowe informacje na temat 
# operatora potoku w R mogą Cię zainteresować 
# [w tym samouczku](https://www.datacamp.com/community/tutorials/pipe-r-tutorial).]

library(dplyr)
mpg %>% 
  filter(hwy > 35) %>% 
  select(manufacturer, model, year)

# Zauważ, że powyższa składnia jest równoważna następującemu poleceniu bez potoków 
# (które jest znacznie gorsze do odczytania!):
library(dplyr)
select(filter(mpg, hwy > 35), manufacturer, model, year)

# Wszystkie trzy podejścia dają takie same wyniki. To, którego użyjesz, 
# będzie w dużej mierze zależeć od danej sytuacji, a także Twoich preferencji.

#### Zadanie 1
# 1. Upewnij się, że masz załadowany zbiór danych `mpg`, wpisując `data(mpg)` (i `library(ggplot2)`
# , jeśli jeszcze tego nie zrobiłeś!). Użyj funkcji „table”, aby dowiedzieć się, 
# ile samochodów zbudowało *merkury*?
 

# 2. Jaki jest średni rok produkcji Audi w tym zbiorze danych? 
# Użyj funkcji „średnia” w podzbiorze kolumny „rok”, który odpowiada „audi”. 
# (Uważaj: podzbiór `tibble` zwraca `tibble` (a nie wektor)!. 
# więc kolumnę `rok` uzyskaj po podzieleniu `tibble`.)

# 3. Użyj powyższej składni potoku `dplyr`, najpierw z `group_by`, 
# a następnie z `summarise(newvar=your_expression)`, 
# aby znaleźć średni `rok` dla wszystkich producentów 
# (tj. tak samo jak poprzednie zadanie, ale dla wszystkich producentów. nie pisz pętli!).


### Przykład: Importowanie danych w formacie Excel'a
# Dane, którym się przyjrzymy, pochodzą z Eurostatu
# (http://ec.europa.eu/eurostat/data/database) dotyczące demografii i migracji. 
# pobierz dane z repozytorium!
# lub pobierz samodzielnie (kliknij poprzedni link, a następnie przejdź do 
# *bazy tematycznej > Ludność i warunki społeczne > Demografia i migracje > 
#   Zmiany demograficzne - Bilans demograficzny i wskaźniki ropy naftowej na 
# poziomie krajowym (demo_gind)*).

# Po pobraniu możemy odczytać dane za pomocą funkcji `read_excel` z pakietu `readxl`
# (http://readxl.tidyverse.org), ponownie będącego częścią pakietu `tidyverse`.

# Ważne jest, aby wiedzieć, jak zorganizowane są dane w arkuszu kalkulacyjnym. Otwórz plik w programie Excel, aby zobaczyć:

# Teraz odczytamy dane
library(readxl)
library(dplyr)
library(tidyr)

# dane o populacji
tot_pop_raw = read_excel(
              path="C:/Users/szalas/OneDrive/_ekonometria2023/_5_data_management/demoxls.xls", 
              sheet="demo", # wybieramy arkusz
              range="A1:Q1522")  # wybieramy zakres komórek do wczytania
tot_pop_raw

# rozdziel pierwszą kolumnę
tot_pop_raw = tot_pop_raw %>% 
              separate(`indic_de,geo\\time`, into = c("indicator", "country"), sep = ",")


# To pokazuje „tibble”, które napotkaliśmy tuż powyżej. Nazwy kolumn to 
# „Kraj, 2008, 2009,...”, a wiersze są ponumerowane „1,2,3,...”. 
# Zwróć w szczególności uwagę, że *wszystkie* kolumny wydają się być typu 
# `<chr>`, czyli znaki - ciąg znaków, a nie liczba! 
# Musimy to naprawić, ponieważ są to wyraźnie dane liczbowe.

#### tidyr

# W poprzednim „tibble” każdy rok był nazwą kolumny (np. „2008”), a nie wszystkie
# lata były zbierane w jednej kolumnie „rok”. Naprawdę chcielibyśmy mieć kilka 
# wierszy dla każdego kraju, po jednym wierszu na rok. Aby to uporządkować, 
# chcemy gather() - zebrać wszystkie lata w nowej kolumnie — a oto jak to zrobić:
  
# 1. określ, które kolumny mają być gromadzone: w naszym przypadku wszystkie lata 
# (zwróć uwagę, że `paste(2008:2023)` tworzy wektor typu `["2008", "2009", "2010",...]` )

# 2. powiedz, w jakie kolumny powinny być zebrane, tj. jaki jest *klucz* 
# dla tych wartości: nazwiemy to „year”.

library(tidyr)   # gather()
tot_pop = gather(tot_pop_raw, paste(2008:2023),key="year", value = "counts")
tot_pop

# mamy różne wskaźniki demograficzne
table(tot_pop$indicator)

# install.packages("countrycode")
library(countrycode)
help(countrycode)

# nie mamy nazw krajów, możemy jednka zm ieć kody na nazwy, korzystając z `countrycode`
tot_pop$country2 = countrycode(tot_pop$country, origin = 'eurostat', destination = 'country.name')

tot_pop %>% select(c("country", "country2")) %>% filter(is.na(country2)==TRUE)

tot_pop = tot_pop %>% select(!c("country")) %>% filter(is.na(country2)==FALSE)

names(tot_pop)[4] <- "Country"   # zmiana nazwy pierwszej kolmny

tot_pop

# Tak jest lepiej! Jednak „counts” to nadal „chr”! Zamieńmy to na liczbę:
tot_pop$counts2 = as.integer(tot_pop$counts)

# zobaczmy co powoduje powstawanie missingów?
tot_pop %>% select(c("counts", "counts2")) %>% filter(is.na(counts2)==TRUE)

# install.packages("gsubfn")
library(gsubfn)
tot_pop$counts = gsub('b', '', tot_pop$counts)
tot_pop$counts = gsub('p', '', tot_pop$counts)
tot_pop$counts = gsub('e', '', tot_pop$counts)

tot_pop$counts = as.integer(tot_pop$counts)

# wyrzuć zmienną counts2 ze zbioru
tot_pop = tot_pop %>% 
  select(!c("counts2"))

# Teraz możesz zobaczyć, że kolumna „counts” jest rzeczywiście „int”, 
# tj. liczbą całkowitą, i wszystko w porządku. `Warning: NAs introduced by coercion` 
# oznacza, że  „R” przekonwertował niektóre wartości na „NA”, ponieważ nie mógł 
# ich przekonwertować na „numeryczne”. Więcej poniżej!
tot_pop

#### `dplyr`

# Rozdział [transform](http://r4ds.had.co.nz/transform.html) książki Hadley Wickhams 
# jest doskonałym miejscem, aby przeczytać więcej na temat używania `dplyr`.

# Za pomocą `dplyr` możesz wykonać następujące operacje na `data.frame` i `tibble`s:

# * Wybierz obserwacje w oparciu o określoną wartość (tj. podzbiór): `filter()`
# * Zmień kolejność wierszy: `arrange()`
# * Wybierz zmienne według nazwy: `select()`
# * Utwórz nowe zmienne z istniejących: `mutate()`
# * Podsumuj zmienne: `summarise()`

# Wszystkich tych czasowników można używać z funkcją „group_by()”, gdzie wykonujemy 
# odpowiednią operację na *grupie* ramki danych/tibble. 
# Na przykład na naszym tibble `tot_pop` zrobimy to teraz

# * filter
# * mutate
# * rysowanie uzyskanych wartości

# Zróbmy wykres przedstawiający populację Francji, Wielkiej Brytanii i Włoch 
# na przestrzeni czasu, w milionach ludzi. Wykorzystamy składnię `piping' `dplyr', 
# którą przedstawiliśmy tuż powyżej.
library(dplyr)  #  %>%, filter, mutate, ...
library(ggplot2)

# 1. weź dane `tot_pop`
tot_pop %>% 
  # 2. Odfiltruj dane o populacji
  filter(indicator=="AVG") %>%
  # oraz wybierz tylko 3 kraje
  filter(Country %in% c("France","United Kingdom","Italy")) %>%
  # 3. przeslij rezultat do funkcji mutate
  # wyraź dane w milionach, w nowej kolumnie
  mutate(millions = counts / 1e6) %>%
  # 4. przeslij dane i narysuj wykres
  ggplot(mapping = aes(x=year,y=millions,color=Country,group=Country)) + geom_line(size=1)

#### uporządkowanie `tibble`

# * Jakie jest 5 najbardziej zaludnionych obszarów?

top5 = tot_pop %>% filter(indicator=="AVG") %>%
arrange(desc(counts)) %>%  # ustaw w malejącej kolejności kolumnę `counts`
top_n(5)

bottom5 = tot_pop %>% filter(indicator=="AVG") %>%
arrange(desc(counts)) %>%
top_n(-5)
# zobaczmy top 5
top5

# zobaczmy bottom 5
bottom5

# To nie jest dokładnie to, czego chcieliśmy. Zawsze jest to ten sam kraj zarówno 
# na górze, jak i na dole, ponieważ na każdy kraj przypada wiele lat. 
# Obliczmy średnią populację z ostatnich 10 lat i uszeregujmy:

topbottom = tot_pop %>% filter(indicator=="AVG") %>%
  group_by(Country) %>%
  filter(year > 2012) %>%
  summarise(mean_count = mean(counts, na.rm = TRUE)) %>%
  arrange(desc(mean_count))

top5 = topbottom %>% top_n(5)
bottom5 = topbottom %>% top_n(-5)
top5
bottom5                     

#### braki danych -`NA` - w `tibble`
# Czasami pojwiają się *braki danych* i `R` reprezentuje je specjalną wartością `NA` (niedostępne). 
# Dobrze jest wiedzieć, gdzie w naszym zbiorze danych natkniemy się na brakujące wartości, 
# więc zadanie jest następujące: utwórzmy tabelę zawierającą trzy kolumny:

# 1. nazwy krajów, w których brakuje danych
# 2. ile lat brakuje danych w przypadku każdego z nich
# 3. i faktyczne brakujące lata
library(knitr)
missings = tot_pop %>% 
  filter(indicator=="AVG") %>%
  filter(is.na(counts)) %>% # is.na(x) returns TRUE if x is NA
  group_by(Country) %>%
  summarise(n_missing = n(), years = paste(year, collapse = ", "))
missings

#### Kobiety i mężczyźni 

# Przyjrzyjmy się liczbom według populacji mężczyzn i kobiet. 
# Znajdują się w tym samym pliku:
females = tot_pop %>% filter(indicator=="FAVG")
males = tot_pop %>% filter(indicator=="MAVG")

# Spróbujmy zmodyfikować wcześniejszy wykres, aby pokazać te same dane w dwóch 
# oddzielnych panelach: jednym dla mężczyzn i jednym dla kobiet. 
# Najłatwiej to zrobić za pomocą `ggplot`, jeśli mamy wszystkie dane w jednej 
# `data.frame` (lub `tibble`) i oznaczone *identyfikatorem grupy*. 
# Najpierw dodajmy to do obu zbiorów danych, a następnie połączmy oba w jeden:

females$sex = "female"
males$sex = "male"
sexes = rbind(males,females)   # "row bind" 2 data.frames
sexes

# Teraz, gdy wszystkie dane są uporządkowane w `data.frame`, wprowadzamy bardzo 
# małą zmianę w stosunku do naszego poprzedniego kodu rysującego wykres:
  
sexes %>%
 filter(Country %in% c("France","United Kingdom","Italy")) %>%
 mutate(millions = counts / 1e6) %>%
 ggplot(mapping = aes(x=as.Date(year,format="%Y"),  # convert to `Date`
                      y=millions,colour=Country,group=Country)) + 
 geom_line() +
 scale_x_date(name = "year") + # rename x axis
 facet_wrap(~sex)   # make two panels, splitting by groups `sex`

#### porównanie do Niemiec

# Jak nasze trzy kraje wypadają na tle największego kraju UE pod względem 
# liczby ludności? Na przykład, jaką *ułamek* Niemiec stanowi ludność francuska w danym roku?
  
# pamiętaj, że operator potoku %>% przyjmuje
# wynik poprzedniej operacji i przekazuje go
# jako *pierwszy* argument następnego wywołania funkcji

merge_GER <- tot_pop %>% 
                filter(indicator=="AVG") %>%
 # 1. wybierz kraje które nas interesują
 filter(
   Country %in% 
     c("France",
       "United Kingdom",
       "Italy")
 ) %>%
 # 2. pogrupuj dane po latach
 group_by(year) %>%
 # 3. dołącz wartości dla Niemiec jako nową kolumnę *by year*
 left_join(
   # Germany only
   filter(tot_pop ,
          indicator=="AVG",
            Country %in% "Germany"),
   # połącz po latacg
   by="year")
merge_GER

# Tutaj widzisz, że operacja merge (lub join) oznaczona jako „col.x” i „col.y” jeśli
# oba zbiory danych zawierały kolumnę o nazwie „col”. Teraz kontynuujmy obliczanie, 
# jaką część populacji Niemiec stanowi każdy kraj:

names(merge_GER)[4] <- "Country"
merge_GER %>%
mutate(prop_GER = 100 * counts.x / counts.y) %>%
# 5. wykres
ggplot(mapping = 
  aes(x = year,
  y = prop_GER,
  color = Country,
  group = Country)) + 
  geom_line(size=1) + 
  scale_y_continuous("percent of German population") + 
  theme_bw()  # theme

