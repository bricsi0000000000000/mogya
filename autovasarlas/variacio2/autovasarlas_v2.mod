param numberOfDays;

# 1-től egészen a 'numberOfDays'-ig tartson ez a halmaz
set Days := 1..numberOfDays;
set Cars;

param price {Cars, Days};
param initialBudget;
param garageCount;

/*
Egy adott autóból egy adott napon mennyit veszünk
Pozitív érték: annyit vettünk
Negatív érték: annyit adtunk el
Nulla érték: nem vettünk semmit
*/
var buy {Cars, Days} integer;

# Egyik nap sem költhetünk se többet, mint amennyi pénzünk van = Egyik nap végén se lehet a pénzünk negatív

s.t. MustHavePositiveBalanceAtTheEndOfEachDay {day1 in Days}:
  initialBudget - sum {day2 in 1..day1,car in Cars} buy[car, day2] * price[car, day2] >= 0;
  # Azért van kivonás, mert veszünk ('buy'). Ha -1-et veszünk (eladunk), akkor hozzáadja.

# Egyik nap végén se lehet a 'garageCount'-nál töb autónk
s.t. CannotHaveMoreCarsThanGarageCount {day1 in Days}:
  sum {day2 in 1..day1, car in Cars} buy[car, day2] <= garageCount;

# Csak olyan autókat adhatunk el, amik megvannak
s.t. CannotSellWhatWeDontHave {day1 in Days, car in Cars}:
  sum {day2 in 1..day1} buy[car, day2] >= 0;
  # Egy adott típusból mindegyik nap végén autóink száma >= 0

# Utolsó nap minél több pénzünk legyen
maximize endBudget:
  initialBudget - sum {day in Days, car in Cars} buy[car, day] * price[car, day];

solve;

printf "\n\n";

for {day in Days}{
  printf "Day %d\n", day;
  printf "\tSell: ";
  for {car in Cars: buy[car, day] < 0}{
    printf "%s(%d) ", car, -buy[car, day];
  }

  printf "\n";

  printf "\tBuy: ";
  for {car in Cars: buy[car, day] > 0}{
    printf "%s(%d) ", car, buy[car, day];
  }

  printf "\n";
  printf "\n";

  printf "Budget: %d\n", initialBudget - sum {day2 in 1..day, car in Cars} buy[car, day2] * price[car, day2];
}

printf "\n\n";

/*

Kimenet:

Day 1
	Sell: 
	Buy: Lada(4) 

Budget: 0
Day 2
	Sell: Lada(4) 
	Buy: Trabant(3) 

Budget: 25000
Day 3
	Sell: Trabant(3) 
	Buy: Skoda(3) 

Budget: 31000
Day 4
	Sell: Skoda(3) 
	Buy: Trabant(3) 

Budget: 46000
Day 5
	Sell: Trabant(3) 
	Buy: 

Budget: 346000

*/

data;

param numberOfDays := 5;

set Cars :=
Wartburg 
Lada     
Kispolski
Trabant  
Skoda
;

param price :
            1	      2	      3	        4	      5   :=
Wartburg	60000	  65000	  61000	    66000	  60000
Lada	    50000	  55000	  63000	    60000	  52000
Kispolski	30000	  32000	  33000	    30000	  27000
Trabant	  70000	  65000	  77000	    85000	  100000
Skoda	    65000	  70000	  75000	    90000	  70000
;

param initialBudget := 200000;
param garageCount := 4;

end;
