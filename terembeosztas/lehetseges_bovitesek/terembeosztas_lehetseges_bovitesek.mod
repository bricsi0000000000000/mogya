set Rooms;
param roomCapacity {Rooms} integer, >= 0;
param roomRentCost {Rooms}; # Ft/hour
# param computerRoom {Rooms} binary, default 0;
set ComputerRooms within Rooms;

set Classes;
param classHours {Classes} integer, >= 0;
param classMemberCount {Classes}  integer, >= 0;
param needComputers {Classes} binary, default 0;

set ClassPairs := setof{class1 in Classes, class2 in Classes: class1 != class2} (class1, class2);

set Lecturers;
param theLecturer {Classes} symbolic in Lecturers;

param numberOfDays;
set Days := 1..numberOfDays;

param openHoursStart;
param openHoursEnd;

param M;

var assign {Classes, Rooms, Days} binary;
var start {Classes} >= openHoursStart;
var before {ClassPairs} binary;

s.t. EveryClassMustBeAssigned {class in Classes}:
  sum {room in Rooms, day in Days} assign[class, room, day] = 1;

s.t. CapacityMustBeLargerThanStudentCount {room in Rooms, class in Classes, day in Days: roomCapacity[room] < classMemberCount[class]}:
  assign[class, room,day] = 0;

s.t. IfNeedsComputerMustBeAssignedToComputerRoom {class in Classes, room in Rooms diff ComputerRooms, day in Days: needComputers[class] == 1}:
  assign[class, room, day] = 0;

s.t. FinishBeforeClose {class in Classes}:
  start[class] + classHours[class] <= openHoursEnd;


s.t. TeacherCannotClone {lecturer in Lecturers, (class1, class2) in ClassPairs, day in Days: theLecturer[class1] = lecturer && theLecturer[class2] = lecturer}:
  # ha before[c1,c2] akkor start[c2] >= start[c1] + hours[c1]
  start[class2] >= start[class1] + classHours[class1] - M * (3 - before[class1, class2] - sum {room in Rooms} assign[class1, room, day] - sum {room in Rooms} assign[class2, room, day]);

s.t. PrecedenceBetweenClassesForTheSameTeacher {lecturer in Lecturers, (class1, class2) in ClassPairs, day in Days: theLecturer[class1] = lecturer && theLecturer[class2] = lecturer && class1 < class2}:
  before[class1, class2] + before[class2, class1] >= -1 + sum {room in Rooms} assign[class1, room, day] + sum {room in Rooms} assign[class2, room, day];


s.t. OneClassAtATimeInARoom {room in Rooms, (class1, class2) in ClassPairs, day in Days}:
  start[class2] >= start[class1] + classHours[class1] - M * (3 - before[class1, class2] - assign[class1, room, day] - assign[class2, room, day]);

s.t. PrecedenceBetweenClassesInTheSameRoom {room in Rooms, (class1, class2) in ClassPairs, day in Days: class1 < class2}:
  # Ha assign[c1,r] == 1 és assign[c2,r] == 1 akkor before[c1,c2] + before[c2,c1] = 1;
  before[class1, class2] + before[class2, class1] >= - 1 + assign[class1, room,day] + assign[class2, room,day];

/*
s.t. SetBeforesToZeroIfNotNeeded {(class1, class2) in ClassPairs, room1 in Rooms, room2 in Rooms, day in Days: room1 != room2 && theLecturer[class1] != theLecturer[class2]}:
  # ha assign[c1,r1] és assign[c2,r2], akkor before[c1,c2] = 0
  before[class1, class2] <= 2 - assign[class1, room1, day] - assign[class2, room2, day];
*/

minimize TotalCost: sum {class in Classes, room in Rooms,day in Days} assign[class, room, day] * classHours[class] * roomRentCost[room];

solve;

printf "\n\n";

printf "Total cost: %d\n\n", TotalCost;

param position {class1 in Classes, room in Rooms, day in Days: assign[class1, room, day] == 1} := 
  sum {class2 in Classes: class2 != class1 && assign[class2, room, day] == 1 && before[class2, class1] == 1} 1;

for {day in Days}{
  printf "############## Day %d############\n", day;

  for {room in Rooms: sum {class in Classes} assign[class, room, day] > 0}{
    for {{0}: room in ComputerRooms}{
      printf "Computer ";
    }
    printf "%s (capacity: %d):\n", room, roomCapacity[room];
    for {pos in 0..card(Classes)}{
      for {class in Classes: assign[class, room, day] == 1 && position[class, room, day] == pos}{
        printf " %2d-%2d: %s (%d hour, %d students)", start[class], start[class] + classHours[class], class, classHours[class], classMemberCount[class];
        for {{0}: needComputers[class]}{
          printf " - need computers";
        }
        printf "\n";
      }
    }
  }
  printf "################################\n\n\n";
}

printf "\n\n";

param lecturerPosition {class1 in Classes, day in Days} :=
  sum {class2 in Classes: class2 != class1 && theLecturer[class1] == theLecturer[class2] && before[class2, class1] && sum {room in Rooms} assign[class1, room, day] == 1} 1;

for {lecturer in Lecturers}{
  printf "%s:\n", lecturer;
  for {day in Days: sum {class in Classes, room in Rooms: theLecturer[class] == lecturer} assign[class, room, day] >= 1}{
    printf " Day %d: ";
    for {pos in 0..card(Classes)}{
      for {class in Classes, room in Rooms: theLecturer[class] == lecturer && lecturerPosition[class, day] == pos && assign[class, room, day] == 1}{
        printf "%2d-%2d: %s (%s)  ", start[class], start[class] + classHours[class], class, room;
      }
    }
    printf "\n";
  }
  printf "\n";
}

printf "\n\n";

end;

