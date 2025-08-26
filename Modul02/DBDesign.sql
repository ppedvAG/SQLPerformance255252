


/*---

Normalisierung ..keine schlechte Idee
		        .. aber evtl Redundanz einzubringen (reale Werte: RSumme)
				 --> vor allem, wenn ein Join gespart wird.

				 --#temp tabellen sind auch Redundanz


Datentypen gut justieren


Platzverschwendung: Seiten können Leerräume haben--> 1:1 --> RAM
bei geringen Füllgrad: Kompression (Page!, Row)  40-60%
--> Page kostet deutlich mehr CPU als Row Kompression
--Abfragen auf komprimierte Tabellen profitieren kaum seitens Performance
--eher profit. andere
--transp für Anwendung.. Daten im RAM auch komprimiert , aber bei Client dekomprimiert

Wie messe ich Platzverschwendung

dbcc showcontig('tabelle') ---depricated

--Seiten 1000000
--Fgrad: 90%--> ?



*/




/*
ref integrität
Tab
PK FK
Datentypen
Normalisierung (1. 2. 3. BC 4. 5.)
Redundanz #t, zusätzlichen Spalten
Generalisierung


--DB Design

--Normalisierung ist ok.. aber Redundanz ist schnell
--#tabellen sind Redundanz, 
	
--zusätzlich Spalten wie Rechnugssumme.. aber wie pflegen ? Trigger ..schlechte performance, evtl in Logik (Porzeduren auslagern), 
	dann aber mit Rechten absichern


--Datentypen

/*  Otto
nvarchar(50)  'otto'    4 
char(50)     'otto                                  '   50
text()   nicht mehr verwenden.. seit SQL 2005 depricated  auch image ..kann 2 GB daten besítzen
nvarchar(50)  'otto'   4   *2   --> 8 
nchar(50)   'otto                         ' 50 * 2 --> 100

n = Unicode 


Regel: bei fixen Längen immer char!


--auschlaggeben ist allerdings auch das Verhalten beim Speichern von Daten in den Datendateien
--siehe Seiten und Blöcke

Seiten : 8192 bytes haben Platz für max 700 Datensätze
 1 DS muss in eine Seiten passen und kann max 8060 belegen
 Seiten kommen 1:1 in Arbeitsspeicher, daher ist es wichtig, dass bei Abfragen die Seitenzahlen, die gbraucht werden ,
 zu reduzieren, um sie peformanter zu machen

8 Seiten am Stück = Block
SQL liest Blockweise aus


--Prüfe im Diagram ob alle PK auf eine Beziehung zu anderen Tabellen (FK) haben--Indizes

--Sind die Datentypen passend?


--Beim Erstellen einer DB: Initialgrößen der Dateien anpassen.. wie groß in 3 Jahren
--Wachstumsraten festlegen: selten aber nicht aufwendig? 1000 MB zB


*/

create database testdb
---> uiuiui viele Fehler!

--GUID
--varchar(50), nvarchar(50), nchar(50), char(50)

*/

use testdb


create table t1 (id int identity, spx char(4100))


insert into t1
select 'XY'
GO 20000

--19 Sekunden--ist aber 160MB
--Wie haben 20000*4kb  80MB


dbcc showcontig ('t1')
-- Gescannte Seiten.............................: 20000
-- Mittlere Seitendichte (voll).....................: 50.79%

set statistics io, time on--io = Seiten,, time Dauer und CPU Zeit in ms
--Achtung Messen kostet

select * from t1 where id  = 100
--Tabelle: "t1". Anzahl von Überprüfungen: 1, logische Lesevorgänge: 20000


--Wo haben wir die 20 Sek her

--Besser durch: Datentypen anpassen
--Anwendung muss redesigned werden

--schlchte Auslastung der Seiten kann man evtl mit Kompression etwas beheben



--man könnte komprimieren
--Tab mit 20000 Seiten ... 16 ms ... 20000 Seiten im RAM (160MB)
--nach Kompression:
--ca 0,5 MB   --> Seiten von IO..ca 30  und wieviel in RAM 0,5MB --- der Client bekommmt 160 MB
---> CPU muss höher weil der der Stream zum Client dekomoriiert
--aber auf dem Server bleibt es komprimiert

USE [testdb]
ALTER TABLE [dbo].[t1] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)


--Normalerweiese werden ca 40 bis 60% Kompressionrate
--meine Erwartung : komp Tabellen sind selten schneller--> RAM Platz für anderer Daten schaffen

---













