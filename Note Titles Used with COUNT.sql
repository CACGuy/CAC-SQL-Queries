--This query is a series temporary tables thats pull note title completion information as well
--as an active note title list for the station.  The final query table uses all of this inforamtion
--to determine note title usage.

USE CDWWORK	
-- Temp table for Note Title completion since 01/01/2018
-- This also pulls in patient name/ssn, staff author
IF OBJECT_ID('tempdb..#NOTES') IS NOT NULL DROP TABLE #NOTES
SELECT
D.PatientName
,D.PatientSSN
,B.TIUDocumentDefinition AS Authored_Notes
,E.TIUStandardTitle
,A.EpisodeBeginDateTime
,A.EntryDateTime
,A.SignatureDateTime	
,A.SignedByStaffSID
,C.StaffName AS AUTHOR_DICTATOR
,C.ServiceSection
,A.TIUDocumentDefinitionSID
INTO #NOTES
FROM Tiu.TIUDocument AS A 
LEFT JOIN dim.TIUDocumentDefinition B ON A.TIUDocumentDefinitionSID=B.TIUDocumentDefinitionSID AND B.Sta3n=612
LEFT JOIN (SELECT Sta3n,StaffName, StaffSID, ServiceSection FROM SStaff.SStaff) C ON A.AuthorDictatorStaffSID=C.StaffSID AND C.sta3n=612
LEFT JOIN (SELECT Sta3n,PatientSID, PatientLastName,PatientName,PatientSSN FROM SPatient.SPatient) D ON A.PatientSID=D.PatientSID AND D.Sta3n=612
LEFT JOIN dim.TIUStandardTitle E ON B.TIUStandardTitleSID=E.TIUStandardTitleSID AND B.Sta3n=612
WHERE 	
	A.sta3n=612
	AND A.EpisodeBeginDateTime >= CAST('2025-01-01 00:00:00' AS datetime2 (0))
	AND A.EpisodeBeginDateTime <= CAST('2025-03-09 00:00:00' AS datetime2 (0))
	--AND B.TIUDocumentDefinition LIKE ('%HEALTH AND WELLNESS COACHING%')
	--AND C.StaffName IN ('HAGER,KELLY M')

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
AND B.TIUStatus IN ('ACTIVE')
AND A.TIUDocumentDefinitionType IN ('TITLE')
AND A.TIUDocumentDefinition LIKE ('%MOVE%')
--AND A.TIUDocumentDefinitionSID IN ('1600060858')

-- *******************************
-- Final query from TITLES temp table, joining to NOTES temp table, count note usage 

SELECT 
 B.PatientName
,B.PatientSSN
,A.TIUDocumentDefinition AS Progress_Note_Title
,B.TIUStandardTitle AS Standard_Title
,B.EntryDateTime
 ,COUNT(A.TIUDocumentDefinition) AS Usage_1YR
,A.TIUStatus AS Status
,A.TIUDocumentDefinitionType AS Type
,B.AUTHOR_DICTATOR
,B.ServiceSection
,B.SignatureDateTime
FROM #TITLES AS A
LEFT JOIN #NOTES AS B ON A.TIUDocumentDefinitionSID=B.TIUDocumentDefinitionSID
WHERE A.TIUDocumentDefinitionSID IN (SELECT TIUDocumentDefinitionSID FROM #NOTES)
--AND B.ServiceSection IN ('REMOTE')
GROUP BY A.TIUDocumentDefinition, A.TIUStatus, A.TIUDocumentDefinitionType, B.AUTHOR_DICTATOR, B.PatientName, B.PatientSSN, B.EntryDateTime, B.SignatureDateTime, B.ServiceSection, B.TIUStandardTitle
ORDER BY EntryDateTime, A.TIUDocumentDefinition, AUTHOR_DICTATOR DESC
