USE CDWWork

SELECT 
      T.TIUTemplateIEN      
	  ,TD.TIUDocumentDefinition
	  ,RD.ReminderName
	  ,RD.ReminderDialogIEN      
	  ,T.TemplateName
      ,T.TemplateType
      ,T.TemplateInactiveFlag
 
  FROM Dim.TIUTemplate as T
  INNER JOIN CRP.ReminderDialog AS RD ON T.ReminderDialogSID = RD.ReminderDialogSID
  LEFT JOIN DIM.TIUDocumentDefinition AS TD ON T.TIUDocumentDefinitionSID = TD.TIUDocumentDefinitionSID
  where T.sta3n = 612 AND RD.Sta3n = 612 AND TD.Sta3n = 612
  AND T.REMINDERDIALOGSID <> '-1'
  ORDER BY TD.TIUDocumentDefinition