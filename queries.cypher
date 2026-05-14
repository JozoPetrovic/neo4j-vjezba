// === PRIPREMA BAZE (FILMOVI I OSOBE) ===

// Kreiranje osnovnih čvorova za prethodne zadatke
CREATE (f1:Film {naslov: 'Inception', godina: 2010, zanr: 'triler', ocjena: 8.8})
CREATE (f2:Film {naslov: 'The Dark Knight', godina: 2008, zanr: 'akcija', ocjena: 9.0})
CREATE (f3:Film {naslov: 'Interstellar', godina: 2014, zanr: 'sci-fi', ocjena: 8.6})
CREATE (f4:Film {naslov: 'Parasite', godina: 2019, zanr: 'triler', ocjena: 8.5})

CREATE (o1:Osoba {ime: 'Leonardo DiCaprio'})
CREATE (o2:Osoba {ime: 'Christopher Nolan'})
CREATE (o3:Osoba {ime: 'Bong Joon-ho'})
CREATE (o4:Osoba {ime: 'Cillian Murphy'})

CREATE (g1:Grad {naziv: 'London'})
CREATE (g2:Grad {naziv: 'Los Angeles'})
CREATE (g3:Grad {naziv: 'Seoul'})

// Veze za filmove
MERGE (o1)-[:GLUMIO_U]->(f1)
MERGE (o2)-[:REZIRAO]->(f1)
MERGE (o4)-[:GLUMIO_U]->(f1)
MERGE (o2)-[:REZIRAO]->(f2)
MERGE (o3)-[:REZIRAO]->(f4)

// Veze za gradove
MERGE (o2)-[:ZIVI_U]->(g1)
MERGE (o1)-[:ZIVI_U]->(g2)
MERGE (o3)-[:ZIVI_U]->(g3)

// === UPITI IZ ZADATAKA ===

// Zadatak: Pronaći sve filmove žanra 'triler' sortirane po godini uzlazno
MATCH (f:Film)
WHERE f.zanr = 'triler'
RETURN f.naslov, f.godina
ORDER BY f.godina ASC;

// Zadatak: Pronaći ime redatelja i naziv grada u kojem živi (dvije veze u nizu)
MATCH (g:Grad)<-[:ZIVI_U]-(o:Osoba)-[:REZIRAO]->(f:Film)
RETURN DISTINCT o.ime AS Redatelj, g.naziv AS Grad;

// Zadatak: Pronaći sve filmove snimljene između 2008. i 2015. godine (WHERE s AND)
MATCH (f:Film)
WHERE f.godina >= 2008 AND f.godina <= 2015
RETURN f.naslov, f.godina;

// Zadatak: Pronaći redatelje koji su snimili više od jednog filma (count)
MATCH (o:Osoba)-[:REZIRAO]->(f:Film)
WITH o, count(f) AS brojFilmova
WHERE brojFilmova > 1
RETURN o.ime, brojFilmova;

// Zadatak: Pronaći najkraći put između DiCaprija i Bong Joon-hoa
MATCH (p1:Osoba {ime: 'Leonardo DiCaprio'}), (p2:Osoba {ime: 'Bong Joon-ho'})
MATCH put = shortestPath((p1)-[*..10]-(p2))
RETURN put;

// Zadatak: Pronaći sve čvorove udaljene najviše 2 veze od grada London
MATCH (g:Grad {naziv: 'London'})-[veza*1..2]-(susjed)
RETURN g, veza, susjed;

// Zadatak: Provjera povezanosti Coppole i DiCaprija (u 4 koraka)
MATCH (a:Osoba {ime: 'Francis Ford Coppola'}), (b:Osoba {ime: 'Leonardo DiCaprio'})
MATCH put = shortestPath((a)-[*..4]-(b))
RETURN put;

// Zadatak: Ukupan broj filmova i prosječna ocjena (bez grupiranja)
MATCH (f:Film)
RETURN count(f) AS UkupnoFilmova, avg(f.ocjena) AS ProsjecnaOcjena;

// Zadatak: Broj filmova po žanru i maksimalna ocjena (WITH + max)
MATCH (f:Film)
WITH f.zanr AS Zanr, count(f) AS BrojFilmova, max(f.ocjena) AS NajboljaOcjena
RETURN Zanr, BrojFilmova, NajboljaOcjena;

