
-- Common table expression SURROGATES to identify all staff for station 612 that have or do not have a surrogate set.
-- First table expression will look for station 612 staff surrogate file to pull start and stop dates and join to staff files
-- for staff recipient and surrogate information.  The second table expression looks at the staff file to pull staff names
-- that have the Disuser Flag at Y, a termination date, OR inactivation date.
-- The final query pulls the staff that are disusered/terminated/inactivated that DO NOT have a surrogate start date time.
-- Position title will help with determination of staff that should have a surrogate set.

;WITH SURROGATES AS
   (SELECT 
       A.RecipientStaffSID
      ,B.StaffName AS RecipientName
	  ,B.PositionTitle AS RecipientPosition
	  ,C.StaffName AS AssignedSurrogateName
	  ,C.PositionTitle AS SurrogatePosition
      ,A.SurrogateStartDateTime            
      ,A.SurrogateEndDateTime  
    FROM LSV.ViewAlert.ViewAlert AS A
     LEFT JOIN LSV.SStaff.SStaff AS B ON A.RecipientStaffSID=B.StaffSID
     LEFT JOIN LSV.SStaff.SStaff AS C ON A.SurrogateStaffSID=C.StaffSID
    WHERE A.Sta3n = 612    
   ),
TERM AS
   (SELECT
     A.StaffSID
	,A.StaffName
	,A.PositionTitle
	,A.ServiceSection
	,A.DisUserFlag
	,A.TerminationDateTime
	,A.InactivationDateTime
	FROM LSV.SStaff.SStaff AS A
	WHERE Sta3n=612
	AND (DisUserFlag IN ('Y')
	  OR TerminationDateTime IS NOT NULL
	  OR InactivationDateTime IS NOT NULL)
   )


SELECT 
  T.*
 ,S.SurrogateStartDateTime
 FROM TERM AS T
  LEFT JOIN SURROGATES S ON T.StaffSID=S.RecipientStaffSID
 WHERE S.SurrogateStartDateTime IS NULL
 ORDER BY TerminationDateTime,InactivationDateTime,PositionTitle DESC

  ;
