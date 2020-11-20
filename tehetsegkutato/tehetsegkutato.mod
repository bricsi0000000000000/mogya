set People;

param numberOfTurns := card(People) - 1;
set Turns := 1..numberOfTurns;

# kinek mennyi sms-e jött
param sms {People};

var inDuel {People, Turns} binary;
var outDuel {People, Turns} binary;

# Egy valaki esik ki
s.t. OnePersonOut {turn in Turns}:
  sum {person in People} outDuel[person, turn] = 1;

# Egy valaki marad bent
s.t. OnlyOnePersonStays {turn in Turns}:
  sum {person in People} inDuel[person, turn] = 1;

# Egy ember nem eshet ki és maradhat bent egyszerre
s.t. InOrOut {turn in Turns, person in People}:
  inDuel[person, turn] + outDuel[person, turn] <= 1;

# Legfeljebb kétszer győz
s.t. MaximumTwoWins {person in People}:
  sum {turn in Turns} inDuel[person, turn] <= 2;

# Aki kiesett, kint is marad
s.t. IfOutStayOut {person in People, turn1 in Turns, turn2 in Turns: turn1 < turn2}:
  outDuel[person, turn2] <= 1 - outDuel[person, turn1];

# Aki kiesett, kint is marad
s.t. IfOutStayOut2 {person in People, turn1 in Turns, turn2 in Turns: turn1 < turn2}:
  inDuel[person, turn2] <= 1 - outDuel[person, turn1];

s.t. Constraint1 {person in People, turn1 in Turns, turn2 in Turns: turn1 < turn2}:
  outDuel[person, turn2] + inDuel[person, turn2] <= 1 - outDuel[person, turn1];

s.t. Constraint2 {person in People, turn1 in Turns}:
  outDuel[person, turn1] + inDuel[person, turn1] <= 1 - sum {turn2 in Turns: turn2 < turn1} outDuel[person, turn2];

maximize SMSCount: sum {person in People, turn in Turns} sms[person] * (outDuel[person, turn] + inDuel[person, turn]);

solve;

for {turn in Turns}{
  printf "%d: ", turn;
  for {person in People: inDuel[person, turn] == 1}{
    printf "\tbent marad: %s (%d)", person, sms[person];
  }
  for {person in People: outDuel[person, turn] == 1}{
    printf "\tkiesik: %s (%d)", person, sms[person];
  }
  printf "\n";
}

end;
