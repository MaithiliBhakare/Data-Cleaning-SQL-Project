SELECT * FROM [dbo].[Housing Data]

SELECT SaleDate, CONVERT(DATE, SaleDate) FROM [dbo].[Housing Data]

UPDATE [dbo].[Housing Data]
SET SaleDate=CONVERT(DATE, SaleDate)

ALTER TABLE [dbo].[Housing Data]
Add SaleDateConverted Date
UPDATE [dbo].[Housing Data]
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted FROM [dbo].[Housing Data]

SELECT * FROM [dbo].[Housing Data]
--WHERE PropertyAddress is Null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM [dbo].[Housing Data] a
Join [dbo].[Housing Data] b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Housing Data] a
Join [dbo].[Housing Data] b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

SELECT PropertyAddress FROM [dbo].[Housing Data]

SELECT substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM [dbo].[Housing Data]

ALTER TABLE [dbo].[Housing Data]
Add PropertySplitAddress nvarchar(255)
UPDATE [dbo].[Housing Data]
SET PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

ALTER TABLE [dbo].[Housing Data]
Add PropertySplitCity nvarchar(255)
UPDATE [dbo].[Housing Data]
SET PropertySplitCity = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

SELECT * FROM [dbo].[Housing Data]

SELECT OwnerAddress FROM [dbo].[Housing Data]

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 
FROM [dbo].[Housing Data]

ALTER TABLE [dbo].[Housing Data]
Add OwnerSplitAdd nvarchar(255)
UPDATE [dbo].[Housing Data]
SET OwnerSplitAdd = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE [dbo].[Housing Data]
Add OwnerSplitCity nvarchar(255)
UPDATE [dbo].[Housing Data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE [dbo].[Housing Data]
Add OwnerSplitState nvarchar(255)
UPDATE [dbo].[Housing Data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT * FROM [dbo].[Housing Data]

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM [dbo].[Housing Data]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, CASE when SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
FROM [dbo].[Housing Data]

UPDATE [dbo].[Housing Data]
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM [dbo].[Housing Data]
GROUP BY SoldAsVacant
ORDER BY 2

WITH RowNumCTE as(
SELECT *, 
ROW_NUMBER() OVER (
Partition By [ParcelID], [PropertyAddress],
[SaleDate],
[SalePrice],
[LegalReference]
ORDER BY
[UniqueID ]) row_num
FROM [dbo].[Housing Data]
--ORDER BY ParcelID
)

DELETE FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT * FROM [dbo].[Housing Data]

ALTER TABLE [dbo].[Housing Data]
DROP Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

SELECT * FROM [dbo].[Housing Data]