param numberOfDays;

set Days := 1..numberOfDays;
set Cars;

param price {Cars, Days};
param initialBudget;
param garageCount;

var buy {Cars, Days} integer;

# Mennyi pénzünk van egy adott nap végén
var budget {0..numberOfDays} >= 0; #redundáns változó

# Egy adoot autóból mennyi van egy adott nap végén
var carInGarage {Cars, 0..numberOfDays} >= 0; #redundáns változó

# Össze kell kötni a plusz redundáns változókat a valós döntési változóval, amiket korlátozásokkal érünk el
s.t. InitializeBudget:
  budget[0] = initialBudget;

s.t. InitializeGarage {car in Cars}:
  carInGarage[car, 0] = 0;

s.t. BalanceChange {day in Days}:
  budget[day] = budget[day - 1] - sum{car in Cars} buy[car, day] * price[car, day];

s.t. CarAvailability {day in Days, car in Cars}:
  carInGarage[car, day] = carInGarage[car, day - 1] + buy[car, day];


/* 
A 'var budget {Days} >= 0;' miatt ez a korlátozás már nem kell
s.t. MustHavePositiveBalanceAtTheEndOfEachDay {day1 in Days}:
  initialBudget - sum {day2 in 1..day1,car in Cars} buy[car, day2] * price[car, day2] >= 0;
*/

s.t. CannotHaveMoreCarsThanGarageCount {day in Days}:
  #sum {day2 in 1..day1, car in Cars} buy[car, day2] <= garageCount;
  sum{car in Cars} carInGarage[car, day] <= garageCount;

/*
A 'var carInGarage {Cars, Days} >= 0;' miatt ez a korlátozás már nem kell, mert lekezeli, hogy nem lehet negatív számú autónk
s.t. CannotSellWhatWeDontHave {day1 in Days, car in Cars}:
  sum {day2 in 1..day1} buy[car, day2] >= 0;
*/

maximize endBudget:
  #initialBudget - sum{day in Days, car in Cars} buy[car, day] * price[car, day];
  budget[numberOfDays]; # Mennyi a pénzünk az utolsó napon

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

  #printf "Budget: %d\n", initialBudget - sum {day2 in 1..day, car in Cars} buy[car, day2] * price[car, day2];
  printf "Budget: %d\n", budget[day];
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
