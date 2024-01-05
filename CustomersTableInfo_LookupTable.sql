use AdventureWorks2014

SELECT 
per.BusinessEntityID as PersonID, 
cast(ISNULL(per.FirstName,'')+' '+ISNULL(per.MiddleName,'')+' '+ISNULL(per.LastName,'') as nvarchar(50)) as Customer_Name,
addr.AddressLine1 as Address1, addr.AddressLine2 as Address2, addr.city as City, perpho.PhoneNumber as Phone
FROM Person.Person per
LEFT JOIN Person.BusinessEntityAddress BEA
ON per.BusinessEntityID = BEA.BusinessEntityID
LEFT JOIN Person.Address addr
ON addr.AddressID = BEA.AddressID
LEFT JOIN Person.PersonPhone perpho
ON perpho.BusinessEntityID = per.BusinessEntityID
union all
select null,null,null,null,null,null