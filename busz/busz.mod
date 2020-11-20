set Stations;
set People;

param busCount;
set Busses := 1.. busCount;

param traveltime {Stations};

# mikor fog kezdődni a munka
param workstart {People};
param workplace {People} symbolic;

param M := 300;

var board {People, Busses} binary;
var arrive {People} >= 0;
var start {Busses} >= 0;

s.t. EveryboardsOneBusExactly {person in People}:
  sum {bus in Busses} board[person, bus] = 1;

s.t. EverybodyShouldGetToWorkOnTime {person in People}:
  arrive[person] <= workstart[person];

s.t. SetArrivalTime1 {person in People, bus in Busses}:
  arrive[person] >= start[bus] + traveltime[workplace[person]] - M * (1 - board[person, bus]);

s.t. SetArrivalTime2 {person in People, bus in Busses}:
  arrive[person] <= start[bus] + traveltime[workplace[person]] - M * (1 - board[person, bus]);

minimize TotalWastedTimeBeforeWork:
  sum {person in People} (workstart[person] - arrive[person]);

solve;

for {bus in Busses}
{
  printf "Bus %d starts from A at: %g\n", bus, start[bus];
  printf "  ";
  for {station in Stations}{
    printf "%s(%g) ", station, start[bus] + traveltime[station];
  }
  printf "\n\n";
  for {person in People : board[person, bus] = 1}{
    printf "\t%s travels to %s, arrives at %g, waits %g until %g\n", person, workplace[person], arrive[person], workstart[person] - arrive[person], workstart[person];
  }
}

printf "\nTotal wasted time: %g\n", sum {person in People} (workstart[person] - arrive[person]);

end;
