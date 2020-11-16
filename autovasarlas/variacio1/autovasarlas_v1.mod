set Days;
set Cars;

param price {Cars, Days};

# Egy adott autót egy adott napon megveszünk e
var buy {Cars, Days} binary;

# Egy napon csak egy autót vehetünk meg
s.t. ExactlyOneCarEachDay {day in Days}:
  sum {car in Cars} buy[car, day] = 1;

# Egy autót csak egyszer vehetünk meg
s.t. EachCarExactlyOnce {car in Cars}:
  sum {day in Days} buy[car, day] = 1;

# Összegezzük, hogy megvettük e az adott autót az adott napon * az adott autó ára az adott napon
minimize totalCost:
  sum{car in Cars, day in Days} buy[car, day] * price[car, day];

solve;

printf "\n\n";

for {car in Cars, day in Days: buy[car, day] == 1}{
  # %10s: 10 karakter szélesen ír ki egy stringet
  printf "%10s:%11s: %d Ft\n", car, day, price[car, day];
}

printf "\n\n";

data;

set Days := 
Hetfo
Kedd
Szerda
Csutortok
Pentek
;

set Cars :=
Wartburg 
Lada     
Kispolski
Trabant  
Skoda
;

param price :
          Hetfo	  Kedd	  Szerda	Csutortok	Pentek :=
Wartburg	60000	  65000	  61000	    66000	  60000
Lada	    50000	  55000	  63000	    60000	  52000
Kispolski	30000	  32000	  33000	    30000	  27000
Trabant	  70000	  65000	  77000	    85000	  100000
Skoda	    65000	  70000	  75000	    90000	  70000
;

end;
