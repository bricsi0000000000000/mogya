set People;
set Subjects;

param costs {Subjects, People} >= 0;

var buy {Subjects, People} binary;

s.t. MakeSubject {subject in Subjects}:
  sum {person in People} buy[subject, person] = 1;

s.t. MakeSubject1 {person in People}:
  sum {subject in Subjects} buy[subject, person] = 1;

minimize OverallCost {person in People}:
  sum {subject in Subjects} buy[subject, person] * costs[subject, person];

solve;

for {person in People}{
  printf "%s: ", person;
  for {subject in Subjects: buy[subject, person] == 1}{
    printf "%s", subject, buy[subject, person];
  }
  printf "\n";
}

/*

Kimenet:

Zsuzsi: Matek2
Dani: SZGM
Lilla: Diszkretmatek
Pisti: OOP
Marci: Algo

*/

end;
