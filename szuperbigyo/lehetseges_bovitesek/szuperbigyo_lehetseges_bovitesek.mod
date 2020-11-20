param numberOfDays >= 0, integer;
set Days := 1..numberOfDays;

set RawMaterials;
param szuperbigyoIncome {Days, RawMaterials} >= 0; # kg
param price {RawMaterials} >= 0;

set Orders;
param szuperbigyoNeeded {Orders, RawMaterials}; # kg
param manufacturingDay {Orders};
param profit {Orders};
param hours {Orders};
param maxHours;

param maxStorageCapacity >= 0; # kg
param maxStorageCapacityDay >= 0, integer; # kg

var manufacture {Orders} binary;

set StorageDayPairs := setof {day1 in Days, day2 in Days: day2 > day1 && day2 <= day1 + maxStorageCapacityDay} (day1, day2);
var szuperbigyoStorage {RawMaterials, StorageDayPairs} >= 0;
var szuperbigyoThrowAway {Days, RawMaterials} >= 0;
var szuperbigyoBuy {day in Days, material in RawMaterials} >= 0;

s.t. Initial:
  sum {material in RawMaterials, (0, day2) in StorageDayPairs} szuperbigyoStorage[material, 0, day2] = 0;

s.t. NextDay {day in Days, material in RawMaterials}: 
  sum {(day, day2) in StorageDayPairs} szuperbigyoStorage[material, day, day2] + szuperbigyoThrowAway[day, material] = 
  sum {(day1, day) in StorageDayPairs} szuperbigyoStorage[material, day1, day] + szuperbigyoIncome[day, material] -
  sum {order in Orders: manufacturingDay[order] == day} szuperbigyoNeeded[order, material] * manufacture[order] + szuperbigyoBuy[day, material];

s.t. MaxStorage {day in Days, material in RawMaterials}:
  sum {(day1, day2) in StorageDayPairs: day1 <= day && day2 > day} szuperbigyoStorage[material, day1, day2] <= maxStorageCapacity;

s.t. WorkDayHours {day in Days}:
  sum {order in Orders: manufacturingDay[order] == day} manufacture[order] * hours[order] <= maxHours;

maximize Profit:
  sum {order in Orders} profit[order] * manufacture[order] - 
  sum {day in Days, material in RawMaterials} szuperbigyoBuy[day, material] * price[material];

solve;

for {day in Days, order in Orders: manufacturingDay[order] == day}{
  for {material in RawMaterials, (day, day1) in StorageDayPairs: szuperbigyoThrowAway[day, material] > 0}{
    printf "Day%s\t%s\t%s\t%g\n", day, order, material, szuperbigyoStorage[material, day, day1];
  }
  printf "\n";
}

/*
1	37    37
2	32    107
3	47    122
4	45    120
5	1     76

1	60
2	130
3	145
4	143
5	99

1	37
2	107
3	122
4	120
5	76

*/

end;
