set Courses;

param nDays;
set Days := 1..nDays;

# how much time does it require to prepare
param required_time {Courses};

# when we can get the exam done
param exam_day {Courses};

# Each day, we have a given amount of free time
param free_time {Days};

var studying {Days, Courses} >= 0;

# egy nap csak annyit tudunk tanulni, amennyi szabadidőnk van arra a napra
s.t. DailyStudy {day in Days}:
  sum {course in Courses} studying[day, course] <= free_time[day];

# mindegyik vizsgára annyit kell készülni, amennyi meg van adva
s.t. CourseStudy {course in Courses}:
  sum {day in Days: day < exam_day[course]} studying[day, course] >= required_time[course];

minimize TotalStudyHours:
  sum {day in Days, course in Courses} studying[day, course];

solve;

printf "Total study hours: %d\n\n", TotalStudyHours;

for {day in Days}{
  printf "day%s\n", day;
  for {course in Courses}{
    printf "\t%s\n", course;
  }
  printf "\n";
}

end;
