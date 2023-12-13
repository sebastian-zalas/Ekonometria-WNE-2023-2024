

# 5. Usuń obserwacje z brakującymi danymi w STAF, AV, EMPL, STAF. 
# Czy występują ujemne wartości w tych zmiennych? Czy one maja˛ sens?

# usuwamy brakujące dane
firms = drop_na(firms, any_of( c("STAF", "AV", "EMPL", "TOAS") )  ) 

# czy są ujemne wartości w zmiennych
with(firms, table( sign(AV) ))
with(firms, table( sign(EMPL) ))
with(firms, table( sign(STAF) ))
with(firms, table( sign(TOAS) ))
# ujemne wartości nie mają w tym przypadku ekonomicznego  sensu, dlatego można je usunąć ze zbioru danych

# zostawmy tylko dodatnie wartości
firms = subset(firms, AV>0 & STAF>0 & TOAS>0 )
