######### Zadania z wprowadzenia do R #########################################
# 20/10/2023

###### Zadanie 1 ######
# Utwórz wektor pięciu jedynek, czyli: `[1,1,1,1,1]`
c(1,1,1,1,1)
rep(1, 5)

# Zauważ, że operator dwukropka `a:b` jest skrótem od  *konstruuj sekwencję 
# **od** `a` **do** `b`*. Utwórz wektor, od który będzie odliczał od 10 do 0, 
# czyli będzie wyglądał tak: `[10,9,8,7,6,5,4,3,2,1,0]`
10:0
seq(10, 0, -1)

# funkcja `rep` pobiera dodatkowe argumenty `times` i `each`, które mówią, 
# jak często *każdy element* powinien być powtarzany 
# (w przeciwieństwie do całego wektora wejściowego). 
# Użyj `rep`, aby utworzyć wektor wyglądający tak: 
# `[1 1 1 2 2 2 3 3 3 1 1 1 2 2 2 3 3 3]`
(wek2=rep( c(rep(1,3),rep(2,3),rep(3,3)),2 ))

###### Zadanie 2 ######
# Utwórz wektor wypełniony 10 liczbami wylosowanymi 
# z rozkładu jednostajnego (podpowiedź: użyj funkcji „runif”) 
# i zapisz je w `x`.
x = runif(10)

# Używając podzbioru logicznego jak powyżej, 
# zbierz wszystkie elementy `x`, 
# które są większe niż 0,5 i zapisz je w `y`. 
# używając funkcji „which”, zapisz *indeksy* wszystkich
# elementów „x”, które są większe niż 0,5 w „iy”.
(y = x[x>0.5])
iy = which(x>0.5)

# Sprawdź, czy „y” i „x[iy]” są identyczne.
y == x[iy]


#### Zadanie 3
# Utwórz wektor zawierający „1,2,3,4,5” o nazwie v.
v=1:5

# Utwórz macierz(2,5) `m` zawierającą dane `1,2,3,4,5,6,7,8,9,10`. Pierwszym wierszem powinno być „1,2,3,4,5”.
m = matrix(1:10, 2, 5, byrow = 1 )
m
rbind(v, 6:10)
# Wykonaj mnożenie macierzy `m` przez `v`. Użyj polecenia `%*%`. Jaki wymiar ma wyjście?
m%*%v

# Dlaczego `v %*% m` nie działa?
v%*%m


#### Zadanie 4
# Skopiuj i wklej powyższy kod z `ex_list` do swojej sesji R. 
# Pamiętaj, że `lista` może zawierać dowolny obiekt `R`. Jak... kolejna lista! 
# Utwórz więc nową listę „nowa_lista”, która ma dwa pola: 
# pierwsze pole o nazwie „to” z zawartością „jest niesamowity” i 
# drugie pole o nazwie „ex_list”, które zawiera „ex_list”.

ex_list = list(
  a = c(1, 2, 3, 4),
  b = TRUE,
  c = "Hello!",
  d = function(arg = 42) {print("Hello World!")},
  e = diag(5)
)

nowa_lista = list(
 a = "to",
 b =  "jest niesamowity",
 ex_list =  ex_list
)

# Dostęp do elementów odbywa się jak na zwykłej liście, 
# tylko z kilkoma warstwami. Pobierz element `c` z `ex_list` w `nowa_lista`!
nowa_lista$ex_list$c

# Utwórz nowy wyraz z pierwszego elementu w `nowa_lista', 
# elementu pod etykietą `this`. Użyj funkcji „paste”, 
# aby wydrukować na ekranie „R jest niesamowity”.
paste("R - ", nowa_lista$a, nowa_lista$b)
