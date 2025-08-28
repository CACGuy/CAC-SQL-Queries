
-- This is a series of 2 different temporary tables that are then combined in the 3rd query.
-- First query will isolate for station 612 the assigned staff assigned secondary menu options from VISTA
-- and pull in staff name and position information.  The second query 

-- STAFF temp table to pull VISTA permissions and staff information.
IF object_id('TEMPDB..#STAFF') is not null DROP TABLE #STAFF
SELECT DISTINCT
       A.MenuOptionSID
	  ,A.StaffSID
	  ,B.DisUserFlag
	  ,B.SignatureBlockName
	  ,B.SignatureBlockTitle
      ,B.StaffName
	  ,B.ServiceSection
	  ,B.PositionTitle		 
  INTO #STAFF      
  FROM LSV.StaffSub.SecondaryMenuOption AS A
    INNER JOIN LSV.SStaff.SStaff AS B ON A.StaffSID=B.StaffSID AND B.Sta3n=612
  WHERE A.Sta3n=612
   AND B.InactivationDateTime IS NULL
   --AND B.ServiceSection LIKE ('%PHYSICAL MED%')
   --AND B.PositionTitle IN ('SOCIAL WORKER')

-- MENU temp table to isolate specific menu option name.
IF object_id('TEMPDB..#MENU') is not null DROP TABLE #MENU
SELECT DISTINCT
	 MenuOptionName AS MENU_NAME
	 ,MenuOptionSID
INTO #MENU
FROM LSV.dim.MenuOption
WHERE Sta3n=612
AND MenuOptionName IN ('YSMANAGER')

-- Associate staff to keys from both temp tables.
SELECT
 A.StaffName
,A.ServiceSection
,A.PositionTitle
,MENU_NAME
FROM #STAFF AS A
LEFT JOIN #MENU AS B ON A.MenuOptionSID=B.MenuOptionSID
WHERE 
--A.PositionTitle IN ('ATTENDING','ATTENDING PHYSICIAN','ATTENDING NEUROLOGIST','NURSE PRACTITIONER')
B.MENU_NAME IS NOT NULL

