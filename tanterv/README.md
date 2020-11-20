# Tanterv

Célunk egy tanterv idealis osszeallitasa.

Adott az osszes elvegzendo targy listaja, amit n felevbe kell beutemezni.
Minden targyhoz adott, hogy heti hany kontaktorat jelent, mennyi kreditet er, es hogy melyik masik targyakra epul.
Egy felevben a kontaktorak szama 17 es 23 kozott, a kreditek szama 25 es 35 kozott kell, hogy legyen.
A targyak elofelteteleit nyilvan be kell tartani, azonos felevben sem lehet felvenni, de 2-nel tobb felevet kihagyni sem lehet a ketto kozott.
Minimalizalni az utolso ket felevben tanult orak szamat szeretnenk.

## Plusz feladatok

- minimalizalni szeretnenk a "felelevenitesbe olt munkat", amit a kovetkezokeppen szamolunk ki: Ha egy A targy epul B targyra, es A a B-t koveto felevbe van beosztva, akkor nincs ilyen munka. Ha a ketto targy kozott van 1 felev kihagyas, akkor 5-szor annyi orat kell felelevenitessel foglalkozni, mint amenyi kreditet B er. Ha ket felev van kozottuk, akkor a szorzo nem 5 hanem 8.  Megj: ne foglalkozzunk azzal, hogy egy felevben lehet tobb targy is epul ugyanarra a targyra, igy eleg csak egyszer feleleveniteni. 
- Ha tobb targy is epul a felevben B-re, csak 1x kell feleleveniteni.
- Ha ket felev kihagyas van, de elozo felevben is felelevenitettuk B-t, akkor nem 8, hanem ugyanugy 5 a szorzo
- A felelevenitesek idotartamara is adott egy idokorlat minden felevre: 70
- Nemcsak kotelezo targyak vannak, hanem nehany blokk, amikbol adott, hogy legalabb hany kreditet kell teljesiteni. Ezekre a blokkokra is adott, hogy melyik targyakra epulnek, illetve ugy lehet szamolni, hogy a 2/3-ad annyi oraterhelest jelentenek, amennyi a kreditek szama. Az ilyen blokkok feldarabolhatok felevek kozott, de a blokkok legalabb 2 ora / 3 kredit meretuek kell, hogy legyenek.
