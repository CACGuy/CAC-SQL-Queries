

USE CDWORK

IF OBJECT_ID('tempdb..#NOTES') IS NOT NULL DROP TABLE #NOTES
SELECT
D.PatientName
--,LEFT (D.PatientLastName,1)+RIGHT (D.PatientSSN,4) AS LAST4
,D.PatientSSN
,B.TIUDocumentDefinition
,A.EntryDateTime
,C.StaffName AS AUTHOR_DICTATOR
,E.LocationName
,F.TIUStatus AS NOTE_STATUS



INTO #NOTES

FROM LSV.TIU.TIUDocument A 
INNER JOIN dim.TIUDocumentDefinition B ON A.TIUDocumentDefinitionSID=B.TIUDocumentDefinitionSID AND B.Sta3n=612
INNER JOIN (SELECT StaffName, StaffSID, Sta3n FROM SStaff.SStaff WHERE Sta3n=612) C ON A.AuthorDictatorStaffSID=C.StaffSID
INNER JOIN (SELECT Sta3n,PatientSID, PatientLastName,PatientName,PatientSSN FROM SPatient.SPatient WHERE Sta3n=612) D ON A.PatientSID=D.PatientSID 
INNER JOIN dim.Location E ON A.DocumentLocationSID = E.LocationSID
INNER JOIN dim.TIUStatus F ON A.TIUStatusSID=F.TIUStatusSID AND F.Sta3n=612

WHERE 	
	A.sta3n=612
	--AND C.StaffName IN ('OLSEN,MARYNA M') 
	--AND B.TIUDocumentDefinition LIKE ('%EMERGENCY DEPARTMENT%')
	--AND (B.TIUDocumentDefinitionSID IN ('800143054')
	    --OR B.TIUDocumentDefinitionSID IN ('800143057')
		--OR B.TIUDocumentDefinitionSID IN ('800143058')
        --OR B.TIUDocumentDefinitionSID IN ('800143055')
		--OR B.TIUDocumentDefinitionSID IN ('800143056')
		                                                 --)
	AND D.PatientSID IN ('800256426')
	AND A.EntryDateTime >= CAST(CAST(GETDATE()-365  AS DATE) AS DATETIME2(0))

ORDER BY A.EntryDateTime

SELECT * 
FROM #NOTES
ORDER BY EntryDateTime DESC