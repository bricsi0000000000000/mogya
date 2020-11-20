set People;
set Skills;

param knows {People, Skills} binary;
param hate {People, People} binary;

var team {People, Skills} binary;

s.t. FindPeopleForAllSkills {skill in Skills}:
  sum {person in People} knows[person, skill] * team[person, skill] >= 1;

minimize Conflict {person1 in People}:
  sum {skill in Skills, person2 in People} team[person1, skill] * hate[person1, person2];

solve;

for {person in People, skill in Skills: team[person, skill] >= 1}{
  printf "%10s:\t%s\n", person, skill;
}



end;
