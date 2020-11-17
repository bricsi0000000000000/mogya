set Routes;
set Places;

param visit {Routes, Places};

param orderCount;
set Orders := 1..orderCount;

param weight {Orders}; # kg

param place {Orders} symbolic in Places;
param deadline {Orders}; # hour

param capacity; # kg
param slotCount; # pieces
param jobHours; # hour

set Hours := 1..jobHours;

set PossibleDeliveries := setof {hour in Hours, order in Orders: deadline[order] > hour} (hour, order); # A '(hour, order)' párokból készít egy halmazt

var select {Hours, Routes} binary;

#var deliver {Hours, Orders} binary;
var deliver {PossibleDeliveries} binary;

s.t. RouteSelection {hour in Hours}:
  sum {route in Routes} select[hour, route] = 1;

# s.t. OnlyDeliverOneRoute {order in Orders, hour in Hours}:
s.t. OnlyDeliverOneRoute {(hour, order) in PossibleDeliveries}:
  deliver[hour, order] <= 1 - sum {route in Routes: visit[route, place[order]] == 0} select[hour, route];

s.t. OrderDelivery {order in Orders}:
  # sum {hour in Hours} deliver[hour, order] <= 1;
  sum {(hour, order) in PossibleDeliveries} deliver[hour, order] <= 1;

/*
s.t. BeforeDeadline {order in Orders, hour in Hours: hour >= deadline[order]}:
  deliver[hour, order] = 0;
*/

s.t. MaxCapacity {hour in Hours}:
  # sum {order in Orders} deliver[hour, order] * weight[order] <= capacity;
  sum {(hour, order) in PossibleDeliveries} deliver[hour, order] * weight[order] <= capacity;

s.t. MaxSlotCount {hour in Hours}:
  # sum {order in Orders} deliver[hour, order] <= slotCount;
  sum {(hour, order) in PossibleDeliveries} deliver[hour, order] <= slotCount;

maximize deliveredOrders:
  # sum {hour in Hours, order in Orders} deliver[hour, order];
  sum {(hour, order) in PossibleDeliveries} deliver[hour, order];

solve;

for {hour in Hours}{
  for{route in Routes: select[hour, route] == 1}{
    printf "Hour %d: Route %s [", hour, route;
    for {p in Places: visit[route, p] == 1}{
      printf " %s", p;
    }
    printf "]\n";

    # printf "\tOrders: TotalWeight: %g\n", sum {order in Orders: deliver[hour, order] == 1} weight[order];
    printf "\tOrders: TotalWeight: %g\n", sum {(hour, order) in PossibleDeliveries: deliver[hour, order] == 1} weight[order];
    # for{order in Orders: deliver[hour, order] == 1}{
    for{(hour, order) in PossibleDeliveries: deliver[hour, order] == 1}{
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
Hour 2: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 8.19
		Order 10 (Bordon)
		Order 32 (Tulan)
Hour 3: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 8.83
		Order 9 (Natal)
		Order 29 (Lan)
Hour 4: Route North [ Crydee Moraelin Elvandar CarseJonril]
	Orders: TotalWeight: 9.9
		Order 13 (Elvandar)
		Order 17 (CarseJonril)
Hour 5: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 9.62
		Order 26 (Lan)
		Order 34 (Walinor)
Hour 6: Route East [ Lan Walinor Hush Natal Bordon]
	Orders: TotalWeight: 6.37
		Order 22 (Natal)
Hour 7: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 0
Hour 8: Route South [ CarseJonril Tulan Lan Bordon]
	Orders: TotalWeight: 0

*/

end;
