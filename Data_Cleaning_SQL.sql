--Cleaning Data 
select *
from Project.dbo.NashvilleHousing

--Getting Property Address Data
select *
from Project.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--Putting Address into Indiv Columns


select PropertyAddress
from Project.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

from Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Project.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Project.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Project.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


select SoldAsVacant
from Project.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Project.dbo.NashvilleHousing


ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Project.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Project.dbo.NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Project.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Remove Duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
	UniqueID
	) row_num
from Project.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--Delete Unused Column

alter table Project.dbo.NashvilleHousing
drop column SaleDate, OwnerAddress, TaxDistrict, PropertyAddress








