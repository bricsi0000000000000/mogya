param numberOfDays;

set Days := 1..numberOfDays;
set Cars;

param price {Cars, Days};
param initialBudget;
param garageCount;
param interest;
param garagePricePerDay;

var buy {Cars, Days} integer;
var budget {0..numberOfDays} >= 0;
var carInGarage {Cars, 0..numberOfDays} >= 0;

# negatív: visszafizetünk a bankba, pozitív: veszünk fel a banktól
var loan {Days}; 

# Mennyi az egyenlegünk a banknál
var bankBalance{0..numberOfDays} <= 0, >= -200000; # Nem fogunk plusz pénzt befizetni, hogy aztán kivegyük

# hány garázst bérlünk egy adott nap még pluszba
var rentGarage {Days} >= 0 integer; # Azért nagyobb mitn 0, mert nem tudjuk bérbe adni

s.t. InitializeBudget:
  budget[0] = initialBudget;

s.t. InitializeGarage {car in Cars}:
  carInGarage[car, 0] = 0;

# Inicializáljuk a banki tartozásunkat
s.t. InitialBankBalance:
  bankBalance[0] = 0;

s.t. BalanceChange {day in Days}:
  # budget[day] = budget[day - 1] - sum{car in Cars} buy[car, day] * price[car, day];
  budget[day] = budget[day - 1] - sum{car in Cars} buy[car, day] * price[car, day] + loan[day] - rentGarage[day] * garagePricePerDay;

s.t. BankBalanceChange {day in Days}:
  bankBalance[day] = bankBalance[day - 1] * (1 + interest) - loan[day];

# Az utolsó napon 0-nak kell lennie a 'balance'-nak
s.t. NoLoansAtTheEnd:
  bankBalance[numberOfDays] = 0;

s.t. CarAvailability {day in Days, car in Cars}:
  carInGarage[car, day] = carInGarage[car, day - 1] + buy[car, day];

s.t. CannotHaveMoreCarsThanGarageCount {day in Days}:
  sum{car in Cars} carInGarage[car, day] <= garageCount + rentGarage[day];

maximize endBudget:
  budget[numberOfDays];

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

  printf "\tBank: %d\n", bankBalance[day - 1] * (1 + interest);
  printf "\tLoan: %d\n", loan[day];
  printf "\tGarage rent: %d\n", rentGarage[day];
  printf "\tBudget: %d\n", budget[day];
  printf "\tBank: %d\n", bankBalance[day];
}

printf "\n\n";

/*

Kimenet:

Day 1
	Sell: 
	Buy: Lada(4) 
	Bank: 0
	Loan: 0
	Garage rent: 0
	Budget: 0
	Bank: 0
Day 2
	Sell: Lada(4) 
	Buy: Trabant(6) 
	Bank: 0
	Loan: 178000
	Garage rent: 2
	Budget: 0
	Bank: -178000
Day 3
	Sell: Trabant(6) 
	Buy: Skoda(6) 
	Bank: -186900
	Loan: -4000
	Garage rent: 2
	Budget: 0
	Bank: -182900
Day 4
	Sell: Skoda(6) 
	Buy: Trabant(6) 
	Bank: -192045
	Loan: -22000
	Garage rent: 2
	Budget: 0
	Bank: -170045
Day 5
	Sell: Trabant(6) 
	Buy: 
	Bank: -178547
	Loan: -178547
	Garage rent: 0
	Budget: 421453
	Bank: 0

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
param interest := 0.05;
param garagePricePerDay := 4000;

end;
