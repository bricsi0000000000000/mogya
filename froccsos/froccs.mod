set Froccsok;
set Alapanyagok;

param arak {Froccsok};
param maxMennyisegek{Alapanyagok};
param mennyisegek {Froccsok, Alapanyagok};

# ez olyan mint pl.: Froccsok[i] (szerintem)
var mennyiseg{Froccsok} >= 0;

s.t. OsszetevokFelhasznalasa {alapanyag in Alapanyagok}:
  sum {froccs in Froccsok} mennyiseg[froccs] * mennyisegek[froccs, alapanyag] <= maxMennyisegek[alapanyag];

maximize OverallCost:
  sum {froccs in Froccsok} arak[froccs] * mennyiseg[froccs];

solve;

for {froccs in Froccsok}{
  printf "%s:\t%s\tdl\n", froccs, mennyiseg[froccs];
}
data;

set Froccsok := 
Kisfroccs    
Nagyfroccs   
Hosszulepes  
Hazmester    
Vicehazmester
Krudyfroccs  
Soherfroccs  
Puskasfroccs 
;

set Alapanyagok :=
Bor
Szoda
;

param arak :=
Kisfroccs     110
Nagyfroccs    200
Hosszulepes   120
Hazmester     260
Vicehazmester 200
Krudyfroccs   800
Soherfroccs   200
Puskasfroccs  550
;

param maxMennyisegek :=
Bor 1000
Szoda 1500
;

param mennyisegek :
                Bor Szoda :=
Kisfroccs        1    1
Nagyfroccs       2    1
Hosszulepes      1    2
Hazmester        3    2
Vicehazmester    2    3
Krudyfroccs      9    1
Soherfroccs      1    9
Puskasfroccs     6    3
;

end;
