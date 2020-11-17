param unitCount;
set Units := 1..unitCount;

param jobCount;
set Jobs := 1..jobCount;

param proctime {Jobs, Units};

param M := 100;

var start {Jobs, Units} >= 0;
var finish {Jobs, Units} >= 0;
var before {Jobs, Jobs} binary; # before[job1, job2] == 1 if job1 hamarabb van végrehajtva mint job2

var makespan;

s.t. ProcessingTime {job in Jobs, unit in Units}:
  finish[job, unit] = start[job, unit] + proctime[job, unit];

s.t. Precedences {job in Jobs, unit in Units: unit != 1}:
  start[job, unit] >= finish[job, unit - 1];

s.t. Sequencing {job1 in Jobs, job2 in Jobs, unit in Units}:
  # if before[job1, job2] == 1 then start[job2, unit] >= finish[job1, unit]
  start[job2, unit] >= finish[job1, unit] - M * (1 - before[job1, job2]);

s.t. Sequencing2 {job1 in Jobs, job2 in Jobs: job1 != job2}:
  before[job1, job2] + before[job2, job1] = 1;

s.t. MakespanSetter {job in Jobs}:
  makespan >= finish[job, unitCount];

minimize Makespan: makespan;

solve;

/*
for {p in 0 .. jobCount - 1}{
  for {job in Jobs: sum {job2 in Jobs: job2 != job} before[job2, job] == p}{
    printf "Job %2d: ", job;
    for {unit in Units}{
      printf "U%d: %g-%g\t", unit, start[job, unit], finish[job, unit];
    }
    printf "\n";
  }
}
*/
/*

Kimenet:

Job  3: U1: 0-2.08	U2: 2.08-3.93	U3: 3.93-8.91	
Job  2: U1: 2.08-4.45	U2: 4.45-7.77	U3: 8.91-13.61	
Job  1: U1: 4.45-5.06	U2: 7.77-12.08	U3: 13.61-16	
Job  5: U1: 5.06-9.33	U2: 12.08-12.38	U3: 16-18.85	
Job  4: U1: 9.33-13.05	U2: 15.09-18.85	U3: 18.85-19.97	

*/

# SVG

printf "\n";
printf "<svg height='%d' width='%g'>\n", 10 * unitCount, makespan * 10;

for {job in Jobs, unit in Units}{
  printf "\t<rect x='%g' y='%g' width='%g' height='%g' ", start[job, unit] * 10, (unit - 1) * 10 + 1, proctime[job, unit] * 10, 8;
  printf "style='fill:rgb(%d,%d,%d);stroke:black;stroke-width:1'/>\n", job / jobCount * 255, 255 - job / jobCount * 255, 100 + jobCount * 100;
}

printf "</svg>";
printf "\n";
printf "\n";
end;
