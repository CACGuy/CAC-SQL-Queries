SELECT  TIUTemplateFieldSID
      ,TIUTemplateFieldIEN
      ,Sta3n
      ,TemplateFieldName
      ,TemplateFieldType
      ,InactiveFlag
      ,TextBoxLength
      ,DefaultText
      ,BoilerplateText
      ,DefaultLineNumberIndex      
      ,DateType
      ,ConsultLockFlag
      ,TemplateFieldURL
  FROM CDWWork.Dim.TIUTemplateField
  WHERE Sta3n=612
  AND InactiveFlag IN ('N')
  ORDER BY TemplateFieldName ASC
