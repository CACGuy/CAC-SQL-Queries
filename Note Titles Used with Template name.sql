USE CDWWORK	
-- Temp table for Note Title completion since 01/01/2018
-- This also pulls in patient name/ssn, staff author
IF OBJECT_ID('tempdb..#NOTES') IS NOT NULL DROP TABLE #NOTES
SELECT
D.PatientName
,D.PatientSSN
,B.TIUDocumentDefinition AS Authored_Notes
,A.EpisodeBeginDateTime
,A.EntryDateTime
,A.SignatureDateTime	
,A.SignedByStaffSID
,C.StaffName AS AUTHOR_DICTATOR
,A.TIUDocumentDefinitionSID
,E.TemplateName
,E.TemplateType
INTO #NOTES
FROM Tiu.TIUDocument AS A 
LEFT JOIN dim.TIUDocumentDefinition B ON A.TIUDocumentDefinitionSID=B.TIUDocumentDefinitionSID AND B.Sta3n=612
LEFT JOIN (SELECT Sta3n,StaffName, StaffSID FROM SStaff.SStaff) C ON A.AuthorDictatorStaffSID=C.StaffSID AND C.sta3n=612
LEFT JOIN (SELECT Sta3n,PatientSID, PatientLastName,PatientName,PatientSSN FROM SPatient.SPatient) D ON A.PatientSID=D.PatientSID AND D.Sta3n=612
INNER JOIN dim.TIUTemplate AS E ON A.TIUDocumentDefinitionSID=E.TIUDocumentDefinitionSID AND E.Sta3n=612
WHERE 	
	A.sta3n=612
	AND A.EpisodeBeginDateTime >= CAST('2021-01-01 00:00:00' AS datetime2 (0))
	--AND A.EpisodeBeginDateTime <= CAST('2023-09-01 00:00:00' AS datetime2 (0))
	--AND B.TIUDocumentDefinition LIKE ('%CONSULT REPORT%')

-- ******************************
-- 2nd Temp Table that pulls all ACTIVE note titles for station 612
IF OBJECT_ID('tempdb..#TITLES') IS NOT NULL DROP TABLE #TITLES
SELECT 
 A.TIUDocumentDefinition
,A.TIUDocumentDefinitionSID
,A.TIUDocumentDefinitionType
,B.TIUStatus
INTO #TITLES
FROM dim.TIUDocumentDefinition AS A
INNER JOIN dim.TIUStatus AS B ON A.TIUStatusSID=B.TIUStatusSID 

WHERE 
A.Sta3n=612
--AND B.TIUStatus IN ('ACTIVE')
AND A.TIUDocumentDefinitionType IN ('TITLE')
AND A.TIUDocumentDefinition IN ('INJECTIONS, IMMUNIZATIONS, SKIN TESTS')

-- *******************************
-- Final query from TITLES temp table, joining to NOTES temp table, count note usage 

SELECT 
 B.PatientName
,B.PatientSSN
,B.EntryDateTime
,A.TIUDocumentDefinition AS Progress_Note_Title 
,A.TIUStatus AS Status
,A.TIUDocumentDefinitionType AS Type
,B.TemplateName
,B.TemplateType
,B.AUTHOR_DICTATOR
FROM #TITLES AS A
LEFT JOIN #NOTES AS B ON A.TIUDocumentDefinitionSID=B.TIUDocumentDefinitionSID
WHERE A.TIUDocumentDefinitionSID IN (SELECT TIUDocumentDefinitionSID FROM #NOTES)
ORDER BY B.EntryDateTime DESC
