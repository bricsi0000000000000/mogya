set BookSets;

param width {BookSets};

# Meg van adva egy minHeight és maxHeight, de mivel 7 cm-nek kell lennie fölötte, ezért elég ha csak sima height-et használunk
param height {BookSets};
param shelfCount;

set Shelves := 1..shelfCount;

param shelfWidth;

# Vastagsága
param shelfHeight;
param minDistance;
param minPosition;

param M := 500;

# A polc mélységére sincs szükségünk. Ez is egy felesleges adat

# Használjuk e azt a polcot vagy sem
var use {Shelves} binary;
var position {Shelves} >= minPosition; # 50 cm magasan kezdődik

# Melyik csoportot hova tesszük
var put {BookSets, Shelves} binary;

# Mivel itt nem lehet max függvényt megadni, ezért kell ez
var maxBookHeight {Shelves} >= 0;
var maxUsedShelf;

# Ha egy polcot használunk, akkor az összes alatta lévő polcot is használnunk kell
s.t. ShelfUsage {shelf in Shelves: shelf != 1}:
  # if use[shelf], then use[shelf - 1]
  use[shelf] <= use[shelf - 1];

# Legalább annyival magasabbra kell kerülnie, mint az alatta lévő + 7cm
s.t. MaxBookHeightSetter {bookSet in BookSets, shelf in Shelves}:
  maxBookHeight[shelf] >= height[bookSet] * put[bookSet, shelf]; # Ez nem fogja pontosan beállítani, de a célfüggvény ki fogja venni ami nem kell

s.t. ShelfPositioning {shelf in Shelves: shelf != 1}:
  position[shelf] >= position[shelf - 1] + maxBookHeight[shelf - 1] + shelfHeight + minDistance;

# Egy könyvespolcra csak akkor lehet pakolni, ha használjuk

# Nem lehet többet pakolni egy polcra, mint amennyi elfér rajta
s.t. ShelfCapacity {shelf in Shelves}:
  sum{bookSet in BookSets} put[bookSet, shelf] * width[bookSet] <= shelfWidth * use[shelf];

# Minden könyv csoportot fel kell rakni egy polcra
s.t. BookSetAssignment{bookSet in BookSets}:
  sum{shelf in Shelves} put[bookSet, shelf] = 1;

s.t. MaxUsedShelf {shelf in Shelves}:
  # if use[shelf] then maxUsedShelf >= position[shelf]
  #maxUsedShelf >= position[shelf] * use[shelf]; # Nem lehet szorozni, mert mindkettő egy változó
  maxUsedShelf >= position[shelf] - M * (1 - use[shelf]); # Megoldás: Big M korlátozás

minimize TopShelfHeight:
  maxUsedShelf;

solve;

for{shelf in Shelves: use[shelf] == 1}{
  printf "Shelf %d: %d cm\n", shelf, position[shelf];
  for{bookSet in BookSets: put[bookSet, shelf] == 1}{
    printf "\t%s - %d\n", bookSet, width[bookSet];
  }
}

/*

Kimenet:

Shelf 1: 50 cm
	matek - 100
Shelf 2: 79 cm
	info - 80
	Tolkien - 30
Shelf 3: 113 cm
	egyebregeny - 40
	Feist - 50
Shelf 4: 142 cm
	sport - 30
	HarryPotter - 90
Shelf 5: 181 cm
	zene - 50
	diploma - 70

*/

data;

set BookSets :=
matek
info
sport
zene
egyebregeny
Tolkien
Feist
HarryPotter
diploma
;

param :      width  height :=
matek	        100	    20
info	        80	    25
sport	        30	    30
zene	        50	    30
egyebregeny	  40	    20
Tolkien	      30	    25
Feist	        50	    20
HarryPotter	  90	    25
diploma	      70	    40
;

param shelfCount := 7;
param shelfWidth := 120;
param shelfHeight := 2;
param minDistance := 7;
param minPosition := 50;

end;
