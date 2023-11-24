# Ekonometria-WNE-2023-2024
Repozytorium zawiera materiały do ćwiczeń z Ekonometrii w semestrze zimowym r. a. 2023/2024 dla grup numer 303, 310, 311.

## Informacje
- Kontakt: s.zalas@uw.edu.pl (nie mam adresu w domenie WNE)
- Konsulatcje: TBA, w razie potrzeby proszę o kontakt mailowy.
- Terminy kartkówek: TBA
- Termin kolokwium: TBA
- Ocena z ćwiczeń: 20% kartkówki, 40% kolokwium, 40% projekt.
- Konkurs modeli: osoby z najlepszymi projektami mogą być zwolnione z egzaminu, pod warunkiem uzyskania co najmniej oceny 4 z kolokwium.

## Zajęcia
1. **4-5 października 2023: powtórzenie z algebry.**
  - Omówiliśmy ogólne warunki zaliczenia.
  - Powtórzyliśmy podstawowe pojęcia z algebry liniowej.
  - Zrobiliśmy zadania 1-6 oraz 9-12.
  - W folderze znajdują się notatki przerabiane na zajęciach oraz rozwiązania zadań.
2. **10-11 października 2023: powtórzenie ze statystki oraz r. prawdopodobieństwa.**
  - Powtórzyliśy zagadnienia związane z rach, prawdopodobieństwa: wartość oczekiwana, wariancja  oraz ich wielowymiarowe uogólnienia
  - Zadania 1,2,3,4,5,6,10 oraz 2 i 3 z rozkładu normalnego - rozwiązania są opublikowane
3. **18-19 października 2023**
  - Zrobiliśmy wprowadzenie do R.
  - Pracowaliśmy z plikiem _intro_notebook.Rmd
    - Aby otworzyć plik w domu należy zainstalować pakiety 'knitr' oraz 'rmarkdown. Po ich zainstalowaniu proszę skorzystać z opcji KNITR.
    - W razie problemów prosze o kontakt.
    - Można także skorystać z pliku _intro_notebook.html i otworzyć go w przeglądarce.
4. **25-26 października 2023**
  - Metoda Najmniejszych Kwadratów
5. **8-9 listopada 2023**
  - Kartkówka nr 1.
  - Manipulowanie danymi w R - zobacz kod w folderze nr 5.
6. **15-16 listopada 2023**
  - Współczynnik determinacji, interpratacja parametrów, transforacja logarytmiczna - materiały są dostepne.
7. **22-23 listopada 2023**
  - TBA - Kartkówka nr 2.
# Gender Board Diversity Dataset
This repository contains dataset and STATA programs written for its production.


## Authors and contact
The authors of the programs are Hubert Drążkowski and Sebastian Zalas. 
In case of question and comments, please send them an e-mail.

## Dataset description
*to do*

## Codes description
Processing data about managers was the main axis our of work, but we also organized other areas of the Orbis database. Thus first, we describe codes written for processing managers data. Then we introduce other programs. We worked on STATA 17.

### Codes for mangement data processing 
These codes constitute a complete sequence; output from predecessor is a input for the next code.

- `_managers_1_prepare.do` - this code extracts variables describing managers data from each wave of Amadeus/Orbis database

- `_managers_2_bycountry.do` - this code connects manager data from all waves and saves them in separate file for each country 

- `_managers_3_legalform.do` - this code we predicts wheter firm should have management board and (or) supervisory board. We use legal form reported by the company itself and gathered information on corporate system in given country. At this stage we drop firms which should not have boards according to legal system.
							
- `_managers_4_function.do` -  basing on variables which describe function and position of manager, we assign them to board categories. Later, from this assignment we build three board categories: management board, supervisory board and ambigous board. The last one is the category with managers which take top-management positions in companies, but due to lack of information we were not able to assign them to management or supervisory board.

- `_managers_5_gender.do` - this code assigns gender to managers. This code prepares names and surnames of managers, cleans them from diacrytic signs, detects and drops legal persons.

- `_managers_6_person_level.do` - this code assigns to each manager a time in which she/he was present in assigned board and thus produces a firm-person level database

- `_managers_7_firm_level.do` - this code collapse person level data from previous step to firm level.

- `_gender_board_diversity_dataset` - this code produces **Gender Board Diversity Dataset**, which is uploaded in this repository

### Additional routines
- `_nace.do` - prepares a NACE rev. 2 industry code for firms. Due to the fact that NACE classification changed over time, we adjust all codes with NACE rev. 2 classification.
- `_nace_crosswalk_nace1_to_nace11.do` and `_nace_crosswalk_nace1_to_nace11.do` contain crosswalks between NACE rev. 1, NACE rev. 1.1 and NACE rev. 2

- `_listed.do` - this code gathers the information from all waves wheterf firm was listed on stock exchange and in which years


- _listed.do - this code gathers the information from all waves wheterf firm was listed on stock exchange and in which years


  
