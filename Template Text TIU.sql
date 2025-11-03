SELECT  
       --A.TIUTemplateBoilerplateSID
	  B.TemplateName
	 ,B.TemplateType
	  --,B.TIUDocumentDefinitionSID
	  --,B.TemplateInactive
      --,A.TIUTemplateIEN
      --,A.TIUTemplateSID
      --,A.Sta3n
      ,A.TemplateName
      ,A.BoilerplateText
	  --,C.StaffName
  FROM LSV.Dim.TIUTemplateBoilerplate AS A
  LEFT JOIN LSV.Dim.TIUTemplate AS B ON A.TIUTemplateSID=B.TIUTemplateSID AND B.Sta3n=612
  LEFT JOIN LSV.SStaff.SStaff AS C ON B.TemplateStaffSID=C.StaffSID AND C.Sta3n=612
  WHERE --A.Sta3n=691
  --AND A.BoilerplateText LIKE ('%MEDICATION WORKSHEET%')
  C.StaffName IN ('SIDHU,NAVPREET K')
  --AND A.TemplateName LIKE ('%Anesthesia Pre-Op Eval%')
  ORDER BY A.TemplateName ASC
  
