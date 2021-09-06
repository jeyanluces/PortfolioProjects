/*
	
	DATA CLEANING IN SQL QUERIES

*/

--SELECT *
--FROM PortfolioProject.dbo.NashvilleHousing;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

--SELECT SaleDate, CONVERT(Date, SaleDate)
--FROM PortfolioProject.dbo.NashvilleHousing;

--UPDATE NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate);

--ALTER TABLE NashvilleHousing
--ADD SaleDateConverted Date;

--UPDATE NashvilleHousing
--SET SaleDateConverted = CONVERT(Date,SaleDate);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

--SELECT *
--FROM PortfolioProject.dbo.NashvilleHousing
----WHERE PropertyAddress IS NULL
--ORDER BY ParcelID;

---Fetches the data (BEFORE)
--SELECT A.ParcelID
--			 , A.PropertyAddress
--			 ,	B.ParcelID
--			 , B.PropertyAddress
--			 , ISNULL(A.PropertyAddress, B.PropertyAddress)
--FROM PortfolioProject.dbo.NashvilleHousing AS A
--JOIN PortfolioProject.dbo.NashvilleHousing AS B
--	ON A.ParcelID = B.ParcelID
--	AND A.[UniqueID ] <> B.[UniqueID ]
--WHERE A.PropertyAddress IS NULL;

---Fetches the data (AFTER)
--SELECT A.ParcelID
--			, A.PropertyAddress
--			,	B.ParcelID
--			, B.PropertyAddress
--FROM PortfolioProject.dbo.NashvilleHousing AS A
--JOIN PortfolioProject.dbo.NashvilleHousing AS B
--ON A.ParcelID = B.ParcelID
--AND A.[UniqueID ] <> B.[UniqueID ];

---Sets B to A so there's no more Null
--UPDATE A
--SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
--FROM PortfolioProject.dbo.NashvilleHousing AS A
--JOIN PortfolioProject.dbo.NashvilleHousing AS B
--	ON A.ParcelID = B.ParcelID
--	AND A.[UniqueID ] <> B.[UniqueID ]
--WHERE A.PropertyAddress IS NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking Out Address Into Individual Columns (Address, City, State)

--SELECT PropertyAddress
--FROM PortfolioProject.dbo.NashvilleHousing;

----- METHOD 1: Using Subtring ------
--CharIndex specifies the position number, the -1 in the charindex excludes the comma, +1 position after the comma
--SELECT
--	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
--	, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
--FROM PortfolioProject.dbo.NashvilleHousing;

--ALTER TABLE NashvilleHousing
--Add PropertySplitAddress Nvarchar(255);

--Update NashvilleHousing
--SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

--ALTER TABLE NashvilleHousing
--Add PropertySplitCity Nvarchar(255);

--Update NashvilleHousing
--SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

----- METHOD 2: Using Parsename -----
--SELECT OwnerAddress
--FROM PortfolioProject.dbo.NashvilleHousing
--WHERE OwnerAddress IS NOT NULL;

-------- Separates by PERIOD -------
--SELECT 
--	PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 3) --Address
--	, PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 2) --City
--	, PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 1) --State
--FROM PortfolioProject.dbo.NashvilleHousing;

--ALTER TABLE NashvilleHousing
--Add OwnerSplitAddress Nvarchar(255);

--Update NashvilleHousing
--SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 3) --Address

--ALTER TABLE NashvilleHousing
--Add OwnerSplitCity Nvarchar(255);

--Update NashvilleHousing
--SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 2) --City

--ALTER TABLE NashvilleHousing
--Add OwnerSplitState Nvarchar(255);

--Update NashvilleHousing
--SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') , 1) --State

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Field

--Checks all the distinct values in Field--
--SELECT DISTINCT(SoldAsVacant)
--	, COUNT(SoldAsVacant)
--FROM PortfolioProject.dbo.NashvilleHousing
--GROUP BY SoldAsVacant
--ORDER BY 2;

--SELECT SoldAsVacant
--	, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
--				WHEN SoldAsVacant = 'N' THEN 'No'
--				ELSE SoldAsVacant
--				END
--FROM PortfolioProject.dbo.NashvilleHousing;

----- Changes the SoldAsVacant ----
--Update NashvilleHousing
--SET SoldAsVacant = 
--				CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
--				WHEN SoldAsVacant = 'N' THEN 'No'
--				ELSE SoldAsVacant
--				END;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Removes Duplicates

----- Acts as a Temp Table, list the partition by ColumnNames that shouldn't have similar values ---
--WITH RowNumCTE AS (
--	SELECT *
--		,   ROW_NUMBER () OVER (
--			PARTITION BY ParcelID
--									, PropertyAddress
--									, SalePrice
--									, SaleDate
--									, LegalReference
--									ORDER BY UniqueID )
--			ROW_NUM
--FROM PortfolioProject.dbo.NashvilleHousing
--)
------ Selects all the duplicates > 104 rows
--SELECT *
--FROM RowNumCTE
--WHERE ROW_NUM > 1
--ORDER BY PropertyAddress;

---- Deletes all the duplicates > 104 rows
--DELETE  
--FROM RowNumCTE
--WHERE ROW_NUM > 1;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Deletes Unused Columns

--SELECT *
--FROM PortfolioProject.dbo.NashvilleHousing

--ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
--DROP COLUMN PropertyAddress, OwnerAddress, SaleDate;
