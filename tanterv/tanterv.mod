set Courses;
param lessons {Courses};
param credits {Courses};
param prevCourses {Courses, Courses}, default 0;

param numberOfSemesters >= 2;
set Semesters := 1..numberOfSemesters;

param minHour;
param maxHour;

param minCredit;
param maxCredit;

var schedule {Semesters, Courses} binary;

s.t. EachCourseOnce {course in Courses}:
  sum {semester in Semesters} schedule[semester, course] = 1;

s.t. SatisfySemesterCreditLimitations {semester in Semesters}:
  minCredit <= sum {course in Courses} schedule[semester, course] * credits[course] <= maxCredit;

s.t. SatisfySemesterHourLimitations {semester in Semesters}:
  minHour <= sum {course in Courses} schedule[semester, course] * lessons[course] <= maxHour;

s.t. DontMakePrevCoursesEarlier {course1 in Courses, course2 in Courses, semester1 in Semesters, semester2 in Semesters: prevCourses[course2, course1] == 1 && semester2 <= semester1}:
  schedule[semester1, course1] + schedule[semester2, course2] <= 1;

s.t. DontStudyMuchEarlier {course1 in Courses, course2 in Courses, semester1 in Semesters, semester2 in Semesters: prevCourses[course2, course1] == 1 && semester2 > semester1 + 3}:
  schedule[semester1, course1] + schedule[semester2, course2] <= 1;

minimize LastTwoSemesterHours:
  sum {course in Courses, semester in Semesters: semester > numberOfSemesters - 2} schedule[semester, course] * lessons[course];

solve;

for {s in Semesters}
{
  printf "Semester %d:\tHOURS:%3d\tCREDITS:%3d\n",s,sum{c in Courses}schedule[s,c]*lessons[c],sum{c in Courses}schedule[s,c]*credits[c];
  for{c in Courses: schedule[s,c]==1}
  {
    printf " - %s\t%3d\t%3d\n",c,lessons[c],credits[c];
  }
}


end;
