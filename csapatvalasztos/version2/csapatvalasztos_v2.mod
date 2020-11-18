set People;
set Skills;

param knows {People, Skills} binary;
param hate {People, People} binary;

# Csatlakozik e
var join {People};

# 1 ha person1 és person2 egy csapatba kerülnek, amúgy 0
var conflict {People, People} binary;

s.t. Constraint1 {skill in Skills}:
  sum {person in People} join[person] * knows[person, skill] >= 1;

s.t. Constraint2 {person1 in People, person2 in People}:
  (join[person1] + join[person2]) * hate[person1, person2] <= 1;

s.t. Constraint3 {person1 in People, person2 in People: hate[person1, person2] == 1 && person1 <= person2}:
  join[person1] + join[person2] <= 1;

s.t. Constraint4 {person1 in People, person2 in People: hate[person1, person2] == 1}:
  conflict[person1, person2] <= (join[person1] + join[person2]) / 2;

minimize Conflicts: sum {person1 in People, person2 in People} conflict[person1, person2] / 2;

solve;

# Nem jó



end;
