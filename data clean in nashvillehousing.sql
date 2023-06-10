select * 
from [portfolioproject].[dbo].[nashvillehousing]

--standarize date format
select saledate , CONVERT (date,saledate)
from [portfolioproject].[dbo].[nashvillehousing]

update [portfolioproject].[dbo].[nashvillehousing]
set SaleDate = convert (date,saledate)

alter table [portfolioproject].[dbo].[nashvillehousing]
alter column saledate  date

select saledate 
from [portfolioproject].[dbo].[nashvillehousing]



--populate property address data
select PropertyAddress 
from [portfolioproject].[dbo].[nashvillehousing] 
where PropertyAddress is null

select a.PropertyAddress , a.ParcelID , b.PropertyAddress , b.ParcelID ,isnull (a.PropertyAddress , b.propertyaddress)
from [portfolioproject].[dbo].[nashvillehousing] a
join [portfolioproject].[dbo].[nashvillehousing] b
on  a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.propertyaddress =isnull (a.PropertyAddress , b.propertyaddress)
from [portfolioproject].[dbo].[nashvillehousing] a
join [portfolioproject].[dbo].[nashvillehousing] b
on  a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out adderess into individual column (address,city,state)

select PropertyAddress 
from [portfolioproject].[dbo].[nashvillehousing]

select SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))
from [portfolioproject].[dbo].[nashvillehousing] 

alter table [portfolioproject].[dbo].[nashvillehousing]
add propertysplitaddress nvarchar(255)
 update [portfolioproject].[dbo].[nashvillehousing]
 set propertysplitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

 alter table [portfolioproject].[dbo].[nashvillehousing]
add propertysplitcity nvarchar(255)
 update [portfolioproject].[dbo].[nashvillehousing]
 set propertysplitcity = SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))



 select OwnerAddress
from [portfolioproject].[dbo].[nashvillehousing]

select PARSENAME(replace(owneraddress , ',','.'),3),
PARSENAME(replace(owneraddress , ',','.'),2),
PARSENAME(replace(owneraddress , ',','.'),1)
from [portfolioproject].[dbo].[nashvillehousing]

alter table [portfolioproject].[dbo].[nashvillehousing]
add ownersplitaddress nvarchar(255)
 update [portfolioproject].[dbo].[nashvillehousing]
 set ownersplitaddress = PARSENAME(replace(owneraddress , ',','.'),3)

 alter table [portfolioproject].[dbo].[nashvillehousing]
add ownersplitcity nvarchar(255)
 update [portfolioproject].[dbo].[nashvillehousing]
 set ownersplitcity = PARSENAME(replace(owneraddress , ',','.'),2)


 alter table [portfolioproject].[dbo].[nashvillehousing]
add ownersplitstate nvarchar(255)
 update [portfolioproject].[dbo].[nashvillehousing]
 set ownersplitstate = PARSENAME(replace(owneraddress , ',','.'),1)

 select * 
from [portfolioproject].[dbo].[nashvillehousing]


--change y and n to yes and no in 'sold as vacant' field
  select distinct SoldAsVacant , count (soldasvacant)
from [portfolioproject].[dbo].[nashvillehousing]
group by SoldAsVacant
order by 2

 select SoldAsVacant,
 case when SoldAsVacant = 'y' then 'yes'
           when SoldAsVacant = 'n' then 'no'
				  else SoldAsVacant
				  end 
from [portfolioproject].[dbo].[nashvillehousing]

update [portfolioproject].[dbo].[nashvillehousing]
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
           when SoldAsVacant = 'n' then 'no'
				  else SoldAsVacant
				  end 

select  distinct SoldAsVacant
from [portfolioproject].[dbo].[nashvillehousing]

--remove duplicates
with raw_numcte as (
select * ,
ROW_NUMBER()over
(partition by parcelid,propertyaddress,saleprice,saledate,legalreference
order by
uniqueid) raw_num
from [portfolioproject].[dbo].[nashvillehousing]
--order by ParcelID
)
select *
from raw_numcte
where raw_num >1


--delete unused column

alter table [portfolioproject].[dbo].[nashvillehousing]
drop column propertyaddress,owneraddress

select * 
from [portfolioproject].[dbo].[nashvillehousing]










