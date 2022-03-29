--Clead Housing Data in SQL Queries

--Knowing about data
SELECT * FROM `brave-watch-343605.Housing1.HouseData`

---------------------------------------------------------------------------------------------------------------------------

--Standardize the sale date format
UPDATE `brave-watch-343605.Housing1.HouseData`
SET SaleDate = convert(Date,SaleDate)

-- Populate property address data
SELECT * FROM `brave-watch-343605.Housing1.HouseData`
where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
FROM `brave-watch-343605.Housing1.HouseData` a
JOIN `brave-watch-343605.Housing1.HouseData` b
on a.uniqueID_ != b.UniqueID_
AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress is null
order by a.ParcelID

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM `brave-watch-343605.Housing1.HouseData` a
JOIN `brave-watch-343605.Housing1.HouseData` b
on a.uniqueID_ != b.UniqueID_
AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress is null

-- Breaking out Address into Individual Columns
Select PropertyAddress
FROM `brave-watch-343605.Housing1.HouseData`
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
--MySQL INSTR(source_value, search_value [, position[, occurrence ]])
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

--UpdateSplitAddress
ALTER TABLE HouseData
ADD PropertySplitAddress Nvarchar(255);

UPDATE `brave-watch-343605.Housing1.HouseData`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

--UpdateSplitCity
ALTER TABLE HouseData
ADD PropertySplitCity Nvarchar(255);

UPDATE `brave-watch-343605.Housing1.HouseData`
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
FROM `brave-watch-343605.Housing1.HouseData`


--Split Owner Address

SELECT OwnerAddress
FROM `brave-watch-343605.Housing1.HouseData`


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM `brave-watch-343605.Housing1.HouseData`


--UpdateOwnerSplitAddress
ALTER TABLE HouseData
ADD OwnerSplitAddress Nvarchar(255);

UPDATE `brave-watch-343605.Housing1.HouseData`
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

--UpdateOwnerSplitCity
ALTER TABLE HouseData
ADD OwnerSplitCity Nvarchar(255);

UPDATE `brave-watch-343605.Housing1.HouseData`
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


--UpdateOwnerSplitState
ALTER TABLE HouseData
ADD OwnerSplitState Nvarchar(255);

UPDATE `brave-watch-343605.Housing1.HouseData`
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM `brave-watch-343605.Housing1.HouseData`


--Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM `brave-watch-343605.Housing1.HouseData`
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant END
FROM `brave-watch-343605.Housing1.HouseData`

UPDATE `brave-watch-343605.Housing1.HouseData`
SET SoldAsVacant = (CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END


-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
uniqueID_
) row_num

FROM `brave-watch-343605.Housing1.HouseData`
--order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



SELECT *
FROM `brave-watch-343605.Housing1.HouseData`


--Delete Unused Columns
SELECT *
FROM `brave-watch-343605.Housing1.HouseData`

ALTER TABLE HouseData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
