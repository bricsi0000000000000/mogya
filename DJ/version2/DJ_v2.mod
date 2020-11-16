set People;
set Tracks;

param like{Tracks, People};
param trackCount;

set TrackList := 1..trackCount;

# Egy számot hányadikként játszunk, melyik TrackList-en
var play{Tracks, TrackList} binary;

# táncol e
var dance {People, TrackList} binary;

# iszik e
var drink {People, TrackList} binary;

# lelépett e
var away {People, TrackList} binary;

s.t. PlayExactlyOneSong {list in TrackList}:
  sum {track in Tracks} play[track, list] = 1;

# Egyszerre csak 1 dolgot csinálhat(táncol, iszik, elmegy)
s.t. ExactlyOneState {list in TrackList, person in People}:
  dance[person, list] + drink[person, list] + away[person, list] = 1;

# Ha nem tetszik neki, nem táncol
s.t. DoesntDanceIfDoesntLike {person in People, list in TrackList}:
  # play[track, list] == 1 és like[track, person] == 0 akkor dance[person, list] = 0
  # sum{track in Tracks: like[track, play] == 0} play[track, list] == 1 akkor dance[person, list] = 0
  dance[person, list] <= 1 - sum{track in Tracks: like[track, person] == 0} play[track, list];

# Ha nem tetszik neki és az előző se -> away
s.t. TwoDoesntLikeInARowThenAway {person in People, list in TrackList: list != 1}:
  # sum{track in Tracks: like[track, play] == 0} play[track, list] == 1
  # és
  # sum{track in Tracks: like[track, play] == 0} play[track, list - 1] == 1
  # akkor
  # away[person, list] = 1
  away[person, list] >= -1 + sum{track in Tracks: like[track, person] == 0} play[track, list] + sum{track in Tracks: like[track, person] == 0} play[track, list - 1];

# Ha 3-szor se -> akkor az marad -> elmegy
s.t. OnceAwayAlwaysAway {person in People, list in TrackList: list != 1}:
  # away[person, list - 1] = 1 akkor away[person, list] = 0
  away[person, list] >= away[person, list - 1];

/* Nemkell, mert a 2. után elmennek
s.t. ShouldntPlayThreeUnlikedSongs {person in People}:
  sum{track in Tracks: like[track, person] == 0} play[track] <= 2;
*/

# Ha még nem away és tetszik, akkor táncol
# away[person, list] == 0
# és
# sum{track in Tracks: like[track, person] == 1} play[track, list] = 1
# akkor
# dance[person, list] == 1
s.t. IfNotAwayAndLikeThenDance {person in People, list in TrackList}:
  dance[person, list] >= sum{track in Tracks: like[track, person] == 1} play[track, list] - away[person, list];

s.t. NotAwayTheFirstTime {person in People}:
  away[person, 1] = 0;

maximize Tracklist: 
  # sum{track in Tracks} play[track];
  sum{list in TrackList, person in People} drink[person, list];

solve;

printf "%20s", " ";
for{person in People}{
  printf "\t%s", person;
}
printf "\n";

for{list in TrackList}{
  for{track in Tracks: play[track, list] == 1}{
    printf "%2d. %16s", list, track;
  }
  for{person in People}{
    for {{0}: dance[person, list] == 1}{ # Mivel itt nincs if, ezért indítunk egy ciklus egy 1 elemű halmazon
      printf "\tDance";
    }
    for {{0}: drink[person, list] == 1}{
      printf "\tDrink";
    }
    for {{0}: away[person, list] == 1}{
      printf "\tAway";
    }
  }
  printf "\n";
}

/*

Kimenet:

                     	Andi	Guszti	Patrik	Tina	Mate
 1.   WhiskyInTheJar	Drink	Drink	Drink	Drink	Dance
 2.        ItsMyLife	Away	Dance	Dance	Dance	Drink
 3.   WhiskyInTheJar	Away	Drink	Drink	Drink	Dance
 4.        ItsMyLife	Away	Dance	Dance	Dance	Drink
 5.   WhiskyInTheJar	Away	Drink	Drink	Drink	Dance
 6.        ItsMyLife	Away	Dance	Dance	Dance	Drink
 7.   WhiskyInTheJar	Away	Drink	Drink	Drink	Dance
 8.        ItsMyLife	Away	Dance	Dance	Dance	Drink
 9.    HighwayToHell	Away	Drink	Dance	Drink	Dance
10. ILoveRockAndRoll	Away	Dance	Drink	Away	Drink

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

param trackCount := 10;

end;
