set Classes;
set People;

param costs {Classes, People};

# ki mit csinál
var making {Classes, People} binary;

# minden tárgyból legalább 1 jegyzet
s.t. AllClassOnce {class in Classes}:
  sum {person in People} making[class, person] >= 1;

# mindenki legefeljebb 1 puskát vállal be
s.t. OnePersonOneClass {person in People}:
  sum {class in Classes} making[class, person] <= 1;

minimize Cost:
  sum {class in Classes, person in People} making[class, person] * costs[class, person];

solve;

printf "Cost: %d beer\n\n", Cost;
for {person in People, class in Classes: making[class, person] == 1}{
  printf "%s\t%s\n",person, class;
}

end;
