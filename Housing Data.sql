SELECT * FROM [dbo].[Housing Data]

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE, SaleDate) FROM [dbo].[Housing Data]

-- Update SaleDate column

UPDATE [dbo].[Housing Data]
SET SaleDate=CONVERT(DATE, SaleDate)

-- if the above code doesn't work, alter and then update

ALTER TABLE [dbo].[Housing Data]
Add SaleDateConverted Date
UPDATE [dbo].[Housing Data]
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted FROM [dbo].[Housing Data]

SELECT * FROM [dbo].[Housing Data]
WHERE PropertyAddress is Null
ORDER BY ParcelID

-- Parcel id will have its uniques property address. But the dataset contains few parcel ids with NULL address. So let's corrrect this data. Replace the property adress of duplicate parcel ids with same property address

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

-- Split Address into Individual Columns (Address, City, State)

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

-- simpler way

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

-- Delete Unused Columns

ALTER TABLE [dbo].[Housing Data]
DROP Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

SELECT * FROM [dbo].[Housing Data]

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM [dbo].[Housing Data]
GROUP BY SoldAsVacant
ORDER BY 2

-- Use CASE logical statement

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

-- Remove Duplicates by Non-recursive Common Table Expression (CTE). Display the row number. 'RowNumCTE' is the expression name. 'row_num' is the column name

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
)

SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY [PropertyAddress]

DELETE FROM RowNumCTE
WHERE row_num > 1

SELECT * FROM [dbo].[Housing Data]
