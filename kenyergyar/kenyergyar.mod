set Fields;
set Mills;
set Bakers;

param fieldMillDistance {Fields, Mills} >= 0; # km
param millBakerDistance {Mills, Bakers} >= 0; # km

param wheatAmount {Fields} >= 0; # kg

param millMaxCapacity {Mills} >= 0; # kg

param truckMaxCapacity >= 0;
param emptyTruckConsumption >= 0;
param truckConsumptionGrowPerKG >= 0;

param fuelCost >= 0;

var fieldMillTransport {Fields, Mills} >= 0 integer;
var fieldMillDeliver {Fields, Mills} >= 0;

var millBakerTransport {Mills, Bakers} >= 0 integer;
var millBakerDeliver {Mills, Bakers} >= 0;

# Minden mezőről amennyi van
s.t. AllWheatFromFields {field in Fields}:
  sum {mill in Mills} fieldMillTransport[field, mill] = wheatAmount[field];

# Egy malomba max amennyit elbír
s.t. MillMaxCapacity {mill in Mills}:
  sum {field in Fields} fieldMillTransport[field, mill] <= millMaxCapacity[mill];

# Malomból mindent elszállít
s.t. TransportEverythingFromMill {mill in Mills}:
  sum {field in Fields} fieldMillTransport[field, mill] = 
  sum {baker in Bakers} millBakerTransport[mill, baker];

s.t. TrucksCount1 {field in Fields, mill in Mills}:
  fieldMillDeliver[field, mill] * truckMaxCapacity >= fieldMillTransport[field, mill];

s.t. TrucksCount2 {mill in Mills, baker in Bakers}:
  millBakerDeliver[mill, baker] * truckMaxCapacity >= millBakerTransport[mill, baker];

minimize Cost:
  fuelCost *
  (
    sum {field in Fields, mill in Mills} fieldMillDistance[field, mill] *
    (
      2 * emptyTruckConsumption * fieldMillTransport[field, mill] + 
      fieldMillDeliver[field, mill] * truckConsumptionGrowPerKG
    )
    +
    sum {mill in Mills, baker in Bakers} millBakerDistance[mill, baker] *
    (
      2 * emptyTruckConsumption * millBakerTransport[mill, baker] + 
      millBakerDeliver[mill, baker] * truckConsumptionGrowPerKG
    )
  ) 
  / 100;

solve;

printf "Cost: %d\n", Cost;

for {mill in Mills} printf "%s\t", mill;
printf "\n";
for{field in Fields}
{
    printf "%s\t", field;
    for {mill in Mills} printf "%d(%.0f)\t", fieldMillTransport[field, mill], fieldMillDeliver[field, mill];
    printf "\n";
}

printf "\n\t";
for {baker in Bakers} printf "%s\t", baker;
printf "\n";
for {mill in Mills}
{
    printf "%s\t", mill;
    for {baker in Bakers} printf "%d(%.0f)\t", millBakerTransport[mill, baker], millBakerDeliver[mill, baker];
    printf "\n";
}

/*

Kiemenet:

Cost: 753185252
mill1	mill2	
field1	0(0)	36526(73)	
field2	0(0)	12368(25)	
field3	24527(49)	1107(2)	
field4	0(0)	9999(20)	

	baker1	baker2	baker3	
mill1	0(0)	0(0)	24527(49)	
mill2	0(0)	60000(120)	0(0)	

*/

end;
