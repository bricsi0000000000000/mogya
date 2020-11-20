# Elméleti kérdések

Egy MILP modellben minden változónak egészértékűnek kell lennie. `hamis`

Egy MILP modellben minden változónak binárisnak kell lennie. `hamis`

---

LP modellekben legalább annyi egyenlőtlenségnek kell lenni, mint ahány egyenlet van. `hamis`

---

Nem lehet optimális megoldás egy LP/MILP feladat esetében az, ha minden változó értéke 0. `hamis`

---

A big-M korlátozások csak LP modellekben fordulhatnak elő. `hamis`

---

A (szimplex) második fázis feladata, hogy találjon egy bázismegoldást. `hamis`

A (szimplex) első fázis feladata, hogy megtalálja az optimális megoldást. `hamis`

> **Megoldás**: Először egy bázis, majd az optimális megoldást találja meg

---

GMPL-ben a `var` deklarációknak mindenképp a `param`-ok után kell lennie. `hamis`

---

A magyar módszert a set covering (halmazlefedési) feladat megoldására dolgozták ki. `hamis`

---

LP modellekben legalább annyi korlátozásnak kell lenni, mint ahány változó van. `hamis`

---

Előfordulhat, hogy egy LP modellnek pontosan 42 megoldása van. `hamis`

> **Megoldás**: vagy van 1 optimális megoldás, vagy végtelen sok optimális megoldás van, vagy túlkorlátoztuk, vagy nincs megoldás.

---

A szimplex módszer őnmagában elég MILP feladatok megoldására. `hamis`

A szimplex algoritmus önmagában nem tud MILP feladatokat megoldani. `igaz`

---

A GMPL case-insensitive nyelv. `hamis`

> **Megoldás**: case-sensitive nyelv

---

MILP-eket könnyebben (gyorsabban) meg lehet oldani, mint LP-ket. `hamis`

---

Minden MILP feladatnak van legalább egy optimális megoldása. `hamis`

---

A preprocessing a MILP megoldóban az, amikor memóriát foglal a paramétereknek, és kiszámolja az értéküket. `hamis`

---

LP modellben nem megengedett két folytonos változó összeszorzása, de MILP modellekben igen. `hamis`

---

Egy változónak legfeljebb két alsó indexe lehet. `hamis`

Minden paraméternek legfeljebb két dimenziója/alsóindexe lehet GMPL-ben. `hamis`

---

Halmazok leszűkítésében (kapcsoson belül a kettőspont utáni rész) használhatók a paraméterek. `igaz`

---

Lehet a modellben olyan korlátozás, melyben a modell összes változója szerepel nem 0 együtthatóval. `igaz`

---

Maximalizálási feladat esetében a B&B algoritmus korlátozó függvénye felső korlátod ad. `igaz`

---

Redundáns változókból tetszőlegesen(de véges) sok bevezethető `igaz`

---

Szigorúan kisebb és nagyobb típusú korlátozások csak LP modellekben megengedettek, MILP-ekben nem. `hamis`

---

Nem szükséges minden változónak szerepelni a célfüggvényben. `igaz`

---

GMPL-ben egyszerre több célfüggvény is megadható `hamis`

---

Relaxált modell optimális megoldása nem lehet jobb, csak rosszabb, mint az eredeti MILP modellé. `hamis`

---

A B&B algoritmusok nem LP feladatok megoldására lettek kidolgozva. `igaz`

---

Egy feladatnak több optimális megoldása is lehet. `igaz`

---

LP modellekben szerepelhetnek egész változók, ha csak egy korlátozásban és a célfüggvényben jelennek meg. `hamis`

---

A solve; utáni kód feltételezheti, hogy a változók már rendelkeznek fix hozzárendelt értékekkel. `igaz`
