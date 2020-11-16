var RockMarathon binary;
var Sziget binary;
var Volt binary;
var Metalfest binary;

s.t. Dalriada: Sziget + Volt + Metalfest >= 1;

s.t. Metallica: RockMarathon + Sziget >= 1;

s.t. Eluveitie: RockMarathon + Metalfest >= 1;

s.t. Liva: RockMarathon + Sziget + Volt >= 1;

s.t. IcedEarth: Sziget + Volt + Metalfest >= 1;

s.t. Virrasztok: Volt + Metalfest >= 1;

minimize Festtivals: RockMarathon + Sziget + Volt + Metalfest;

end;