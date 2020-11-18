param numberOfDays >= 0, integer;
set Days := 1..numberOfDays;

# melyik nap mennyi kg jön
param szuperbigyoIncome {Days} >= 0; # kg

set Orders;
param profit {Orders} >= 0;
param szuperbigyoNeeded {Orders} >= 0; # kg
param manufacturingDay {Orders};

var manufacture {Orders} binary;

s.t. ReasourceBalanced {day1 in Days}:
  sum {order in Orders: manufacturingDay[order] <= day1} szuperbigyoNeeded[order] * manufacture[order] <= sum {day2 in 1..day1} szuperbigyoIncome[day2];

maximize Profit: sum {order in Orders} profit[order] * manufacture[order];

solve;

end;
