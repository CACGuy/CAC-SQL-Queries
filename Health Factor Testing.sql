--IF OBJECT_ID ('TEMPDB..#PROCEDURESHF') IS NOT NULL DROP TABLE #PROCEDURESHF
SELECT *
--INTO #PROCEDURESHF
FROM
   (SELECT DISTINCT
      C.PatientName
	  ,C.PatientSSN
	  ,C.PatientSID
	  ,D.TIUDocumentDefinitionSID
	  ,E.TIUDocumentDefinition
	  ,A.VisitSID
	  ,CONVERT(DATE,A.VisitDateTime) AS VISIT_DATE
	  ,B.HealthFactorType
	  ,B.HealthFactorTypeSID
	  ,B.HealthFactorCategory
	  ,A.HealthFactorDateTime
	  ,A.Comments
	  ,ROW_NUMBER() OVER (PARTITION BY A.VisitSID ORDER BY A.HealthFactorTypeSID ASC) AS HFNUMBER
      
      FROM LSV.HF.HealthFactor AS A
      LEFT JOIN LSV.DIM.HealthFactorType AS B ON A.HealthFactorTypeSID=B.HealthFactorTypeSID
      LEFT JOIN LSV.SPatient.SPatient AS C ON A.PatientSID=C.PatientSID
	  LEFT JOIN LSV.TIU.TIUDocument AS D ON A.VisitSID=D.VisitSID
	  LEFT JOIN LSV.dim.TIUDocumentDefinition AS E ON E.TIUDocumentDefinitionSID=D.TIUDocumentDefinitionSID

      WHERE A.Sta3n = 612 AND B.Sta3n = 612 AND C.Sta3n = 612 and D.Sta3n=612 AND E.Sta3n=612
      --AND C.PatientName LIKE ('SHELDON,MIKE C%')
	  AND B.HealthFactorType LIKE ('%SMOKING%')
	  --AND HealthFactorCategory LIKE ('TOBACCO CESSATION%')
	  AND A.HealthFactorDateTime >= CAST('2023-04-01 00:00:00' AS datetime2 (0))
	  )AS T1
	   
ORDER BY HealthFactorDateTime DESC