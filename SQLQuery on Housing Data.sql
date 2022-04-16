/* Create data in SQL

*/

select * from 
PortfolioProject1.dbo.NashilleHousing

------------------------------------------------------------------------------------------------------

-- Standardize date format

Select SaleDateConverted, CONVERT (Date, SaleDate)
from PortfolioProject1.dbo.NashilleHousing

Update NashilleHousing 
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashilleHousing
Add SaleDateConverted Date;

Update NashilleHousing 
SET SaleDateConverted = CONVERT(Date, SaleDate)

-----------------------------------------------------------------------------------------------------------------

-- Populate property address
-- Select all columns will No property address and fill them with missing values

Select *
from PortfolioProject1.dbo.NashilleHousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1.dbo.NashilleHousing a
Join PortfolioProject1.dbo.NashilleHousing b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1.dbo.NashilleHousing a
Join PortfolioProject1.dbo.NashilleHousing b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
---------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
--I split the property address seperated by comma and have it in different columns

Select PropertyAddress
from PortfolioProject1.dbo.NashilleHousing
--where PropertyAddress is null

Select 

SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from PortfolioProject1.dbo.NashilleHousing

ALTER TABLE NashilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



Select *

from PortfolioProject1.dbo.NashilleHousing

---------------------------------------------------------------------------------------------------------
-- Breaking out OwnerAddress into individual columns (Address, City, State)
-- I split the OwnerAddress into three columns and create new empty columns and add those values/data in there.

Select OwnerAddress
from PortfolioProject1.dbo.NashilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',','.'),3),
PARSENAME(Replace(OwnerAddress, ',','.'),2),
PARSENAME(Replace(OwnerAddress, ',','.'),1)
from PortfolioProject1.dbo.NashilleHousing

Select SaleDateConverted, CONVERT (Date, SaleDate)
from PortfolioProject1.dbo.NashilleHousing


ALTER TABLE NashilleHousing
Add OwnerSplitAddress1 Nvarchar(255);

Update NashilleHousing 
SET OwnerSplitAddress1 = PARSENAME(Replace(OwnerAddress, ',','.'),3)


ALTER TABLE NashilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashilleHousing 
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'),2)

ALTER TABLE NashilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashilleHousing 
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),1)

Select *
from PortfolioProject1.dbo.NashilleHousing
---------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject1.dbo.NashilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject1.dbo.NashilleHousing

Update NashilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


---------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					 UniqueID
					 ) row_num

from PortfolioProject1.dbo.NashilleHousing
)
Select *
from RowNumCTE
where row_num > 1


------------------------------------------------------------------------------------------------------

--Delete unused columns

Select * 
from PortfolioProject1.dbo.NashilleHousing

ALTER TABLE PortfolioProject1.dbo.NashilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject1.dbo.NashilleHousing
DROP COLUMN OwnerSplitAddress

ALTER TABLE PortfolioProject1.dbo.NashilleHousing
DROP COLUMN SaleDate