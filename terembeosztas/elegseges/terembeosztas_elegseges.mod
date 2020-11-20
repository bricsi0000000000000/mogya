set Rooms;
param roomCapacity {Rooms} integer, >= 0;
param roomRentCost {Rooms}; # Ft/hour

set Classes;
param classHours {Classes} integer, >= 0;
param classMemberCount {Classes}  integer, >= 0;

param totalHours;

param M;

# Melyik kurzus hol lesz (az adott teremben meg lesz e tartva vagy sem)
var assign {Classes, Rooms} binary;

# minden órát meg kell tartani -> minden órát legalább egy teremhez hozzá kell rendelni
s.t. EveryClassMustBeAssigned {class in Classes}:
  sum {room in Rooms} assign[class, room] = 1;

# egy teremhez nem lehet többet hozzárendelni mint 8 óra
s.t. ShouldNotExceedTimeLimit {room in Rooms}:
  sum {class in Classes} classHours[class] * assign[class, room] <= totalHours;
  # hány órát rendeltünk az adott teremhez

# nem rendelhetünk egy olyan teremhez órát, aminek nem elég nagy a kapacitása
#s.t. CapacityMustBeLargerThanStudentCount {room in Rooms, class in Classes: roomCapacity[room] <= classMemberCount[class]}:
#  assign[class, room] = 0;

s.t. CapacityMustBeLargerThanStudentCount {room in Rooms, class in Classes}:
  # Ha assign[class, room] == 1 akkor roomCapacity[room] >= classMembeCount[class];
  roomCapacity[room] >= classMemberCount[class] - M * (1 - assign[class, room]);

minimize TotalCost: sum {class in Classes, room in Rooms} assign[class, room] * classHours[class] * roomRentCost[room];

solve;

printf "\n\n";

printf "Total cost: %d\n\n", TotalCost;

for {room in Rooms: sum {class in Classes} assign[class, room] > 0}{
  printf "%s (capacity: %d):\n", room, roomCapacity[room];
  for {class in Classes: assign[class, room] == 1}{
    printf " - %s (%d hour, %d students)\n", class, classHours[class], classMemberCount[class];
  }
  printf "\n";
}

printf "\n\n";

end;

