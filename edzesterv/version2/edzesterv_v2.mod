param dayCount;
set Days := 1..dayCount;

param freeTime {Days}; # hour
param rain {Days}; # 1: rain, 0: no rain

set Sports;
set DrySports within Sports;
param overhead {Sports}; # hour
param speed {Sports}; # km/h
param minDistance {Sports}; # km

param favorite symbolic in Sports;

set PossibleTrainings := 
setof {
  day in Days, sport in Sports diff DrySports:
    # overhead[sport] < freeTime[day] &&
    # if sport in DrySports then rain[day] != 0;
    overhead[sport] < freeTime[day]
} (day, sport)
union setof{
  day in Days, sport in DrySports:
    overhead[sport] < freeTime[day] &&
    rain[day] == 0
} (day, sport)
;

# var train {Days, Sports} binary;
var train {PossibleTrainings} binary;

s.t. SportSelection {day in Days}:
  # sum {sport in Sports} train[day, sport] <= 1;
  sum {(day, sport) in PossibleTrainings} train[day, sport] <= 1;

/*
s.t. SportSelection2 {day in Days, sport in Sports: overhead[sport] >= freeTime[day]}:
  train[day, sport] = 0;
*/

/*
s.t. NoDrySportsOnRainyDay {day in Days, sport in DrySports: rain[day] == 1}:
  train[day, sport] = 0;
*/

s.t. Variety {(day, sport) in PossibleTrainings: day != 1 && (day - 1, sport) in PossibleTrainings}:
  train[day, sport] + train[day - 1, sport] <= 1;

s.t. MinimumDistance {sport in Sports}:
  # sum {day in Days} train[day, sport] * (freeTime[day] - overhead[sport]) * speed[sport] >= minDistance[sport];
  sum {(day, sport) in PossibleTrainings} train[day, sport] * (freeTime[day] - overhead[sport]) * speed[sport] >= minDistance[sport];

# maximize RunningDays: sum {day in Days} train[day, favorite];
maximize RunningDays: sum {(day, favorite) in PossibleTrainings} train[day, favorite];

solve;

for {day in Days}{
  for {(day, sport) in PossibleTrainings: train[day, sport] == 1}{
    printf "Day %2d: %s \t%g hours \t%g km\n", day, sport, freeTime[day] - overhead[sport], (freeTime[day] - overhead[sport]) * speed[sport];
  }
}

printf "\n\n";
printf "%10s\tDays\tTotal km\n", "Sport";
for {sport in Sports}{
  printf "%10s\t%2d\t%g\n", sport, sum {(day, sport) in PossibleTrainings} train[day, sport], sum {(day, sport) in PossibleTrainings} train[day, sport] * (freeTime[day] - overhead[sport]) * speed[sport];
}

/*

Kimenet:

Day  1: Running 	1.6 hours 	19.2 km
Day  2: Skating 	0.8 hours 	14.4 km
Day  3: Swimming 	5.4 hours 	11.88 km
Day  4: Running 	1.9 hours 	22.8 km
Day  5: Cycling 	0.9 hours 	22.5 km
Day  6: Running 	5.1 hours 	61.2 km
Day  8: Cycling 	5.4 hours 	135 km
Day  9: Running 	4.3 hours 	51.6 km
Day 10: Skating 	4.2 hours 	75.6 km
Day 11: Running 	2.2 hours 	26.4 km
Day 13: Running 	4.3 hours 	51.6 km
Day 14: Cycling 	5.3 hours 	132.5 km
Day 15: Running 	6.5 hours 	78 km
Day 16: Cycling 	1.6 hours 	40 km
Day 17: Running 	7.2 hours 	86.4 km
Day 18: Cycling 	3.8 hours 	95 km
Day 19: Running 	7.5 hours 	90 km
Day 20: Skating 	1 hours 	18 km
Day 21: Running 	3.7 hours 	44.4 km
Day 23: Running 	5.9 hours 	70.8 km
Day 25: Running 	1 hours 	12 km
Day 27: Running 	5.9 hours 	70.8 km
Day 28: Cycling 	7.2 hours 	180 km
Day 30: Running 	2.1 hours 	25.2 km


     Sport	Days	Total km
   Running	14	710.4
   Cycling	 6	605
   Skating	 3	108
  Swimming	 1	11.88

*/

end;
