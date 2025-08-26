			  SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    fg.name AS FilegroupName
FROM sys.tables AS t
JOIN sys.schemas AS s 
    ON t.schema_id = s.schema_id
JOIN sys.indexes AS i 
    ON t.object_id = i.object_id 
   AND i.index_id IN (0,1)  -- 0 = Heap, 1 = Clustered Index
JOIN sys.filegroups AS fg 
    ON i.data_space_id = fg.data_space_id
ORDER BY 
    s.name,
    t.name;
