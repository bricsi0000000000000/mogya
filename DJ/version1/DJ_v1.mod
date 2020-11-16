set People;
set Tracks;

# Egy adott személy az adott zenét szereti e vagy sem
param like{Tracks, People};

# Lejátszunk e egy zenét vagy sem
var play{Tracks} binary;

# Senki se hallgasson meg 3x olyan zenét amit ne szeretne
s.t. ShouldntPlayThreeUnlikedSongs {person in People}:
  sum{track in Tracks: like[track, person] == 0} play[track] <= 2;

# Maximalizálnunk kell a tracklist hosszát
maximize TrackList: sum{track in Tracks} play[track];

solve;

printf "TrackList:\n";

for{track in Tracks: play[track] == 1}{
  printf "\t- %s\n", track;
}

printf "\nPeople:\n";

for{person in People}{
  printf "\t- %s (%d)\n", person, sum{track in Tracks: like[track, person] == 0} play[track];
}

/*

Kimenet:

TrackList:
	- Freedom
	- HighwayToHell
	- ShippingUpToBoston
	- ItsMyLife
	- SummerOf69

People:
	- Andi (1)
	- Guszti (2)
	- Patrik (2)
	- Tina (2)
	- Mate (2)

*/

data;

set People := 
Andi
Guszti
Patrik
Tina
Mate
;

set Tracks :=
Freedom
HighwayToHell
ShippingUpToBoston
ItsMyLife
WhiskyInTheJar
SummerOf69
ILoveRockAndRoll
;

param like:
                    Andi  Guszti  Patrik  Tina  Mate :=
Freedom               1     1       1       1     1
HighwayToHell         1     0       1       0     1
ShippingUpToBoston    1     0       0       1     0
ItsMyLife             0     1       1       1     0
WhiskyInTheJar        0     0       0       0     1
SummerOf69            1     1       0       0     1
ILoveRockAndRoll      0     1       0       0     0
;

end;
