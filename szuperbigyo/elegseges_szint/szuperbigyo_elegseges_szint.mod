param numberOfDays >= 0, integer;
set Days := 1..numberOfDays;

# melyik nap mennyi kg jön
param szuperbigyoIncome {Days} >= 0; # kg

set Orders;
param profit {Orders} >= 0;
# mennyi szuperbigyó kell az adott 'Order'-hez
param szuperbigyoNeeded {Orders} >= 0; # kg
# melyik 'Order'-t melyik napon fogunk legyártani
param manufacturingDay {Orders};

# legyártom e
var manufacture {Orders} binary;

# mennyi szuperbigyónk lesz a nap végén
var szuperbigyoAmount {Days union {0}} >= 0, <= szuperbigyoMaxCapacity;

s.t. ReasourceBalanced {day1 in Days}:
  sum {order in Orders: manufacturingDay[order] <= day1}
    szuperbigyoNeeded[order] * manufacture[order] <= sum {day2 in 1..day1} szuperbigyoIncome[day2];

s.t. InitializeSzuperbigyoAmount:
  szuperbigyoAmount[0] = 0;

# Itt csinálja meg, hogy melyik nap végére mennyi szuperbigyónk lesz
s.t. NextDay {day in Days}: szuperbigyoAmount[day] <= szuperbigyoAmount[day - 1] + 
      # Az adott napon mennyi szuperbigyó jön be, kivonom hogy az adott napon mennyi szuperbigyó kell
      szuperbigyoIncome[day] -
      sum {order in Orders: manufacturingDay[order] == day} szuperbigyoNeeded[order] * manufacture[order];

maximize Profit: sum {order in Orders} profit[order] * manufacture[order];

solve;

/*
for {order in Orders}{
  printf "%s\t%g\n", order, manufacture[order];
}
*/

for {day in Days, order in Orders: manufacturingDay[order] == day}{
  printf "%s\t%s\t%g\n", day, order, szuperbigyoAmount[day];
}

/*

Kimenet:

1	37
2	32
3	47
4	45
5	1 

*/

end;
