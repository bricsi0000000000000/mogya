set Pumps;
set Houses;

param pumpBuildCost {Pumps} >= 0;
param pumpMaintainCost {Pumps} >= 0;
param supply {Pumps, Houses} binary;

param timeInterval;

var makePump {Pumps} binary;

s.t. MakePumps {house in Houses}:
  sum {pump in Pumps} makePump[pump] * supply[pump, house] >= 1;

minimize Cost:
  sum {pump in Pumps} makePump[pump] * (pumpBuildCost[pump] + pumpMaintainCost[pump] / 1000 * timeInterval);

solve;

printf "\nMegepitendo kutak:";
for {pump in Pumps : makePump[pump]}{
	printf " %s", pump;
}
printf "\n";

printf "\nBeruhazasi koltseg: %fM dh\n", sum{pump in Pumps} makePump[pump] * pumpBuildCost[pump];
printf "\nFenntartasi koltseg: %fk dh/ev\n", sum{pump in Pumps} makePump[pump] * (pumpMaintainCost[pump]);
printf "\nOsszes fenntartasi koltseg: %fM dh\n", sum{pump in Pumps} makePump[pump] * (pumpMaintainCost[pump] / 1000 * timeInterval);
printf "\nAggregalt koltseg: %fM dh\n", sum{pump in Pumps} makePump[pump] * (pumpBuildCost[pump] + pumpMaintainCost[pump] / 1000 * timeInterval);

end;
