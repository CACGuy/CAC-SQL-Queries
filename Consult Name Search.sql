--This query will pull from the consult service dimension table to allow for quick search
--based upon consult name and/or service usage.  IFC fields and administrative status are included in output.

USE LSV 

SELECT  
      Sta3n
      ,ServiceName
      ,ServiceUsage     
      ,InternalName      
      ,IFCRoutingInstitution
      ,IFCRemoteServiceName      
      ,AdministrativeFlag
  FROM Dim.RequestService
  WHERE Sta3n=612
 --AND ServiceUsage IN ('GROUPER ONLY')
 --AND (ServiceName LIKE ('%TELE%') AND ServiceName LIKE ('%EYE%')
 --)
 --AND (ServiceUsage IS NULL OR ServiceUsage IN ('TRACKING'))
 AND ServiceName IN ('COMMUNITY CARE-BH RESIDENTIAL TREATMENT')
 ORDER BY ServiceName ASC
