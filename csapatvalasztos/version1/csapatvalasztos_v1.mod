set People;
set Skills;

param knows {People, Skills} binary;
param love {People};

var team {People, Skills} binary;

s.t. FillAllPositions {skill in Skills}:
  sum {person in People} knows[person, skill] * team[person, skill] >= 1;

maximize Love {person in People}:
  sum {skill in Skills} team[person, skill] * love[person];

solve;

for {skill in Skills}{
  printf "%10s:\t", skill;
  for {person in People: team[person, skill] == 1}{
    printf "%s\n", person;
  }
}

/*

kimenet:

  frontend:	David
   backend:	Tibor
  database:	Botond
       css:	Tibor
     agile:	Botond
    devops:	Bence

*/

end;