set Routes;
set Places;

param visit {Routes, Places};

param orderCount;
set Orders := 1..orderCount;

param weight {Orders}; # kg

# 'Places'-nek egy eleme
param place {Orders} symbolic in Places; # szimbolikus paraméter
param deadline {Orders}; # hour

param capacity; # kg

# Hányat tudunk elvinni
param slotCount; # pieces

# Hány órát dolgozunk
param jobHours; # hour

set Hours := 1..jobHours;

var select {Hours, Routes} binary;
var deliver {Hours, Orders} binary;

# Egy alklamommal csak egy útvonalra mehetünk el
s.t. RouteSelection {hour in Hours}:
  sum {route in Routes} select[hour, route] = 1;

# Csak olynaokat tudunk leszállítani amik azon az útvonalon elérhetőek
/*
  deliver [hour, order] == 1 -> select[hour, route] == 1 for some rout, visit[route, place[order]] == 1
  Ha egy adott órában egy adott ordert le szeretnénk szállítani,
  akkor szükséges az, hogy egy oylan route-ra menjünk el
  abban az adott órában, amelyik routeban igaz az, hogy az 
  ordernek a place-e, az egy olyan place, amit az a 'visit[route' route meglátogat

  megfordítva:

  Ha egy olyan route-on szelektálrunk, ameliyken nincsen rajta az adott ordernek a place, azt nem szállíthatjuk le
  if select[hour, route] == 1 and visit[route, place[order]] == 0 then deliver[hour, order] = 0
*/
s.t. OnlyDeliverOneRoute {order in Orders, hour in Hours}:
  #deliver[hour, order] <= # 0 if select[hour, route] == 1 and visit[route, place[order]] == 0
                           # 1 -nél >= legyen
  deliver[hour, order] <= 1 - sum {route in Routes: visit[route, place[order]] == 0}               select[hour, route];
                          # minden olyan route ami nem érinti ennek a csomagnak a szállítási címét

# Egy dolgot csak egyszer lehet leszállítani
s.t. OrderDelivery {order in Orders}:
  sum {hour in Hours} deliver[hour, order] <= 1;

# Semmit nem szállíthatunk le határidő után
s.t. BeforeDeadline {order in Orders, hour in Hours: hour >= deadline[order]}: # 'deadline' egy paraméter. Egy változóval ilyet nem lehet
  deliver[hour, order] = 0;

# Max 5 csomag egy kiszállításnál
s.t. MaxCapacity {hour in Hours}:
  sum {order in Orders} deliver[hour, order] * weight[order] <= capacity;

# Max 10 kg egy kiszállításnál
s.t. MaxSlotCount {hour in Hours}:
  sum {order in Orders} deliver[hour, order] <= slotCount;

maximize deliveredOrders:
  sum {hour in Hours, order in Orders} deliver[hour, order];

solve;

for {hour in Hours}{
  for{route in Routes: select[hour, route] == 1}{
    printf "Hour %d: Route %s [", hour, route;
    for {p in Places: visit[route, p] == 1}{
      printf " %s", p;
    }
    printf "]\n";

    printf "\tOrders: TotalWeight: %g\n", sum {order in Orders: deliver[hour, order] == 1} weight[order];
    for{order in Orders: deliver[hour, order] == 1}{
      printf "\t\tOrder %d (%s)\n", order, place[order];
    }
  }
}

/*

Kimenet

Hour 1: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 8.49
		Order 7 (Walinor)
		Order 19 (Lan)
		Order 33 (Lan)
Hour 2: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 9.07
		Order 9 (Natal)
		Order 10 (Bordon)
Hour 3: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 9.15
		Order 17 (CarseJonril)
		Order 32 (Tulan)
Hour 4: Route North [ Crydee Moraelin Elvandar CarseJonril]
	Orders: TotalWeight: 6.8
		Order 13 (Elvandar)
		Order 24 (CarseJonril)
Hour 5: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 9.62
		Order 26 (Lan)
		Order 34 (Walinor)
Hour 6: Route North [ Crydee Moraelin Elvandar CarseJonril]
	Orders: TotalWeight: 7.32
		Order 12 (Moraelin)
Hour 7: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 0
Hour 8: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 0

*/

# data;

# Az adatok egy külön fájlban vannak: 'bringafutar_v1.dat' (Úgy szép)

end;
