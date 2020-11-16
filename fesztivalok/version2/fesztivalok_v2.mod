set Festivals;
set Bands;

# Melyik banda melyik fesztiválon lép fel
param performs {Bands, Festivals};

# Egy adott fesztiválra elmegyünk e vagy sem
var goto {Festivals} binary;

# Minden bandát legalább egyszer látnom kell
s.t. MustSeeEachBandAtLeastOnce {band in Bands}:
  sum{festival in Festivals} goto[festival] * performs[band, festival] >= 1;

# minimalizáljuk, a fesztiválokat amikre elmegyünk
minimize FestivalsWeGo: 
  sum{festival in Festivals} goto[festival];

solve;

printf "\nFesztivalok amikre megyunk: ";
for{festival in Festivals: goto[festival] == 1}
  printf "%s\t", festival;
printf "\n\n";

data;

set Festivals := RockMarathon, Sziget, Volt, Metalfest;
set Bands := Dalriada, Metallica, Eluveitie, Liva, IcedEarth, Virrasztok;

param performs :
            RockMarathon	Sziget	Volt	Metalfest :=
Dalriada	        0	        1	     1	      1
Metallica	        1	        1	     0	      0
Eluveitie	        1	        0	     0	      1
Liva	            1	        1	     1	      0
IcedEarth	        0	        1	     1	      1
Virrasztok	      0	        0	     1	      1
;

end;
