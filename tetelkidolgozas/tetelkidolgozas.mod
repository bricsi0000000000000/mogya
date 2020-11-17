set People;
set Subjects;

param costs {Subjects, People};

var buy {Subjects, People} binary;

s.t. MakeSubject {subject in Subjects}:
  sum {person in People} buy[subject, person] = 1;

s.t. MakeSubject1 {person in People}:
  sum {subject in Subjects} buy[subject, person] = 1;

minimize OverallCost:
  sum {subject in Subjects, person in People} buy[subject, person] * costs[subject, person];

solve;

for {person in People}{
  printf "%s: ", person;
  for {subject in Subjects: buy[subject, person] == 1}{
    printf "%s: %g", subject, costs[subject, person];
  }
  printf "\n";
}

/*

Kimenet:

Zsuzsi: Diszkretmatek: 8
Dani: SZGM: 8
Lilla: Matek2: 5
Pisti: Algo: 5
Marci: OOP: 14

*/

end;
