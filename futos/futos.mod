set Futok;

# mennyi szakaszunk van
param szakaszszam;
set Szakaszok := 1..szakaszszam;

# szakaszok
param hossz {Szakaszok};

# sebesség
param iram {Futok};

param mintav {Futok};
param maxtav {Futok};

var kiMelyikSzakasztKapja {Futok, Szakaszok} binary;

# 1 szakaszt 1 ember
s.t. EgySzakasztEgyEmber {szakasz in Szakaszok}:
  sum {futo in Futok} kiMelyikSzakasztKapja[futo, szakasz] = 1;

# ki kell osztani az összes szakaszt
s.t. LegalabbAnnyit {futo in Futok}:
  sum {szakasz in Szakaszok} kiMelyikSzakasztKapja[futo, szakasz] * hossz[szakasz] >= mintav[futo];

s.t. LegfeljebbAnnyit {futo in Futok}:
  sum {szakasz in Szakaszok} kiMelyikSzakasztKapja[futo, szakasz] * hossz[szakasz] <= maxtav[futo];

minimize Time:
  sum {futo in Futok, szakasz in Szakaszok} kiMelyikSzakasztKapja[futo, szakasz] * (iram[futo] * hossz[szakasz]);

solve;

for {sz in Szakaszok}
{
    printf "Szakasz %d (%.2f km):",sz, hossz[sz];
    for{f in Futok:kiMelyikSzakasztKapja[f,sz]=1}
        printf "\t%s\t%d p\n",f,hossz[sz]*iram[f];
}

printf "\n\n";
for{f in Futok}
{
    printf "%s\t%.2f km\t%d p\n",f,sum{sz in Szakaszok} hossz[sz]*kiMelyikSzakasztKapja[f,sz], sum{sz in Szakaszok} hossz[sz]*kiMelyikSzakasztKapja[f,sz]*iram[f];
}

printf "\nOsszido: %d p\n", Time;

end;
