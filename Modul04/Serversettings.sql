 1. Instanzweite Einstellungen (sp_configure)
a) Max Degree of Parallelism (MAXDOP)

Was prüfen: Standard ist 0 → SQL Server nutzt alle CPUs für parallele Pläne.

Best Practice:
OLTP: meist 1–4 (abhängig von CPU-Sockel/NUMA)
OLAP/Data Warehouse: >4 möglich, aber nicht automatisch max. Kerne
Microsoft empfiehlt: MAXDOP = #CPUs pro NUMA-Knoten, max. 8

b) Cost Threshold for Parallelism
Was prüfen: Standard ist 5 → sehr niedrig, führt zu 
unnötiger Parallelität.
Best Practice: Auf 30–50 erhöhen (Workload messen, ggf. anpassen).

c) Max Server Memory
Was prüfen: Standard ist dynamisch, was zu wenig OS-Reserve f
ühren kann.

Best Practice: OS 2–4 GB + 1 GB je 4 GB RAM >16 GB reservieren.

Beispiel: 64 GB Server → Max Server Memory ca. 56–58 GB setzen.

d) Min Server Memory
Was prüfen: Standard ist 0.
Best Practice: Nur in speziellen Fällen 
z. B. bei dedizierten DB-Servern) anpassen, typischerweise 10–25 % vom Max Memory.

e) Optimize for Ad Hoc Workloads
Was prüfen: Standard ist 0.
Best Practice: 1 setzen, wenn viele einmalige 
Ad-hoc-Abfragen → reduziert Plan-Cache-Müll.

f) Remote Query Timeout
Was prüfen: Standard ist 600 Sekunden.
Best Practice: Nur anpassen, falls lange verteilte Queries notwendig sind.

2. Server- und Systemkonfiguration
a) TempDB-Konfiguration

Was prüfen:
Anzahl der Dateien → Standard ist 1 Datei.
Autogrowth → Standardmäßig oft in MB, zu klein.

Best Practice:
1 Datei pro 4 CPU-Kerne (max. 8), 
gleiche Größe + Autogrowth in MB, nicht %

Vorinitialisierung auf ausreichend große Größe (z. B. 1 GB+)

b) Daten- und Log-Dateien
Autogrowth prüfen: Prozentwerte vermeiden, 
lieber feste MB-Schritte.

Initialgröße: direkt groß genug wählen
→ Fragmentierung vermeiden.

File Placement: Logs und Daten (ggf. TempDB) auf separaten Volumes.

c) Instant File Initialization (IFI)
Was prüfen: Standard aus, außer per 
Local Security Policy konfiguriert.

Best Practice: Einschalten 
(Recht "Perform volume maintenance tasks") → schnellere Datenbankerstellung und Wachstum.

d) Power Plan (Betriebssystem)

Was prüfen: Windows-Standard ist 
„Balanced“ → CPU throttling.
Best Practice: High Performance aktivieren.

e) NUMA und Hyper-Threading
Prüfen: Automatische Konfiguration durch SQL Server; 
nur bei Problemen manuell eingreifen.

3. Wartungs- und Sicherheitsaspekte
a) SQL Server Patch Level
Was prüfen: Nach Installation immer CU 
(Cumulative Updates) einspielen.

b) Wartungspläne oder Agent-Jobs

Was prüfen:
Indexpflege: Rebuild/Reorganize sinnvoll planen, 
nicht blind alles täglich.

Statistiken: Regelmäßig aktualisieren, 
AUTO_UPDATE_STATISTICS sollte an sein.

c) Backup-Strategie
Sicherstellen, dass Full/Log/Diff-Backups 
eingerichtet sind, nicht nur „Full“ sporadisch.

d) Security & Oberfläche
SA-Konto: deaktivieren oder Passwort ändern.
TCP-Port: prüfen, ob Default (1433) nötig
oder angepasst werden sollte.

Surface Area: unnötige Features 
(z. B. OLE Automation, xp_cmdshell) deaktivieren.

4. Datenbank-Optionen (pro DB prüfen)
AUTO_CLOSE: sollte OFF sein.
AUTO_SHRINK: sollte OFF sein.
Compatibility Level: nach Upgrade prüfen 
Standard bleibt auf altem Level!).
Recovery Model: an Backup-Konzept anpassen (Full vs. Simple).

Kurz-Checkliste nach Installation/Upgrade

Aktuelles CU installieren
MAXDOP, Cost Threshold, Max/Min Memory einstellen
TempDB mit mehreren Dateien und sinnvoller Größe konfigurieren

IFI aktivieren (instant file initialization)

Power Plan → High Performance
Auto Close/Auto Shrink prüfen
Backup- und Wartungspläne einrichten
Security-Grundlagen absichern