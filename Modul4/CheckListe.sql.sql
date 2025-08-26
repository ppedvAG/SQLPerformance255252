/* 
   SQL Server Post-Install / Post-Upgrade Check
   Zeigt empfohlene Werte vs. aktuelle Konfiguration.
*/

PRINT '=== INSTANZWEITE EINSTELLUNGEN ===';
SELECT name, value, value_in_use, description
FROM sys.configurations
WHERE name IN (
    'max degree of parallelism',
    'cost threshold for parallelism',
    'max server memory (MB)',
    'min server memory (MB)',
    'optimize for ad hoc workloads'
)
ORDER BY name;

PRINT '=== TEMPDB DATEIEN ===';
SELECT name, size*8/1024 AS size_MB, growth*8/1024 AS growth_MB, is_percent_growth
FROM tempdb.sys.database_files;

PRINT '=== AUTO_CLOSE / AUTO_SHRINK ===';
SELECT name, is_auto_close_on, is_auto_shrink_on, compatibility_level
FROM sys.databases
WHERE database_id > 4; -- nur User-Datenbanken

PRINT '=== INSTANT FILE INITIALIZATION CHECK ===';
-- Prüfen über erteilte Rechte (nur Sysadmin kann es sehen)
--EXEC xp_cmdshell 'whoami /priv';   --> wird nicht klappen:-)
EXEC xp_readerrorlog 0, 1, N'Instant File Initialization';

-- Achte auf: "SeManageVolumePrivilege" -> Enabled = IFI aktiv

PRINT '=== RECOVERY MODEL ===';
SELECT name, recovery_model_desc
FROM sys.databases
WHERE database_id > 4;

PRINT '=== BACKUP-ALTERS-CHECK ===';
SELECT d.name,
       DATEDIFF(DAY, MAX(b.backup_finish_date), GETDATE()) AS DaysSinceLastBackup
FROM sys.databases d
LEFT JOIN msdb.dbo.backupset b ON b.database_name = d.name AND b.type='D'
GROUP BY d.name;

PRINT '=== AUTO UPDATE STATISTICS ===';
SELECT name, is_auto_update_stats_on, is_auto_update_stats_async_on
FROM sys.databases
WHERE database_id > 4;

PRINT '=== SERVER PATCH LEVEL ===';
SELECT @@VERSION AS SQLServerVersion;

