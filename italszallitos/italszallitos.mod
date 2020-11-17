set Factories;
set Destinations;

param factoryMaxAmount {Factories}; # liter
param destinationMaxAmount {Destinations}; # liter
param distances {Factories, Destinations}; # km

var deliver {Factories, Destinations} >= 0;

# Egyik célállomásra nem szállíthatunk többet, mint az ottani maxAmount
s.t. MaxAmountToDestinations {destination in Destinations}:
  sum {factory in Factories} deliver[factory, destination] >= destinationMaxAmount[destination];

# Egy gyárból nem szállíthatunk többet, mint amennyi ott az össz mennyiség
s.t. MaxAmountFromFactories {factory in Factories}:
  sum {destination in Destinations} deliver[factory, destination] <= factoryMaxAmount[factory];

minimize Cost {destination in Destinations}:
  sum {factory in Factories} distances[factory, destination] * 10 * deliver[factory, destination];

solve;

for {factory in Factories}{
  printf "%15s%10g Ft\n", factory ,sum {destination in Destinations} distances[factory, destination] * 10 * deliver[factory, destination];
}

/*

Kimenet:

     Toltestava     10000 Ft
        Komarom    182500 Ft
 Dunaszerdahely    500000 Ft

*/

end;
