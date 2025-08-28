-- This query will look for CPRS orders allowing you to filter by display group name, orderable item name,
-- staff entered name, and order status for station 612

USE LSV
GO

SELECT DISTINCT
  P.PatientName
, P.PatientSSN
, A.CPRSOrderSID
, A.CPRSOrderIEN
, S.StaffName as 'Entered By'
, S.PositionTitle
, S.ProviderClass
, A.EnteredDateTime
, V.DisplayGroupName
, F.OrderableItemName
, W.OrderStatus
 
FROM CPRSOrder.CPRSOrder AS A
INNER JOIN CPRSOrder.OrderedItem AS E ON E.CPRSOrderSID=a.CPRSOrderSID AND E.STA3N=612
INNER JOIN dim.OrderableItem AS F ON F.OrderableItemSID=e.OrderableItemSID AND F.STA3N=612
INNER JOIN SPatient.SPatient AS P ON P.PatientSID=a.PatientSID AND P.STA3N=612
INNER JOIN SStaff.SStaff AS S ON S.StaffSID=A.EnteredByStaffSID AND S.STA3N=612
INNER JOIN dim.DisplayGroup AS V ON A.DisplayGroupSID=V.DisplayGroupSID AND A.sta3n=612
INNER JOIN dim.OrderStatus AS W ON A.OrderStatusSID=W.OrderStatusSID AND W.STA3N=612
 
WHERE
A.STA3N = 612
AND A.EnteredDateTime >= CAST('2023-07-23 00:00:00' AS datetime2 (0))
AND S.StaffName IN ('ELNAN,MIRA ROSE')
--AND w.OrderStatus IN ('ACTIVE') 
--AND a.EnteredByStaffIEN LIKE '529543444%' 
 
ORDER BY a.EnteredDateTime,w.OrderStatus ASC