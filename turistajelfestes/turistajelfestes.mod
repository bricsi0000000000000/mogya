set People;
set Tasks;

param previousTasks {Tasks} symbolic in Tasks;
param lastTask symbolic in Tasks;

param numberOfHours;
set Hours := 1..numberOfHours;

# Ki mit mekkora sebességel csinál meg
param speed {People, Tasks} >= 0; # km/h
param efficiency <= 1 >= 0;

var personWorkedInSpecificHour {People, Hours, Tasks} binary;
var progress {Hours union {0}, Tasks} >= 0;

# Egy ember egyszerre csak egy dolgot képes elvégezni
s.t. OneTaskPerPerson {person in People, hour in Hours}:
  sum {task in Tasks} personWorkedInSpecificHour[person, hour, task] <= 1;

# A feladatok nem előzhetik meg egymást
s.t. ProgressIsZeroAtStart {task in Tasks}:
  progress[0, task] = 0;

s.t. Progress {hour in Hours, task in Tasks}:
  progress[hour, task] <= progress[hour - 1, task] + sum {person in People} personWorkedInSpecificHour[person, hour, task] * speed[person, task] * efficiency;

s.t. TaskPrecedence {hour in Hours, task in Tasks}:
  progress[hour, task] <= progress[hour, previousTasks[task]];

maximize OverallProgress: progress[numberOfHours, lastTask];

solve;

for {hour in Hours}{
  printf "%d. ora:\n", hour;
  for {task in Tasks}{
    printf "\t%20s (%g -> %g): ", task, progress[hour - 1, task], progress[hour, task];
    for {person in People: personWorkedInSpecificHour[person, hour, task] == 1}{
      printf "%s ", person;
    }
    printf "\n";
  }
  printf "\n";
}

/*

Kimenet:

1. ora:
	              hantas (0 -> 13.6): Gabi Hedvig 
	  feher_alap_festese (0 -> 12.4): Bela Dia 
	         jel_festese (0 -> 10.4): Cili Elek 
	            lakkozas (0 -> 9.2): Andi Feri 

2. ora:
	              hantas (13.6 -> 27.2): Gabi Hedvig 
	  feher_alap_festese (12.4 -> 24.8): Bela Dia 
	         jel_festese (10.4 -> 22.4): Cili Elek 
	            lakkozas (9.2 -> 18.4): Andi Feri 

3. ora:
	              hantas (27.2 -> 40.8): Gabi Hedvig 
	  feher_alap_festese (24.8 -> 37.2): Bela Dia 
	         jel_festese (22.4 -> 34.4): Cili Elek 
	            lakkozas (18.4 -> 27.6): Andi Feri 

4. ora:
	              hantas (40.8 -> 54.4): Gabi Hedvig 
	  feher_alap_festese (37.2 -> 49.6): Bela Dia 
	         jel_festese (34.4 -> 46.4): Cili Elek 
	            lakkozas (27.6 -> 36.8): Andi Feri 

5. ora:
	              hantas (54.4 -> 68): Gabi Hedvig 
	  feher_alap_festese (49.6 -> 62): Bela Dia 
	         jel_festese (46.4 -> 58.4): Cili Elek 
	            lakkozas (36.8 -> 46): Andi Feri 

6. ora:
	              hantas (68 -> 81.6): Gabi Hedvig 
	  feher_alap_festese (62 -> 74.4): Bela Dia 
	         jel_festese (58.4 -> 70.4): Cili Elek 
	            lakkozas (46 -> 55.2): Andi Feri 

7. ora:
	              hantas (81.6 -> 88): Hedvig 
	  feher_alap_festese (74.4 -> 86.8): Bela Dia 
	         jel_festese (70.4 -> 82.4): Cili Elek 
	            lakkozas (55.2 -> 71.6): Andi Feri Gabi 

8. ora:
	              hantas (88 -> 94.4): Hedvig 
	  feher_alap_festese (86.8 -> 94.4): Dia 
	         jel_festese (82.4 -> 94.4): Cili Elek 
	            lakkozas (71.6 -> 94.4): Andi Bela Feri Gabi 

*/

end;
