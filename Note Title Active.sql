IF OBJECT_ID('tempdb..#TITLES') IS NOT NULL DROP TABLE #TITLES
SELECT 
 A.TIUDocumentDefinition AS Progress_Note_Title
,A.TIUDocumentDefinitionSID
,A.TIUDocumentDefinitionType AS Type

,AA.TIUStatus AS Status

INTO #TITLES
FROM LSV.dim.TIUDocumentDefinition AS A
INNER JOIN LSV.dim.TIUStatus AS AA ON A.TIUStatusSID=AA.TIUStatusSID AND AA.Sta3n=612
WHERE 
A.Sta3n=612
AND AA.TIUStatus IN ('ACTIVE')
AND A.TIUDocumentDefinitionType IN ('TITLE')
AND A.TIUDocumentDefinition LIKE ('%Get Well%')

SELECT * FROM #TITLES
ORDER BY Progress_Note_Title ASC