// Zadatak: Pronaći osobu koja živi u gradu s najviše osoba (LIMIT 1)
MATCH (g:Grad)<-[:ZIVI_U]-(o:Osoba)
WITH g, count(o) AS brojStanovnika
ORDER BY brojStanovnika DESC
LIMIT 1
MATCH (rezultat:Osoba)-[:ZIVI_U]->(g)
RETURN rezultat.ime, g.naziv;

// Zadatak: Lista svih glumaca za svaki film (collect)
MATCH (o:Osoba)-[:GLUMIO_U]->(f:Film)
RETURN f.naslov, collect(o.ime) AS Glumci;


// === ZAVRŠNI ZADATAK: GLAZBENA SCENA ===

// 1. Kreiranje modela (Izvođači, Albumi, Žanrovi)
CREATE (:Zanr {naziv: 'Rock'}), (:Zanr {naziv: 'Pop'}), (:Zanr {naziv: 'Electronic'}), (:Zanr {naziv: 'Heavy Metal'});

CREATE (i1:Izvodac {ime: 'Daft Punk', drzava: 'Francuska', godina_osnivanja: 1993})
CREATE (i2:Izvodac {ime: 'Radiohead', drzava: 'UK', godina_osnivanja: 1985})
CREATE (i3:Izvodac {ime: 'Metallica', drzava: 'SAD', godina_osnivanja: 1981})
CREATE (i4:Izvodac {ime: 'Massive Attack', drzava: 'UK', godina_osnivanja: 1988})
CREATE (i5:Izvodac {ime: 'Justice', drzava: 'Francuska', godina_osnivanja: 2003})
CREATE (i6:Izvodac {ime: 'Tame Impala', drzava: 'Australija', godina_osnivanja: 2007});

// 2. Veze OBJAVIO i PRIPADA_ZANRU (primjeri)
MATCH (dp:Izvodac {ime: 'Daft Punk'}), (z_el:Zanr {naziv: 'Electronic'})
CREATE (dp)-[:OBJAVIO]->(:Album {naziv: 'Discovery', godina: 2001, ocjena: 9.2})-[:PRIPADA_ZANRU]->(z_el);

MATCH (rh:Izvodac {ime: 'Radiohead'}), (z_rk:Zanr {naziv: 'Rock'})
CREATE (rh)-[:OBJAVIO]->(:Album {naziv: 'OK Computer', godina: 1997, ocjena: 9.7})-[:PRIPADA_ZANRU]->(z_rk);

// 3. Veze SLICAN i SURADIVAO_S
MATCH (i1:Izvodac {ime: 'Daft Punk'}), (i5:Izvodac {ime: 'Justice'}) MERGE (i1)-[:SLICAN]->(i5);
MATCH (i1:Izvodac {ime: 'Daft Punk'}), (i6:Izvodac {ime: 'Tame Impala'}) MERGE (i1)-[:SURAĐIVAO_S]->(i6);

// 4. Specifični upiti završnog zadatka
// Upit: Svi albumi izvođača sortirani po godini
MATCH (i:Izvodac {ime: 'Daft Punk'})-[:OBJAVIO]->(a:Album)
RETURN i.ime, a.naziv, a.godina
ORDER BY a.godina ASC;

// Upit: Filtriranje albuma s ocjenom > 8.0
MATCH (a:Album)
WHERE a.ocjena > 8.0
RETURN a.naziv, a.ocjena;

// Upit: OPTIONAL MATCH prikaz izvođača i broja albuma (uključujući 0)
MATCH (i:Izvodac)
OPTIONAL MATCH (i)-[:OBJAVIO]->(a:Album)
RETURN i.ime, count(a) AS broj_albuma;

// Upit: shortestPath kroz SLICAN i SURADIVAO_S
MATCH (p1:Izvodac {ime: 'Radiohead'}), (p2:Izvodac {ime: 'Tame Impala'})
MATCH put = shortestPath((p1)-[:SLICAN|SURAĐIVAO_S*..10]-(p2))
RETURN put;

// Upit: Agregacija po žanru (prosjek > 7.5)
MATCH (a:Album)-[:PRIPADA_ZANRU]->(z:Zanr)
WITH z.naziv AS Zanr, count(a) AS BrojAlbuma, avg(a.ocjena) AS Prosjek
WHERE Prosjek > 7.5
RETURN Zanr, BrojAlbuma, Prosjek;

// 5. Constraints i Index
CREATE CONSTRAINT izvodac_ime_unique IF NOT EXISTS FOR (i:Izvodac) REQUIRE i.ime IS UNIQUE;
CREATE INDEX album_ocjena_index IF NOT EXISTS FOR (a:Album) ON (a.ocjena);