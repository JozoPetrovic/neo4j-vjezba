ZADATAK 1

1 Port 7474 (HTTP)
    Ovaj port se koristi za pristup Neo4j Browser-u (web interfejsu). Putem ovog porta korisnici mogu vizuelno upravljati bazom, izvršavati Cypher upite u pregledniku i administrirati sistem putem HTTP protokola.

2 7687 (Bolt)
    Ovo je port za Bolt protokol, koji je binarni protokol optimizovan za brz prenos podataka. Koristi se za programski pristup bazi putem drivera (npr. kada aplikacija napisana u Python-u, Java-i ili JavaScript-u treba da komunicira sa bazom).

ZADATAK 2  

Naredba CREATE uvijek kreira novi čvor ili vezu, čak i ako identični podaci već postoje u bazi, što može dovesti do duplikata. S druge strane, MERGE prvo provjerava postoji li traženi podatak: ako postoji, on ga samo dohvaća (Match), a ako ne postoji, tada ga kreira (Create).

ZADATAK 4

Naredba MATCH vraća rezultate samo ako traženi uzorak (čvor ili veza) u potpunosti postoji; u suprotnom, cijeli redak se odbacuje. OPTIONAL MATCH funkcionira slično, ali ako uzorak ne postoji, on i dalje vraća redak, dok za nedostajuće dijelove postavlja vrijednost null.

ZADATAK 5

Ako putanja ne postoji, shortestPath ne vraća ništa (prazan skup rezultata). U Neo4j Browseru ćeš vidjeti poruku, dok bi u aplikacijskom kodu dobio praznu listu ili null, jer uvjet upita jednostavno nije ispunjen.

ZAVRŠNI ZADATAK


Neo4j bih koristio u slučajevima kada su odnosi između podataka (veze) jednako važni kao i sami podaci, što je ključno za glazbene preporuke i društvene mreže. U PostgreSQL-u, pronalaženje povezanosti kroz više razina (npr. "koji su izvođači slični onima s kojima je surađivao moj omiljeni pjevač") zahtijeva kompleksne i spore JOJ operacije nad tablicama. Specifičan problem koji je teško riješiti relacijskim pristupom je otkrivanje putanja nepoznate duljine** i izračunavanje najkraćeg puta između dva izvođača. U SQL-u to zahtijeva rekurzivne upite (CTE) koji su teški za pisanje i optimizaciju, dok Neo4j koristi graf algoritme koji u milisekundama prolaze kroz tisuće veza kako bi pronašli skrivene poveznice, što ga čini idealnim za sustave za preporuku glazbe temeljene na "sličnosti" i "suradnji".